//
//  CCSharedData.m
//  CollegeComparison
//
//  Created by Anthony Forsythe on 1/2/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import "CCSharedData.h"

@implementation CCSharedData {
    
    NSMutableDictionary *informationDict;
    NSArray *theColleges;
    
}

+ (id)sharedInstance {
    
    static id sharedInstance = nil;
    
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
        [sharedInstance initialConfiguration];
    }
    
    return sharedInstance;
}
//static CCSharedData *_sharedInstance = nil;
//static dispatch_once_t once_token = 0;
//
//+(instancetype)sharedDataObject {
//    dispatch_once(&once_token, ^{
//        if (_sharedInstance == nil) {
//            _sharedInstance = [[CCSharedData alloc] init];
//        }
//    });
//    return _sharedInstance;
//}
//
//
//static CCSharedData *sharedSync = nil;
//
//+(CCSharedData*)sharedDataObject {
//
//    __strong static id _sharedObject = nil;
//    static dispatch_once_t onceToken;
//    
//    dispatch_once(&onceToken, ^{
//        _sharedObject = [[CCSharedData alloc] init];
//        [_sharedObject initialConfiguration];
//    });
//    
//    return _sharedObject;
//    
//}

- (void)callToApi
{
    NSString *UrlString = @"http://54.201.179.180/api/api.php?method=getCollege&range=all";
    
    NSURL *Url = [NSURL URLWithString:UrlString];
    
    NSURLRequest *theRequest = [[NSURLRequest alloc] initWithURL:Url];
    NSOperationQueue *theQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:theQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        
        if (httpResponse.statusCode == 200 && data) {
            [self saveData:data];
            
            
        }
    }];
    
}



-(NSArray*)getCollegesSortedByValue:(NSString *)value AndAscending:(BOOL)ascending
{
    NSNumberFormatter *nf = [NSNumberFormatter new];
    
    NSNumber *check = [nf numberFromString:value];
    
    BOOL isNumber = (check != nil);

    
    
    
    
    
    if ([value isEqualToString:@"out_state_tuition"])
    {
        NSArray *sortedArray = [theColleges sortedArrayUsingComparator:^(NSDictionary* obj1, NSDictionary* obj2) {
            NSNumber *num1 = [nf numberFromString:[obj1 objectForKey:@"out_state_tuition"]];
            NSNumber *num2 = [nf numberFromString:[obj2 objectForKey:@"out_state_tuition"]];
            return (NSComparisonResult)[num1 compare:num2];
        }];
        
        return sortedArray;
    }

        NSArray *sortedArray;
        
        if(value == nil)
        {
            sortedArray = [NSArray arrayWithArray:theColleges];
        }
        
        NSSortDescriptor* brandDescriptor = [[NSSortDescriptor alloc] initWithKey:value ascending:ascending];
        NSArray* sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
        
        sortedArray = [theColleges sortedArrayUsingDescriptors:sortDescriptors];
        
        
        
        
        return sortedArray;
    
    
    
    
}

-(void)saveData:(NSData*) theData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDirectory);
    //make a full file name
    NSString *fileName = [NSString stringWithFormat:@"%@/theData.txt", documentsDirectory];
    NSLog(@"File path and name:%@", fileName);
    
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: fileName ] == YES)
        NSLog (@"File exists");
    else
    {
        NSLog (@"File not found");
        [filemgr createFileAtPath:fileName contents:nil attributes:nil];
    }
    
    NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
    if (myHandle == nil)
        NSLog(@"Failed to open file");
    NSString *content;
    NSData *myData;
    
    [myHandle seekToFileOffset:0];
    [myHandle writeData:theData];
    [self getData];
}

-(void)getData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDirectory);
    //make a full file name
    NSString *fileName = [NSString stringWithFormat:@"%@/theData.txt", documentsDirectory];
    NSLog(@"File path and name:%@", fileName);
    
    NSData *myData = [NSData dataWithContentsOfFile:fileName];
    
    
    NSError *error = nil;
    
    NSDictionary *theDictionary = [NSJSONSerialization JSONObjectWithData:myData options:0 error:&error];
    
    NSArray *colleges = theDictionary[@"colleges"];
    
    NSMutableArray *protoColleges = [NSMutableArray new];
    
    for (NSDictionary *theDict in colleges)
    {
        NSDictionary *newDictionary = [NSDictionary dictionaryWithDictionary:theDict];
        [protoColleges addObject:newDictionary];
    }
    
    theColleges = [NSArray arrayWithArray:protoColleges];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didFinishDownloadingColleges" object:self];

}

-(void)initialConfiguration
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDirectory);
    //make a full file name
    NSString *fileName = [NSString stringWithFormat:@"%@/theData.txt", documentsDirectory];
    NSLog(@"File path and name:%@", fileName);

    NSFileManager *newMgr = [NSFileManager defaultManager];
    
    BOOL fileExists = [newMgr fileExistsAtPath:fileName];
    
    if (fileExists) {
        [self getData];
        [self testing];

    }
    else
    {
        [self callToApi];
    }
    
    
    
}

-(void)testing
{
    
//for (NSDictionary *first in theColleges)
//{
//    NSLog(@"\n\nName: %@\n\n", [first objectForKey:@"name"]);
//
//}
    
    NSDictionary *first = theColleges[0];
    
    NSLog(@"\n\nName: %@\n\n", [first objectForKey:@"name"]);

}

@end

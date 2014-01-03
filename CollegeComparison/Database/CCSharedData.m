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

static CCSharedData *sharedDataObject = nil;

+(CCSharedData*)sharedDataObject {
    static CCSharedData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CCSharedData alloc] init];
        [sharedInstance callToApi];
    });
    
    return sharedInstance;
}


- (void)callToApi
{
    NSString *UrlString = @"http://54.201.179.180/api/api.php?method=getCollege&range=all";
    
    NSURL *Url = [NSURL URLWithString:UrlString];
    
    NSURLRequest *theRequest = [[NSURLRequest alloc] initWithURL:Url];
    NSOperationQueue *theQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:theQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        
        if (httpResponse.statusCode == 200 && data) {
            [self parseData:data];
            
            
        }
    }];
    
}


-(void)parseData:(NSData*)data
{
    NSError *error = nil;
    
    NSDictionary *theDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    
    
    NSArray *colleges = theDictionary[@"colleges"];
    
    NSMutableArray *protoColleges = [NSMutableArray new];
    
    for (NSDictionary *theDict in colleges)
    {
        NSDictionary *newDictionary = [NSDictionary dictionaryWithDictionary:theDict];
        [protoColleges addObject:newDictionary];
    }
    
    theColleges = [NSArray arrayWithArray:protoColleges];
    NSLog(@"HELLOHELADFLKJA;LDSKJFAL;");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didFinishDownloadingColleges" object:self];
}

-(NSArray*)getCollegesSortedByValue:(NSString *)value AndAscending:(BOOL)ascending
{
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

@end

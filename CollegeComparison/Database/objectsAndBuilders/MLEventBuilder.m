//
//  MLEventBuilder.m
//  AppointlinkStoryboard
//
//  Created by Anthony Forsythe on 1/10/14.
//  Copyright (c) 2014 ARF. All rights reserved.
//

#import "MLEventBuilder.h"
#import "MLEventsObject.h"

@implementation MLEventBuilder

+ (NSArray*)EventsFromJSON:(NSData *)theData error:(NSError *__autoreleasing *)error
{
    
    NSError *localError = nil;
    
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&localError];
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *arrayToReturn = [NSMutableArray new];
    
    NSArray *arrayOfAnnouncements = [parsedObject objectForKey:@"announcements"];
    
    for (NSDictionary *announcementDict in arrayOfAnnouncements)
    {
        MLEventsObject *event = [MLEventsObject new];
        
        event.title = [announcementDict objectForKey:@"title"];
        event.body = [announcementDict objectForKey:@"body"];
        NSLog(@"\n\nThe Date: %@\n\n", [announcementDict objectForKey:@"date"]);
        event.department = [announcementDict objectForKey:@"department"];
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *dateFromString = [df dateFromString:[announcementDict objectForKey:@"date"]];
        NSDate *datePosted = [df dateFromString:[announcementDict objectForKey:@"datePosted"]];
        
        
                              
        event.datePosted = datePosted;
        event.date = dateFromString;
        
        [arrayToReturn addObject:event];
        
    }
    
    
    
    return arrayToReturn;
    
}
-(NSDate*)createDateWithString:(NSString*) theDate
{
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd-MM-yyyy"];
    
    NSDate *dateFromString = [df dateFromString:theDate];
    
    return dateFromString;
}


@end

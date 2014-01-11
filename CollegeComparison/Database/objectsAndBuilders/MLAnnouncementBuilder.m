//
//  MLAnnouncementBuilder.m
//  AppointlinkStoryboard
//
//  Created by Anthony Forsythe on 1/10/14.
//  Copyright (c) 2014 ARF. All rights reserved.
//

#import "MLAnnouncementBuilder.h"
#import "MLAnnouncement Object.h"

@implementation MLAnnouncementBuilder

+ (NSArray*)announcementsFromJSON:(NSData *)theData error:(NSError *__autoreleasing *)error
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
        MLAnnouncement_Object *announcement = [MLAnnouncement_Object new];
        
        announcement.title = [announcementDict objectForKey:@"title"];
        announcement.body = [announcementDict objectForKey:@"body"];
        //announcement.date = [announcementDict objectForKey:@"date"];
        announcement.department = [announcementDict objectForKey:@"department"];
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *dateFromString = [df dateFromString:[announcementDict objectForKey:@"date"]];
        
        announcement.date = dateFromString;
        
        [arrayToReturn addObject:announcement];
        
    }

    
    
    return arrayToReturn;
    
}
@end

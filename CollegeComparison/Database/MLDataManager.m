//
//  MLDataManager.m
//  AppointlinkStoryboard
//
//  Created by Anthony Forsythe on 1/10/14.
//  Copyright (c) 2014 ARF. All rights reserved.
//

#import "MLDataManager.h"
#import "MLDataCommunicator.h"
#import "MLAnnouncementBuilder.h"
#import "MLEventBuilder.h"

@implementation MLDataManager

-(void)fetchAnnouncementsWithUser:(NSString *)user
{
    [self.communicator getAnnouncementsForUser:user];
}
-(void)fetchEventsWithUser:(NSString *)user
{
    [self.communicator getEventsForUser:user];
}
#pragma mark - Communicator Delegate

-(void)receivedAnnouncementsJSON:(NSData *)theData
{
    NSError *error = nil;
    NSArray *announcements = [MLAnnouncementBuilder announcementsFromJSON:theData error:&error];
    
    if (error != nil) {
        [self.delegate fetchingAnnouncementsFailedWithError:error];
    }
    else
    {
        [self.delegate didReceiveAnnouncements:announcements];
    }
    
    
}
-(void)receivedEventsJSON:(NSData *)theData
{
    NSError *error = nil;
    NSArray *announcements = [MLEventBuilder EventsFromJSON:theData error:&error];
    
    if (error != nil) {
        [self.delegate fetchingAnnouncementsFailedWithError:error];
    }
    else
    {
        [self.delegate didReceiveEvents:announcements];
    }
}

-(void)fetchingFailedWithError:(NSError *)error
{
    [self.delegate fetchingAnnouncementsFailedWithError:error];
}

@end

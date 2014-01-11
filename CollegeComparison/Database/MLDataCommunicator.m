//
//  MLDataCommunicator.m
//  AppointlinkStoryboard
//
//  Created by Anthony Forsythe on 1/10/14.
//  Copyright (c) 2014 ARF. All rights reserved.
//

#import "MLDataCommunicator.h"
#import "MLCommunicatorDelegate.h"

#define URLSTRING @"http://54.201.179.180/api/appointlinkapi.php?method=getAll"
#define EVENTSURLSTRING @"http://54.201.179.180/api/appointlinkapi.php?method=getAllEvents"

@implementation MLDataCommunicator

-(void)getAnnouncementsForUser:(NSString *) user
{
    NSURL *url = [[NSURL alloc] initWithString:URLSTRING];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       
        if (connectionError) {
            [self.delegate fetchingFailedWithError:connectionError];
        }
        else
        {
            [self.delegate receivedAnnouncementsJSON:data];
        }
    }];
    
}
-(void)getEventsForUser:(NSString *)user
{
    NSURL *url = [[NSURL alloc] initWithString:EVENTSURLSTRING];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError) {
            [self.delegate fetchingFailedWithError:connectionError];
        }
        else
        {
            [self.delegate receivedEventsJSON:data];
        }
    }];
}
@end

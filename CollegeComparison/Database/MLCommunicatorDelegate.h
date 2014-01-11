//
//  MLCommunicatorDelegate.h
//  AppointlinkStoryboard
//
//  Created by Anthony Forsythe on 1/10/14.
//  Copyright (c) 2014 ARF. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MLCommunicatorDelegate <NSObject>

-(void)receivedAnnouncementsJSON:(NSData*) theData;
-(void)fetchingFailedWithError:(NSError*) error;
-(void)receivedEventsJSON:(NSData*) theData;


@end

//
//  MLDataCommunicator.h
//  AppointlinkStoryboard
//
//  Created by Anthony Forsythe on 1/10/14.
//  Copyright (c) 2014 ARF. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MLCommunicatorDelegate;

@interface MLDataCommunicator : NSObject
@property (nonatomic, weak) id<MLCommunicatorDelegate> delegate;

-(void)getAnnouncementsForUser:(NSString*) user;
-(void)getEventsForUser:(NSString*) user;


@end

//
//  MLDataManager.h
//  AppointlinkStoryboard
//
//  Created by Anthony Forsythe on 1/10/14.
//  Copyright (c) 2014 ARF. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MLDataManagerDelegate.h"
#import "MLCommunicatorDelegate.h"

@class MLDataCommunicator;

@interface MLDataManager : NSObject <MLCommunicatorDelegate>
@property (strong, nonatomic) MLDataCommunicator *communicator;
@property (weak, nonatomic) id<MLDataManagerDelegate> delegate;

-(void)fetchAnnouncementsWithUser:(NSString*) user;
-(void)fetchEventsWithUser:(NSString*) user;



@end

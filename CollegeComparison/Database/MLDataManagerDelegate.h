//
//  MLDataManagerDelegate.h
//  AppointlinkStoryboard
//
//  Created by Anthony Forsythe on 1/10/14.
//  Copyright (c) 2014 ARF. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MLDataManagerDelegate <NSObject>

-(void)didReceiveAnnouncements:(NSArray*) announcements;
-(void)didReceiveEvents:(NSArray*) events;
-(void)fetchingAnnouncementsFailedWithError:(NSError*) error;

@end

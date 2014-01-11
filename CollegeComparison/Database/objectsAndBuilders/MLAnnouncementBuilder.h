//
//  MLAnnouncementBuilder.h
//  AppointlinkStoryboard
//
//  Created by Anthony Forsythe on 1/10/14.
//  Copyright (c) 2014 ARF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLAnnouncementBuilder : NSObject

+ (NSArray *)announcementsFromJSON:(NSData *) theData error:(NSError**) error;

@end

//
//  MLEventBuilder.h
//  AppointlinkStoryboard
//
//  Created by Anthony Forsythe on 1/10/14.
//  Copyright (c) 2014 ARF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLEventBuilder : NSObject

+ (NSArray *)EventsFromJSON:(NSData *) theData error:(NSError**) error;

@end

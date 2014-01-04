//
//  CCSharedData.h
//  CollegeComparison
//
//  Created by Anthony Forsythe on 1/2/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCSharedData : NSObject {
    
}


+ (instancetype)sharedInstance;

-(NSArray*)getCollegesSortedByValue:(NSString*) value AndAscending:(BOOL) ascending;

@end

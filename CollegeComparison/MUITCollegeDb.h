//
//  MUITCollegeDb.h
//  CollegeComparison
//
//  Created by CompSci on 11/10/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface MUITCollegeDb : NSObject

-(NSArray*) findSchool:(NSString*)keyword;

@end

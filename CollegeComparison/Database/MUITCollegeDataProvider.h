//
//  MUITCollegeDataProvider.h
//  testing file
//
//  Created by David Boullion on 11/5/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "MUITCollege.h"

@interface MUITCollegeDataProvider : NSObject

//METHODS:

-(NSMutableArray*) getColleges:(NSMutableDictionary*)parameters;

-(void) sortCollegeArray:(NSMutableArray*)collegeArray sortKey:(NSString*)sortKey ascending:(BOOL) ascending;

@end

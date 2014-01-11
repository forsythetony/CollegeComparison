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

//Public methods to retrieve data
-(NSMutableArray*) getColleges:(NSMutableDictionary*)parameters;

-(NSArray*)getDummyColleges;

@end

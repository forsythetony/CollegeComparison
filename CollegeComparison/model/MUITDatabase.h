//
//  MUITDatabase.h
//  CollegeComparison1
//
//  Created by Josh on 11/10/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface MUITDatabase : NSObject

-(NSString *) setDBPath:(NSString *)filename :(NSSearchPathDirectory)directory;
+(sqlite3 *) connectToDB:(NSString *)path;
+(NSString *) convertStringToCommaDelim:(NSString *)string;
-(void) copyDBIfNeeded:(NSString *)path :(NSString *) filename;

@end

//
//  MUITCollegeDb.m
//  CollegeComparison
//
//  Created by CompSci on 11/10/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "MUITCollegeDb.h"

static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation MUITCollegeDb
-(NSArray*) findSchool:(NSString *)keyword {
    BOOL fileExist;
    NSArray * dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * documentPath = [[dirPath objectAtIndex:0] stringByAppendingPathComponent:@"database.db"];
    
    fileExist = [[NSFileManager alloc] fileExistsAtPath:documentPath];
    
    if(fileExist){
    
    if (sqlite3_open([documentPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"select * from schools where INSTITUTION=\"%@\"",keyword];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
                NSString *fee2 = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                NSLog(fee2);
                [resultArray addObject:fee2];
                NSString *year = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:year];
                return resultArray;
            }
            else{
                NSLog(@"Not found");
                return nil;
            }
            sqlite3_reset(statement);
        }
    }

    }
        return NULL;
}
@end

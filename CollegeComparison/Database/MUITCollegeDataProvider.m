//
//  MUITCollegeDataProvider.m
//  testing file
//
//  Created by David Boullion on 11/5/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "MUITCollegeDataProvider.h"

@implementation MUITCollegeDataProvider

static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

-(NSMutableArray*) getColleges:(NSMutableDictionary*)parameters
{
    //default parameters
    if (![parameters objectForKey:@"name"]) {
        [parameters setObject:@"" forKey:@"name"];
    }
    if (![parameters objectForKey:@"state"]) {
        [parameters setObject:@"" forKey:@"state"];
    }
    if (![parameters objectForKey:@"out_state_tuition_min"]) {
        [parameters setObject:@"0" forKey:@"out_state_tuition_min"];
    }
    if ([parameters objectForKey:@"out_state_tuition_max"]) {
        NSString* str = [NSString stringWithFormat:@"and out_state_tuition < %@", [parameters objectForKey:@"out_state_tuition_max"]];
        [parameters setObject:str forKey:@"out_state_tuition_max"];
    } else {
        [parameters setObject:@"" forKey:@"out_state_tuition_max"];
    }
    
    if (![parameters objectForKey:@"school_type"]) {
        [parameters setObject:@">-1" forKey:@"school_type"];
    } else if ([[parameters objectForKey:@"school_type"]  isEqual: @"public"]) {
        [parameters setObject:@"=1" forKey:@"school_type"];
    } else if ([[parameters objectForKey:@"school_type"]  isEqual: @"private"]) {
        [parameters setObject:@"=2" forKey:@"school_type"];
    }
    
    if (![parameters objectForKey:@"enrollment_total_min"]) {
        [parameters setObject:@"0" forKey:@"enrollment_total_min"];
    }
    
    if (![parameters objectForKey:@"enrollment_total_max"]) {
        [parameters setObject:@"" forKey:@"enrollment_total_max"];
    } else {
        NSString* str = [NSString stringWithFormat:@"and enrollment_total < %@", [parameters objectForKey:@"enrollment_total_max"]];
        [parameters setObject:str forKey:@"enrollment_total_max"];
    }
    

    NSMutableArray *collegeArray = [NSMutableArray new];

    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  // Get the path to the database file
    NSString *documentPath = [searchPaths objectAtIndex:0];
    NSString *databasePath = [documentPath stringByAppendingPathComponent:@"schools.db"];
    
    //NSLog(@"Database Path: %@", databasePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:databasePath])
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat: @"SELECT DISTINCT * FROM basic_data AS bd, test_scores AS ts, financial_aid AS fa, enrollment AS en, tuition AS tu WHERE bd.UNITID = ts.UNITID AND bd.UNITID = fa.UNITID AND bd.UNITID = en.UNITID AND bd.UNITID = tu.UNITID AND INSTNM LIKE '%%%@%%' AND out_state_tuition > %@ %@ AND CONTROL %@ AND enrollment_total > %@ %@", [parameters objectForKey:@"name"], [parameters objectForKey:@"out_state_tuition_min"], [parameters objectForKey:@"out_state_tuition_max"], [parameters objectForKey:@"school_type"], [parameters objectForKey:@"enrollment_total_min"], [parameters objectForKey:@"enrollment_total_max"]];
            NSLog(@"%@", querySQL);
            
            const char *query_stmt = [querySQL UTF8String];
            if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)//get colleges while true (gets all valid colleges)
                {
                    MUITCollege *college = [MUITCollege new];
                    
                    college.name = [NSString stringWithCString:(const char *) sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];

                    college.id = (int)sqlite3_column_int(statement, 0);
                    college.control = (int)sqlite3_column_int(statement, 3);
                    college.state = [NSString stringWithCString:(const char *) sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
                    
                    college.sat_reading_25 = (int)sqlite3_column_int(statement, 5);
                    college.sat_reading_75 = (int)sqlite3_column_int(statement, 6);
                    
                    college.sat_math_25 = (int)sqlite3_column_int(statement, 7);
                    college.sat_math_75 = (int)sqlite3_column_int(statement, 8);
                    
                    college.sat_writing_25 = (int)sqlite3_column_int(statement, 9);
                    college.sat_writing_75 = (int)sqlite3_column_int(statement, 10);
                    
                    college.act_25 = (int)sqlite3_column_int(statement, 11);
                    college.act_75 = (int)sqlite3_column_int(statement, 12);
                    
                    college.act_english_25 = (int)sqlite3_column_int(statement, 13);
                    college.act_english_75 = (int)sqlite3_column_int(statement, 14);
                    
                    college.act_math_25 = (int)sqlite3_column_int(statement, 15);
                    college.act_math_75 = (int)sqlite3_column_int(statement, 16);
                    
                    college.act_writing_25 = (int)sqlite3_column_int(statement, 17);
                    college.act_writing_75 = (int)sqlite3_column_int(statement, 18);
                    
                    college.percent_receive_financial_aid = (int) sqlite3_column_int(statement, 20);

                    college.enrollment_men = (int) sqlite3_column_int(statement, 21);
                    college.enrollment_women = (int) sqlite3_column_int(statement, 23);

                    college.enrollment_total = (int) sqlite3_column_int(statement, 22);
                    
                    college.tuition_out_state = (int) sqlite3_column_int(statement, 26);
                    college.tuition_in_state = (int) sqlite3_column_int(statement, 27);
                    
                    [collegeArray addObject:college];
                }
                
                //[self sortCollegeArray:collegeArray sortKey:@"institution" ascending:YES];
                sqlite3_reset(statement);
                return collegeArray;
                
            }
        }
        
    }
    return nil;//something happened; file not valid.
}

//-(void) sortCollegeArray:(NSMutableArray*)collegeArray sortKey:(NSString*)sortKey ascending:(BOOL) ascending//NOT CURRENTLY FUNCTIONAL
//{
//    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascending];
//    [collegeArray sortUsingDescriptors: @[descriptor]];
//}

@end

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

#pragma mark Actual Data Methods -
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
            NSString *querySQL = [NSString stringWithFormat: @"SELECT DISTINCT * from basic_data, test_scores, financial_aid, enrollment, tuition where basic_data.UNITID = test_scores.UNITID and basic_data.UNITID = financial_aid.UNITID and basic_data.UNITID = enrollment.UNITID and basic_data.UNITID = tuition.UNITID and INSTNM LIKE '%%%@%%' and out_state_tuition > %@ %@ and CONTROL %@ and enrollment_total > %@ %@", [parameters objectForKey:@"name"], [parameters objectForKey:@"out_state_tuition_min"], [parameters objectForKey:@"out_state_tuition_max"], [parameters objectForKey:@"school_type"], [parameters objectForKey:@"enrollment_total_min"], [parameters objectForKey:@"enrollment_total_max"]];
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

#pragma mark Dummy Data Methods -
-(NSArray *)getDummyColleges
{

    NSMutableArray *protoDummyColleges = [NSMutableArray new];
    
    for (int i = 0; i < 3; i++) {
        
        MUITCollege *dummyCollege = [MUITCollege new];
        NSDictionary *valuesDictionary;
        NSArray *ar1, *ar2;
        
        ar1 = [NSArray arrayWithObjects:
               @"name",
               @"id",
               @"control",
               @"state",
               @"sat_reading_25",
               @"sat_reading_75",
               @"sat_math_25",
               @"sat_math_75",
               @"sat_writing_25",
               @"sat_writing_75",
               @"act_25",
               @"act_75",
               @"act_english_25",
               @"act_english_75",
               @"act_math_25",
               @"act_math_75",
               @"act_writing_25",
               @"act_writing_75",
               @"percent_receive_financial_aid",
               @"enrollment_men",
               @"enrollment_women",
               @"enrollment_total",
               @"tuition_out_state",
               @"tuition_in_state",
               nil];
        
        switch (i) {
            case 0:
                ar2 = [NSArray arrayWithObjects:
                       @"University of Missouri - St. Louis", //School Name
                       [NSNumber numberWithInt:88732], //id
                       [NSNumber numberWithInt:3], //control
                       @"MO", //State
                       [NSNumber numberWithInt:0], //sat_reading_25
                       [NSNumber numberWithInt:0], //sat_reading_75
                       [NSNumber numberWithInt:480], //sat_math_25
                       [NSNumber numberWithInt:660], //sat_math_75
                       [NSNumber numberWithInt:0], //sat_writing_25
                       [NSNumber numberWithInt:0], //sat_writing_75
                       [NSNumber numberWithInt:22], //act_25
                       [NSNumber numberWithInt:27], //act_75
                       [NSNumber numberWithInt:21], //act_english_25
                       [NSNumber numberWithInt:27], //act_english_75
                       [NSNumber numberWithInt:20], //act_math_25
                       [NSNumber numberWithInt:26], //act_math_75
                       [NSNumber numberWithInt:0], //act_writing_25
                       [NSNumber numberWithInt:0], //act_writing_75
                       [NSNumber numberWithInt:33], //percent_receive_financial_aid
                       [NSNumber numberWithInt:320], //enrollment_men
                       [NSNumber numberWithInt:226], //enrollment_women
                       [NSNumber numberWithInt:546], //enrollment_total
                       [NSNumber numberWithInt:21537], //tuition_out_state
                       [NSNumber numberWithInt:7968], //tuition_in_state
                       nil];
                break;
                
            case 1:
                ar2 = [NSArray arrayWithObjects:
                       @"New York University", //School Name
                       [NSNumber numberWithInt:193900], //id
                       [NSNumber numberWithInt:6], //control
                       @"NY", //State
                       [NSNumber numberWithInt:620], //sat_reading_25
                       [NSNumber numberWithInt:710], //sat_reading_75
                       [NSNumber numberWithInt:630], //sat_math_25
                       [NSNumber numberWithInt:640], //sat_math_75
                       [NSNumber numberWithInt:640], //sat_writing_25
                       [NSNumber numberWithInt:730], //sat_writing_75
                       [NSNumber numberWithInt:28], //act_25
                       [NSNumber numberWithInt:31], //act_75
                       [NSNumber numberWithInt:0], //act_english_25
                       [NSNumber numberWithInt:0], //act_english_75
                       [NSNumber numberWithInt:0], //act_math_25
                       [NSNumber numberWithInt:0], //act_math_75
                       [NSNumber numberWithInt:0], //act_writing_25
                       [NSNumber numberWithInt:0], //act_writing_75
                       [NSNumber numberWithInt:25], //percent_receive_financial_aid
                       [NSNumber numberWithInt:3087], //enrollment_men
                       [NSNumber numberWithInt:2054], //enrollment_women
                       [NSNumber numberWithInt:5141], //enrollment_total
                       [NSNumber numberWithInt:40878], //tuition_out_state
                       [NSNumber numberWithInt:40878], //tuition_in_state
                       nil];
                break;
            case 2:
                ar2 = [NSArray arrayWithObjects:
                       @"University of Arkansas", //School Name
                       [NSNumber numberWithInt:106397], //id
                       [NSNumber numberWithInt:1], //control
                       @"AR", //State
                       [NSNumber numberWithInt:500], //sat_reading_25
                       [NSNumber numberWithInt:610], //sat_reading_75
                       [NSNumber numberWithInt:520], //sat_math_25
                       [NSNumber numberWithInt:630], //sat_math_75
                       [NSNumber numberWithInt:0], //sat_writing_25
                       [NSNumber numberWithInt:0], //sat_writing_75
                       [NSNumber numberWithInt:23], //act_25
                       [NSNumber numberWithInt:28], //act_75
                       [NSNumber numberWithInt:22], //act_english_25
                       [NSNumber numberWithInt:29], //act_english_75
                       [NSNumber numberWithInt:23], //act_math_25
                       [NSNumber numberWithInt:28], //act_math_75
                       [NSNumber numberWithInt:0], //act_writing_25
                       [NSNumber numberWithInt:0], //act_writing_75
                       [NSNumber numberWithInt:44], //percent_receive_financial_aid
                       [NSNumber numberWithInt:2382], //enrollment_men
                       [NSNumber numberWithInt:2192], //enrollment_women
                       [NSNumber numberWithInt:4574], //enrollment_total
                       [NSNumber numberWithInt:17022], //tuition_out_state
                       [NSNumber numberWithInt:6142], //tuition_in_state
                       nil];
                break;
            default:
                break;
        }
        
        valuesDictionary = [NSDictionary dictionaryWithObjects:ar2 forKeys:ar1];
        
                
                
                dummyCollege.name = [valuesDictionary objectForKey:@"name"];
                
                dummyCollege.id = [[valuesDictionary objectForKey:@"id"] integerValue];
                dummyCollege.control = [valuesDictionary[@"control"] integerValue];
                dummyCollege.state = valuesDictionary[@"state"];
                
                dummyCollege.sat_reading_25 = [valuesDictionary[@"sat_reading_25"] integerValue];
                dummyCollege.sat_reading_75 = [[valuesDictionary objectForKey:@"sat_reading_75"] integerValue];
                
                dummyCollege.sat_math_25 = [[valuesDictionary objectForKey:@"sat_math_25"] integerValue];
                dummyCollege.sat_math_75 = [[valuesDictionary objectForKey:@"sat_math_75"] integerValue];
                
                dummyCollege.sat_writing_25 = [[valuesDictionary objectForKey:@"sat_writing_25"] integerValue];
                dummyCollege.sat_writing_75 = [[valuesDictionary objectForKey:@"sat_writing_75"] integerValue];
                
                dummyCollege.act_25 = [[valuesDictionary objectForKey:@"act_25"] integerValue];
                dummyCollege.act_75 = [[valuesDictionary objectForKey:@"act_75"] integerValue];
                
                dummyCollege.act_english_25 = [[valuesDictionary objectForKey:@"act_english_25"] integerValue];
                dummyCollege.act_english_75 = [[valuesDictionary objectForKey:@"act_english_75"] integerValue];
                
                dummyCollege.act_math_25 = [[valuesDictionary objectForKey:@"act_math_25"] integerValue];
                dummyCollege.act_math_75 = [[valuesDictionary objectForKey:@"act_math_75"] integerValue];
                
                dummyCollege.act_writing_25 = [[valuesDictionary objectForKey:@"act_writing_25"] integerValue];
                dummyCollege.act_writing_75 = [[valuesDictionary objectForKey:@"act_writing_75"] integerValue];
                
                dummyCollege.percent_receive_financial_aid = [[valuesDictionary objectForKey:@"percent_receive_financial_aid"] integerValue];
                
                dummyCollege.enrollment_men = [[valuesDictionary objectForKey:@"enrollment_men"] integerValue];
                dummyCollege.enrollment_women = [[valuesDictionary objectForKey:@"enrollment_women"] integerValue];
                
                dummyCollege.enrollment_total = [[valuesDictionary objectForKey:@"enrollment_total"] integerValue];
                
                dummyCollege.tuition_out_state = [[valuesDictionary objectForKey:@"tuition_out_state"] integerValue];
                dummyCollege.tuition_in_state = [[valuesDictionary objectForKey:@"tuition_in_state"] integerValue];
        
                dummyCollege.pushedFromFavorites = NO;
        
        
        [protoDummyColleges addObject:dummyCollege];
        
    }
    
    NSArray *dummyColleges = [NSArray arrayWithArray:protoDummyColleges];
    
    return dummyColleges;
}

@end

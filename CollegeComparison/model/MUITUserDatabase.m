//
//  MUITUserDatabase.m
//  CollegeComparison1
//
//  Created by Allen Ahner on 12/4/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "MUITUserDatabase.h"

static NSString *dbPath;
static NSString *dbFileName = @"collegeComparisonUserData.sqlite";

@implementation MUITUserDatabase

- (id)init {
    self = [super init];
    dbPath = [super setDBPath:dbFileName :NSDocumentDirectory];
    
    return self;
}

-(void) copyDBIfNeeded
{
    [super copyDBIfNeeded:dbPath :dbFileName];
}

+(sqlite3 *) connectToDB
{
    return [super connectToDB:dbPath];
}

@end

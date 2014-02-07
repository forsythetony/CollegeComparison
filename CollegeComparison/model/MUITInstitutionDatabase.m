//
//  MUITInstitutionDatabase.m
//  CollegeComparison1
//
//  Created by Allen Ahner on 12/1/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "MUITInstitutionDatabase.h"

static NSString *dbPath;
static NSString *dbFileName = @"collegeComparisonInstitutionData.sqlite";

@implementation MUITInstitutionDatabase

-(id)init
{
    self = [super init];
    dbPath = [super setDBPath:dbFileName :NSCachesDirectory];
    
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

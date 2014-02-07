//
//  MUITUserModel.m
//  CollegeComparison1
//
//  Created by Allen Ahner on 11/26/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "MUITUserModel.h"

static sqlite3 *dbConnection;

@implementation MUITUserModel

+(BOOL) removeInstitutionFromFavorites:(NSInteger) id
{
    NSString *query = @"DELETE FROM user_favorite WHERE institution_id = ?";
    const char *sql = [query UTF8String];
    sqlite3_stmt *stmt;
    
    dbConnection = [MUITUserDatabase connectToDB];
    
    sqlite3_prepare_v2(dbConnection, sql, -1, &stmt, NULL);
    sqlite3_bind_int(stmt, 1, (int)id);
    
    if (sqlite3_step(stmt) == SQLITE_DONE){
        sqlite3_finalize(stmt);
        sqlite3_close(dbConnection);
        return true;
    } else {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(dbConnection));
        sqlite3_finalize(stmt);
        sqlite3_close(dbConnection);
        return false;
    }
}

+(BOOL) checkForInstitutionInFavorites:(NSInteger) id
{
    NSString *query = @"SELECT * FROM user_favorite WHERE institution_id = ?";
    const char *sql = [query UTF8String];
    sqlite3_stmt *stmt;
    
    dbConnection = [MUITUserDatabase connectToDB];
    
    sqlite3_prepare_v2(dbConnection, sql, -1, &stmt, NULL);
    sqlite3_bind_int(stmt, 1, (int)id);
    
    if (sqlite3_step(stmt) == SQLITE_ROW){
        sqlite3_finalize(stmt);
        sqlite3_close(dbConnection);
        return true;
    } else {
        sqlite3_finalize(stmt);
        sqlite3_close(dbConnection);
        return false;
    }
}

+(BOOL) addInstitutionToFavorites:(NSInteger) id
{
    NSString *query = @"INSERT INTO user_favorite ('institution_id') VALUES (?)";
    const char *sql = [query UTF8String];
    sqlite3_stmt *stmt;
    
    dbConnection = [MUITUserDatabase connectToDB];
    
    sqlite3_prepare_v2(dbConnection, sql, -1, &stmt, NULL);
    sqlite3_bind_int(stmt, 1, (int)id);
    
    if (sqlite3_step(stmt) == SQLITE_DONE){
        sqlite3_finalize(stmt);
        sqlite3_close(dbConnection);
        return true;
    } else {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(dbConnection));
        sqlite3_finalize(stmt);
        sqlite3_close(dbConnection);
        return false;
    }
}

@end

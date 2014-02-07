//
//  MUITInstitutionModel.m
//  CollegeComparison1
//
//  Created by Allen Ahner on 11/7/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "MUITInstitutionModel.h"

static sqlite3 *dbConnection;

@implementation MUITInstitutionModel

#pragma mark Lifecycle
-(MUITInstitutionModel *) initWithPrimaryKey:(NSInteger) pk
{
    self = [super init];
    _id = pk;
    return self;
}


-(void) setInitialInstitutionData:(sqlite3_stmt *)stmt
{
    _name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
    _address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
    _city = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
    _stateAbbr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];
    _zipcode =  sqlite3_column_int(stmt, 7);
    _type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 8)];
    _population = sqlite3_column_int(stmt, 9);
    _website = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 10)];
}

#pragma mark Tutition
-(sqlite3_stmt *) getTuitionData
{
    NSString *query = @"SELECT tuition.TUITION1, tuition.TUITION2, tuition.TUITION3, r.room, r.board, r.ROOMAMT, r.BOARDAMT, r.ALLONCAM FROM tuition INNER JOIN room_and_board AS r ON tuition.UNITID = r.UNITID WHERE tuition.UNITID = ? LIMIT 1";
    const char *sql = [query UTF8String];
    sqlite3_stmt *stmt;
    
    dbConnection = [MUITInstitutionDatabase connectToDB];
    
    int result = sqlite3_prepare_v2(dbConnection, sql, -1, &stmt, NULL);
    sqlite3_bind_int(stmt, 1, (int)self.id);
    
    if(result != SQLITE_OK) {
        NSLog(@"Prepare-error #%i: %s", result, sqlite3_errmsg(dbConnection));
    }
    
    return stmt;
    
}

-(int) setTutitionData
{
    sqlite3_stmt *stmt = [self getTuitionData];
    while(sqlite3_step(stmt) == SQLITE_ROW) {
        _inStTuition = sqlite3_column_int(stmt, 0);
        _outStTutition = sqlite3_column_int(stmt, 1);
        _inDisTuition = sqlite3_column_int(stmt, 2);;
        _room = sqlite3_column_int(stmt, 5);
        _board = sqlite3_column_int(stmt, 6);
    }
    
    sqlite3_finalize(stmt);
    return sqlite3_close(dbConnection);
}

#pragma mark Demographics
-(sqlite3_stmt *) getDemographicsData
{
    NSString *query = @"SELECT EFYTOTLM, EFYTOTLW, EFYAIANT, EFYASIAT, EFYBKAAT, EFYHISPT, EFYNHPIT, EFYWHITT, EFYUNKNT FROM enrollment WHERE UNITID = ? AND EFFYLEV = 1";
    const char *sql = [query UTF8String];
    sqlite3_stmt *stmt;
    
    dbConnection = [MUITInstitutionDatabase connectToDB];
    
    int result = sqlite3_prepare_v2(dbConnection, sql, -1, &stmt, NULL);
    sqlite3_bind_int(stmt, 1, (int)self.id);
    
    if(result != SQLITE_OK) {
        NSLog(@"Prepare-error #%i: %s", result, sqlite3_errmsg(dbConnection));
    }
    
    return stmt;
}

-(int) setDemographicsData
{
    sqlite3_stmt *stmt = [self getDemographicsData];
    while(sqlite3_step(stmt) == SQLITE_ROW) {
        _men = sqlite3_column_int(stmt, 0);
        _women = sqlite3_column_int(stmt, 1);
        _nativeInd = sqlite3_column_int(stmt, 2);
        _asian = sqlite3_column_int(stmt, 3);
        _african = sqlite3_column_int(stmt, 4);
        _hispanic = sqlite3_column_int(stmt, 6);
        _nativeHaw = sqlite3_column_int(stmt, 5);
        _white = sqlite3_column_int(stmt, 7);
        _unknown = sqlite3_column_int(stmt, 8);
    }
    
    sqlite3_finalize(stmt);
    return sqlite3_close(dbConnection);
}

#pragma mark Admission
-(sqlite3_stmt *) getAdmissionData
{
    NSString *query = @"SELECT ADMCON1, ADMCON2, ADMCON3, ADMCON4, ADMCON5, ADMCON6, ADMCON7, ADMCON8, ADMCON9 FROM admission WHERE UNITID = ? LIMIT 1";
    const char *sql = [query UTF8String];
    sqlite3_stmt *stmt;
    
    dbConnection = [MUITInstitutionDatabase connectToDB];
    
    int result = sqlite3_prepare_v2(dbConnection, sql, -1, &stmt, NULL);
    sqlite3_bind_int(stmt, 1, (int)self.id);
    
    if(result != SQLITE_OK) {
        NSLog(@"Prepare-error #%i: %s", result, sqlite3_errmsg(dbConnection));
    }
    
    return stmt;
}

-(int) setAdmissionData
{
    NSMutableArray *reqDocs = [[NSMutableArray alloc] init];
    sqlite3_stmt *stmt = [self getAdmissionData];
    NSInteger reqCount = 0;
    while(sqlite3_step(stmt) == SQLITE_ROW) {
        for(int i=1; i<sqlite3_data_count(stmt); i++){
            int codeVal = sqlite3_column_int(stmt, i);
            if(codeVal == 1){
                NSString *req = [NSString stringWithUTF8String:(char *)sqlite3_column_name(stmt, i)];
                [reqDocs addObject:req];
                reqCount++;
            }
        }
        _numReqDocs = reqCount;
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(dbConnection);
    [self convertReqDocsCodeToName:reqDocs];
    
    return true;
}

-(void) convertReqDocsCodeToName:(NSMutableArray *)reqDocs
{
    _reqDocs = [[NSMutableArray alloc] init];
    for (NSString *code in reqDocs) {
        NSString *query = @"SELECT description FROM codevalues WHERE fieldname = ? LIMIT 1";
        const char *sql = [query UTF8String];
        sqlite3_stmt *stmt;
        dbConnection = [MUITInstitutionDatabase connectToDB];
        
        int result = sqlite3_prepare_v2(dbConnection, sql, -1, &stmt, NULL);
        sqlite3_bind_text(stmt, 1, [code UTF8String], -1, SQLITE_TRANSIENT);
        
        if(result != SQLITE_OK) {
            NSLog(@"Prepare-error #%i: %s", result, sqlite3_errmsg(dbConnection));
        } else {
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                [_reqDocs addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)]];
            }
        }
        sqlite3_finalize(stmt);
        sqlite3_close(dbConnection);
    }
}

#pragma mark Financial Aid
-(sqlite3_stmt *) getFinancialAidData
{
    NSString *query = @"SELECT ANYAIDP, UAGRNTA, UPGRNTA, UFLOANA FROM financial WHERE UNITID = ? LIMIT 1";
    const char *sql = [query UTF8String];
    sqlite3_stmt *stmt;
    
    dbConnection = [MUITInstitutionDatabase connectToDB];
    
    int result = sqlite3_prepare_v2(dbConnection, sql, -1, &stmt, NULL);
    sqlite3_bind_int(stmt, 1, (int)self.id);
    
    if(result != SQLITE_OK) {
        NSLog(@"Prepare-error #%i: %s", result, sqlite3_errmsg(dbConnection));
    }
    
    return stmt;
}

-(int) setFinancialAidData
{
    sqlite3_stmt *stmt = [self getFinancialAidData];
    while(sqlite3_step(stmt) == SQLITE_ROW) {
        _percentRecAid = sqlite3_column_int(stmt, 0);
        _avgUndGradAmt = sqlite3_column_int(stmt, 1);
        _avgPellAmt = sqlite3_column_int(stmt, 2);
        _avgFedAmt = sqlite3_column_int(stmt, 3);
    }
    
    sqlite3_finalize(stmt);
    return sqlite3_close(dbConnection);
}

#pragma mark Formatting
+(NSString *) formatNumber:(NSInteger) number
{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    return [numberFormatter stringFromNumber:[NSNumber numberWithInteger: number]];
}

@end




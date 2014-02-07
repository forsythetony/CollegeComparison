//
//  MUITDatabase.m
//  CollegeComparison1
//
//  Created by Josh on 11/10/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "MUITDatabase.h"

@implementation MUITDatabase

#pragma mark Institution Methods
- (NSString *) setDBPath:(NSString *)filename :(NSSearchPathDirectory)directory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    NSString *docs = [paths objectAtIndex:0];
    return [docs stringByAppendingPathComponent:filename];
}

// Will copy the initial instance of the database if does not already exist
- (void) copyDBIfNeeded:(NSString *)path :(NSString *) filename {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [fileManager fileExistsAtPath:path];
    NSLog(@"Does the file already exist in %@: %d\n", path, success);
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:path error:&error];
        NSLog(@"Did the file copy: %d\n", success);
        if(!success){
            NSAssert1(0, @"Failed to create writeable database file with message '%@'", [error localizedDescription]);
        }
    }
}

+(sqlite3 *) connectToDB:(NSString *)path
{
    sqlite3 *database;
    const char *utf8Path = [path UTF8String];
    
    sqlite3_open(utf8Path, &database);
    
    return database;
}

#pragma Utility Methods
+(NSString *) convertStringToCommaDelim:(NSString *)string{
    
    string = [NSString stringWithFormat:@"'%@", string];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@"', '"];
    string = [string substringToIndex:[string length]-3];
    
    return string;
}

@end

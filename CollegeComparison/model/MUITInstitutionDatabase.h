//
//  MUITInstitutionDatabase.h
//  CollegeComparison1
//
//  Created by Allen Ahner on 12/1/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUITDatabase.h"

@interface MUITInstitutionDatabase : MUITDatabase

-(void) copyDBIfNeeded;
+(sqlite3 *) connectToDB;

@end

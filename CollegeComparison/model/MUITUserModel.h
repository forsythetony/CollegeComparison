//
//  MUITUserModel.h
//  CollegeComparison1
//
//  Created by Allen Ahner on 11/26/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUITUserDatabase.h"

@interface MUITUserModel : NSObject

+(BOOL) removeInstitutionFromFavorites:(NSInteger) id;
+(BOOL) checkForInstitutionInFavorites:(NSInteger) id;
+(BOOL) addInstitutionToFavorites:(NSInteger) id;

@end

//
//  MUITInstitutionModel.h
//  CollegeComparison1
//
//  Created by Allen Ahner on 11/7/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUITInstitutionDatabase.h"

@interface MUITInstitutionModel : NSObject

@property (nonatomic) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *stateName;
@property (nonatomic, strong) NSString *stateAbbr;
@property (nonatomic) NSInteger zipcode;
@property (nonatomic) NSString *type;
@property (nonatomic) NSInteger population;
@property (nonatomic) NSString *website;
@property (nonatomic) NSDecimal *latitude;
@property (nonatomic) NSDecimal *longitude;
@property (nonatomic) NSInteger inStTuition;
@property (nonatomic) NSInteger outStTutition;
@property (nonatomic) NSInteger inDisTuition;
@property (nonatomic) NSInteger room;
@property (nonatomic) NSInteger board;
@property (nonatomic) NSInteger percentRecAid;
@property (nonatomic) NSInteger avgUndGradAmt;
@property (nonatomic) NSInteger avgPellAmt;
@property (nonatomic) NSInteger avgFedAmt;
@property (nonatomic) NSInteger men;
@property (nonatomic) NSInteger women;
@property (nonatomic) NSInteger white;
@property (nonatomic) NSInteger african;
@property (nonatomic) NSInteger hispanic;
@property (nonatomic) NSInteger asian;
@property (nonatomic) NSInteger nativeInd;
@property (nonatomic) NSInteger nativeHaw;
@property (nonatomic) NSInteger unknown;
@property (nonatomic) NSInteger numReqDocs;
@property (nonatomic) NSMutableArray *reqDocs;

-(MUITInstitutionModel *) initWithPrimaryKey:(NSInteger) pk;
-(void) setInitialInstitutionData:(sqlite3_stmt *)stmt;
-(int) setTutitionData;
-(int) setDemographicsData;
-(int) setAdmissionData;
-(int) setFinancialAidData;
+(NSString *) formatNumber:(NSInteger)number;


@end

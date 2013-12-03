//
//  MUITCollege.h
//  CollegeComparison
//
//  Created by CompSci on 11/10/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUITCollege : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger control;

@property (nonatomic, assign) NSInteger sat_reading_25;
@property (nonatomic, assign) NSInteger sat_reading_75;
@property (nonatomic, assign) NSInteger sat_math_25;
@property (nonatomic, assign) NSInteger sat_math_75;
@property (nonatomic, assign) NSInteger sat_writing_25;
@property (nonatomic, assign) NSInteger sat_writing_75;

@property (nonatomic, assign) NSInteger act_25;
@property (nonatomic, assign) NSInteger act_75;
@property (nonatomic, assign) NSInteger act_english_25;
@property (nonatomic, assign) NSInteger act_english_75;
@property (nonatomic, assign) NSInteger act_math_25;
@property (nonatomic, assign) NSInteger act_math_75;
@property (nonatomic, assign) NSInteger act_writing_25;
@property (nonatomic, assign) NSInteger act_writing_75;

@property (nonatomic, assign) NSInteger percent_receive_financial_aid;

@property (nonatomic, assign) NSInteger enrollment_men;
@property (nonatomic, assign) NSInteger enrollment_women;
@property (nonatomic, assign) NSInteger enrollment_total;


@end
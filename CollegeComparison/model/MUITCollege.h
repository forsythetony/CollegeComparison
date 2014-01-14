//
//  MUITCollege.h
//  CollegeComparison
//
//  Created by CompSci on 11/10/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUITCollege : NSObject <NSCoding> {
    NSString *name;
    NSString *state;
    NSInteger identifier;
    NSInteger control;
    
    NSInteger sat_reading_25;
    NSInteger sat_reading_75;
    NSInteger sat_math_25;
    NSInteger sat_math_75;
    NSInteger sat_writing_25;
    NSInteger sat_writing_75;
    
    NSInteger act_25;
    NSInteger act_75;
    NSInteger act_english_25;
    NSInteger act_english_75;
    NSInteger act_math_25;
    NSInteger act_math_75;
    NSInteger act_writing_25;
    NSInteger act_writing_75;
    
    NSInteger percent_receive_financial_aid;
    
    NSInteger enrollment_men;
    NSInteger enrollment_women;
    NSInteger enrollment_total;
    
    NSInteger tuition_in_state;
    NSInteger tuition_out_state;
    
    NSString *dateAccessed;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, assign) NSInteger identifier;
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

@property (nonatomic, assign) NSInteger tuition_out_state;
@property (nonatomic, assign) NSInteger tuition_in_state;

@property (nonatomic, assign) BOOL pushedFromFavorites;

@property (nonatomic, strong) NSString *dateAccessed;


@end
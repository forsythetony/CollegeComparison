//
//  MUITCollege.m
//  CollegeComparison
//
//  Created by CompSci on 11/10/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "MUITCollege.h"

@implementation MUITCollege

@synthesize name;
@synthesize state;
@synthesize identifier;
@synthesize control;

@synthesize sat_reading_25;
@synthesize sat_reading_75;
@synthesize sat_math_25;
@synthesize sat_math_75;
@synthesize sat_writing_25;
@synthesize sat_writing_75;

@synthesize act_25;
@synthesize act_75;
@synthesize act_english_25;
@synthesize act_english_75;
@synthesize act_math_25;
@synthesize act_math_75;
@synthesize act_writing_25;
@synthesize act_writing_75;

@synthesize percent_receive_financial_aid;

@synthesize enrollment_men;
@synthesize enrollment_women;
@synthesize enrollment_total;

@synthesize tuition_in_state;
@synthesize tuition_out_state;

@synthesize dateAccessed;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.state = [aDecoder decodeObjectForKey:@"state"];
        self.identifier = [[aDecoder decodeObjectForKey:@"id"] integerValue];
        self.control = [[aDecoder decodeObjectForKey:@"id"] integerValue];
        
        self.sat_reading_25 = [[aDecoder decodeObjectForKey:@"sat_reading_25"] integerValue];
        self.sat_reading_75 = [[aDecoder decodeObjectForKey:@"sat_reading_75"] integerValue];
        self.sat_math_25 = [[aDecoder decodeObjectForKey:@"sat_math_25"] integerValue];
        self.sat_math_75 = [[aDecoder decodeObjectForKey:@"sat_math_75"] integerValue];
        self.sat_writing_25 = [[aDecoder decodeObjectForKey:@"sat_writing_25"] integerValue];
        self.sat_writing_75 = [[aDecoder decodeObjectForKey:@"sat_writing_75"] integerValue];
        
        self.act_25 = [[aDecoder decodeObjectForKey:@"act_25"] integerValue];
        self.act_75 = [[aDecoder decodeObjectForKey:@"act_75"] integerValue];
        self.act_english_25 = [[aDecoder decodeObjectForKey:@"act_english_25"] integerValue];
        self.act_english_75 = [[aDecoder decodeObjectForKey:@"act_english_75"] integerValue];
        self.act_math_25 = [[aDecoder decodeObjectForKey:@"act_math_25"] integerValue];
        self.act_math_75 = [[aDecoder decodeObjectForKey:@"act_math_75"] integerValue];
        self.act_writing_25 = [[aDecoder decodeObjectForKey:@"act_writing_25"] integerValue];
        self.act_writing_75 = [[aDecoder decodeObjectForKey:@"act_writing_75"] integerValue];
        
        self.percent_receive_financial_aid = [[aDecoder decodeObjectForKey:@"percent_receive_financial_aid"] integerValue];
        
        self.enrollment_men = [[aDecoder decodeObjectForKey:@"enrollment_men"] integerValue];
        self.enrollment_women = [[aDecoder decodeObjectForKey:@"enrollment_women"] integerValue];
        self.enrollment_total = [[aDecoder decodeObjectForKey:@"enrollment_total"] integerValue];
        
        self.dateAccessed = [aDecoder decodeObjectForKey:@"dateAccessed"];
        
        return self;
    }
    
    return nil;
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:state forKey:@"state"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.identifier] forKey:@"id"];
    [aCoder encodeObject:[NSNumber numberWithInteger:control] forKey:@"control"];
    
    [aCoder encodeObject:[NSNumber numberWithInteger:sat_reading_25] forKey:@"sat_reading_25"];
    [aCoder encodeObject:[NSNumber numberWithInteger:sat_reading_75] forKey:@"sat_reading_75"];
    [aCoder encodeObject:[NSNumber numberWithInteger:sat_math_25] forKey:@"sat_math_25"];
    [aCoder encodeObject:[NSNumber numberWithInteger:sat_math_75] forKey:@"sat_math_75"];
    [aCoder encodeObject:[NSNumber numberWithInteger:sat_writing_25] forKey:@"sat_writing_25"];
    [aCoder encodeObject:[NSNumber numberWithInteger:sat_writing_75] forKey:@"sat_writing_75"];
    
    [aCoder encodeObject:[NSNumber numberWithInteger:act_25] forKey:@"act_25"];
    [aCoder encodeObject:[NSNumber numberWithInteger:act_75] forKey:@"act_75"];
    [aCoder encodeObject:[NSNumber numberWithInteger:act_english_25] forKey:@"act_english_25"];
    [aCoder encodeObject:[NSNumber numberWithInteger:act_english_75] forKey:@"act_english_75"];
    [aCoder encodeObject:[NSNumber numberWithInteger:act_math_25] forKey:@"act_math_25"];
    [aCoder encodeObject:[NSNumber numberWithInteger:act_math_75] forKey:@"act_math_75"];
    [aCoder encodeObject:[NSNumber numberWithInteger:act_writing_25] forKey:@"act_writing_25"];
    [aCoder encodeObject:[NSNumber numberWithInteger:act_writing_75] forKey:@"act_writing_75"];
    
    [aCoder encodeObject:[NSNumber numberWithInteger:percent_receive_financial_aid] forKey:@"percent_receive_financial_aid"];
    
    [aCoder encodeObject:[NSNumber numberWithInteger:enrollment_men] forKey:@"enrollment_men"];
    [aCoder encodeObject:[NSNumber numberWithInteger:enrollment_women] forKey:@"enrollment_women"];
    [aCoder encodeObject:[NSNumber numberWithInteger:enrollment_total] forKey:@"enrollment_total"];
    
    [aCoder encodeObject:dateAccessed forKey:@"dateAccessed"];
}



@end

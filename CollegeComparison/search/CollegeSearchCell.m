//
//  CollegeSearchCell.m
//  CollegeComparison
//
//  Created by Anthony Forsythe on 2/4/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import "CollegeSearchCell.h"

@implementation CollegeSearchCell

@synthesize selected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setSelected:(BOOL)mselected
{
    UIColor *newBackgroundColor;
    UIColor *newTextColor;
    UIColor *newLocationTextColor;
    
    
    selected = mselected;
    
    if (selected == YES) {
        newBackgroundColor = [UIColor watermelonColor];
        newTextColor = [UIColor antiqueWhiteColor];
        newLocationTextColor = [UIColor black75PercentColor];
    }
    else
    {
        newBackgroundColor = [UIColor clearColor];
        newTextColor = [UIColor blackColor];
        newLocationTextColor = [UIColor black25PercentColor];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self setBackgroundColor:newBackgroundColor];
        [self.name setTextColor:newTextColor];
        [self.location setTextColor:newLocationTextColor];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

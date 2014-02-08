//
//  newHomeFiltersViewController.m
//  CollegeComparison
//
//  Created by Chapman, Andrew J. (MU-Student) on 2/6/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import "newHomeFiltersViewController.h"

@interface newHomeFiltersViewController () {
    NSMutableArray *locationsArray;
}

@end

@implementation newHomeFiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self setDefaultLayoutValues];
}
-(void)setDefaultLayoutValues
{
    UIColor *backgroundColor = [UIColor clearColor];
    
    //Set defaults
    
        //For header view
        [[self headerImageView] setBackgroundColor:backgroundColor];
        [[self collegeCountContainerView] setBackgroundColor:backgroundColor];
    
        //For locations
        [[self locationsContainerView] setBackgroundColor:backgroundColor];
        [[self locationsTitleLabel] setBackgroundColor:backgroundColor];
        [[self locationsTitleLabel] setTextColor:[UIColor blackColor]];
    
        //For tuition
        [[self tuitionContainerView] setBackgroundColor:backgroundColor];
        [[self tuitionLabel] setBackgroundColor:backgroundColor];
        [[self tuitionLabel] setTextColor:[UIColor blackColor]];
    
        //For Enrollment
        [[self enrollmentContainerView] setBackgroundColor:backgroundColor];
        [[self enrollmentLabel] setBackgroundColor:backgroundColor];
        [[self enrollmentLabel] setTextColor:[UIColor blackColor]];
    
        //For School Type
        [[self schoolTypeContainerView] setBackgroundColor:backgroundColor];
        [[self schoolTypeLabel] setBackgroundColor:backgroundColor];
        [[self schoolTypeLabel] setTextColor:[UIColor blackColor]];
    
    //Configure sliders
    
    //Default Colors
    UIColor *sliderPastColor = [UIColor blueberryColor];
    UIColor *sliderFutureColor = [UIColor crimsonColor];
    UIColor *sliderButtonColor = [UIColor black50PercentColor];
    
    
        //Tuition Slider
        [[self tuitionSlider] setMaximumTrackTintColor:sliderFutureColor];
        [[self tuitionSlider] setMinimumTrackTintColor:sliderPastColor];
        [[self tuitionSlider] setThumbTintColor:sliderButtonColor];
    
        //Enrollment Slider
        [[self enrollmentSlider] setMinimumTrackTintColor:sliderPastColor];
        [[self enrollmentSlider] setMaximumTrackTintColor:sliderFutureColor];
        [[self enrollmentSlider] setThumbTintColor:sliderButtonColor];
    
    
}
@end

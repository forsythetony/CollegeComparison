//
//  newHomeFiltersViewController.m
//  CollegeComparison
//
//  Created by Chapman, Andrew J. (MU-Student) on 2/6/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import "newHomeFiltersViewController.h"
#import "homePageHeaderView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define CORALCOLOR UIColorFromRGB(0xF05746)

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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createHeaderView];
    [self createCircleCollegeCount];
}
-(void)setDefaultLayoutValues
{
    UIColor *backgroundColor = [UIColor clearColor];
    
    //Set defaults
    
        //Title to be displayed in the navigation bar
    
        NSString *title = @"Filters";
    
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
    
    
    
    
    
    self.title = title;
    
    
}
-(void)createHeaderView
{
    CGRect headerViewFrame;
    
    headerViewFrame.origin = CGPointMake(0.0, 20.0);
    
    headerViewFrame.size = CGSizeMake(320.0, 150.0);
    
    homePageHeaderView *headerView = [[homePageHeaderView alloc] initWithFrame:headerViewFrame];
    
    [headerView setBackgroundColor:CORALCOLOR];
    
    [self.view addSubview:headerView];
    
    [self.view bringSubviewToFront:self.collegeCountContainerView];
}
-(void)createCircleCollegeCount
{
    //  Create frame
    
    CGRect circleChartFrame;
    
    circleChartFrame.origin = CGPointMake(0.0, 0.0);
    circleChartFrame.size = self.collegeCountContainerView.bounds.size;
    
    PNCircleChart *collegeCountCircleGraph = [[PNCircleChart alloc] initWithFrame:circleChartFrame andTotal:[NSNumber numberWithInt:4000] andCurrent:[NSNumber numberWithInt:3333]];
    
    [self.collegeCountContainerView addSubview:collegeCountCircleGraph];
    
    [self.collegeCountContainerView setBackgroundColor:[UIColor clearColor]];
    
    [collegeCountCircleGraph setLabelColor:[UIColor whiteColor]];
    [collegeCountCircleGraph setLineWidth:[NSNumber numberWithFloat:10.0]];
    [collegeCountCircleGraph setStrokeColor:UIColorFromRGB(0x69AEEF)];
    [collegeCountCircleGraph strokeChart];
    
    
    
    
    
    
}
@end

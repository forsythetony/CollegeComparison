//
//  newHomeFiltersViewController.m
//  CollegeComparison
//
//  Created by Chapman, Andrew J. (MU-Student) on 2/6/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import "newHomeFiltersViewController.h"

@interface newHomeFiltersViewController () {
    UISlider *tuitionSlider;
    UISlider *studentBodySlider;
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
}
- (void)createSliders
{
    //Create frames for sliders
    CGRect tuitionSliderFrame;
    CGRect studentBodySliderFrame;
    
    //Configure frame for tuition slider
    tuitionSliderFrame.origin.x = 0.0;
    tuitionSliderFrame.origin.y = 300.0;
    tuitionSliderFrame.size.height = 40.0;
    tuitionSliderFrame.size.width = 320.0;
    
    //Configure frame for student body slider
    studentBodySliderFrame.origin.x = 0.0;
    studentBodySliderFrame.origin.y = 340.0;
    studentBodySliderFrame.size.height = 40.0;
    studentBodySliderFrame.size.width = 320.0;
    
    //Initialize sliders
    tuitionSlider = [[UISlider alloc] initWithFrame:tuitionSliderFrame];
    studentBodySlider = [[UISlider alloc] initWithFrame:studentBodySliderFrame];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

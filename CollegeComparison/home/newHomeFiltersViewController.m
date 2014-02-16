//
//  newHomeFiltersViewController.m
//  CollegeComparison
//
//  Created by Chapman, Andrew J. (MU-Student) on 2/6/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import "newHomeFiltersViewController.h"
#import "homePageHeaderView.h"
#import "SWRevealViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define CORALCOLOR UIColorFromRGB(0xF05746)

@interface newHomeFiltersViewController () {
    NSMutableArray *locationsArray;
    NSMutableArray *collegesFound;
    
    PNCircleChart *headerChart;
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
    [self dataSetup];
    [self setupTableView];
    [self.locationsTableView reloadData];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self slidingPanelSetup];
    
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
    
    
    [self.privateSchoolButton addTarget:self action:@selector(privatePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
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
    
    PNCircleChart *collegeCountCircleGraph = [[PNCircleChart alloc] initWithFrame:circleChartFrame andTotal:[NSNumber numberWithInt:4000] andCurrent:[NSNumber numberWithInt:4000]];
    
    [self.collegeCountContainerView addSubview:collegeCountCircleGraph];
    
    [self.collegeCountContainerView setBackgroundColor:[UIColor clearColor]];
    
    [collegeCountCircleGraph setLabelColor:[UIColor whiteColor]];
    [collegeCountCircleGraph setLineWidth:[NSNumber numberWithFloat:10.0]];
    [collegeCountCircleGraph setStrokeColor:UIColorFromRGB(0x69AEEF)];
    [collegeCountCircleGraph setHasPercentage:NO];
    [collegeCountCircleGraph strokeChart];
    
    headerChart = collegeCountCircleGraph;
    
}
-(void)slidingPanelSetup
{
    _panelViewButton.target = self;
    _panelViewButton.action = @selector(panelPressed:);
    
    //Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}
-(void)panelPressed:(id) sender
{
    [self.revealViewController rightRevealToggle:sender];
}
-(void)setupTableView
{
    [self.locationsTableView setDelegate:self];
    [self.locationsTableView setDataSource:self];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [collegesFound count];
}
-(void)dataSetup
{
    collegesFound = [NSMutableArray arrayWithObjects:@"Fudge", @"Nudge", @"Pudge", nil];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"locationsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    

    [cell.textLabel setText:[collegesFound objectAtIndex:indexPath.row]];
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGRect footerFrame;
    
    footerFrame.origin = CGPointMake(0.0, 0.0);
    
    footerFrame.size = CGSizeMake(self.locationsTableView.bounds.size.width, 35.0);
    
    
    UIView *footer = [[UIView alloc] initWithFrame:footerFrame];
    
    [footer setBackgroundColor:[UIColor blueberryColor]];
    
    //  Create button
    
    UIButton *createLocation = [[UIButton alloc] initWithFrame:footerFrame];
    
    [createLocation.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [createLocation setTitle:@"Add Location" forState:UIControlStateNormal];

    
    [createLocation.titleLabel setTextColor:[UIColor whiteColor]];
    
    [createLocation setHidden:NO];
    [footer addSubview:createLocation];
    
    return footer;
    
    //  There is something to be said for people who cant actually maths right
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35.0;
}
-(void)privatePressed:(id) sender
{
    [headerChart setCurrent:[NSNumber numberWithInt:2000]];
    
    [headerChart strokeChart];
}
@end

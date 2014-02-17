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
    
    NMRangeSlider *tuitionsSlider, *enrollmentsSlider;
}

@end

@implementation newHomeFiltersViewController

#pragma mark Initialization Methods -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [self aestheticsConfiguation];
    
    [self dataSetup];
    
    [self setupTableView];
    
    [self.locationsTableView reloadData];
    
    [self slidingPanelSetup];
    
    [self createHeaderView];
    
    [self createCircleCollegeCount];
    
    [self configureRangeSlider];
}
#pragma mark Data Setup
-(void)dataSetup
{
    locationsArray = [NSMutableArray new];
    
    
    //  Get colleges from data provider
    MUITCollegeDataProvider *dataProvider = [MUITCollegeDataProvider new];

    NSArray *collegesRetrieved = [dataProvider getDummyColleges];

    collegesFound = [NSMutableArray arrayWithArray:collegesRetrieved];
    
    
}
#pragma mark Visual Configuration
-(void)createCircleCollegeCount
{
    //  Create frame
    
    CGRect circleChartFrame;
    
    circleChartFrame.origin = CGPointMake(0.0, 0.0);
    circleChartFrame.size = self.collegeCountContainerView.bounds.size;
    
    NSInteger collegesCount = [collegesFound count];
    
    PNCircleChart *collegeCountCircleGraph = [[PNCircleChart alloc] initWithFrame:circleChartFrame andTotal:[NSNumber numberWithInt:collegesCount] andCurrent:[NSNumber numberWithInteger:collegesCount]];
    
    [self.collegeCountContainerView addSubview:collegeCountCircleGraph];
    
    [self.collegeCountContainerView setBackgroundColor:[UIColor clearColor]];
    
    [collegeCountCircleGraph setLabelColor:[UIColor whiteColor]];
    [collegeCountCircleGraph setLineWidth:[NSNumber numberWithFloat:10.0]];
    [collegeCountCircleGraph setStrokeColor:UIColorFromRGB(0x69AEEF)];
    [collegeCountCircleGraph setHasPercentage:NO];
    [collegeCountCircleGraph strokeChart];
    
    headerChart = collegeCountCircleGraph;
    
}

#pragma mark Table View Setup
-(void)setupTableView
{
    [self.locationsTableView setDelegate:self];
    [self.locationsTableView setDataSource:self];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locationsArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"locationsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    CCLocation *theLocation = [locationsArray objectAtIndex:indexPath.row];
    
    NSString *textLabel = theLocation.stringAddress;
    
    [cell.textLabel setText:textLabel];
    
    [cell setBackgroundColor:[UIColor charcoalColor]];
    
    [cell.textLabel setTextColor:[UIColor black75PercentColor]];
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
    
//    [footer setBackgroundColor:[UIColor charcoalColor]];
    
    footer.layer.cornerRadius = 0.0;
    
    //  Create button
    
    UIButton *createLocation = [[UIButton alloc] initWithFrame:footerFrame];
    
    [createLocation.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [createLocation setTitle:@"+ Add Location" forState:UIControlStateNormal];
    
    
    [createLocation.titleLabel setTextColor:[UIColor black25PercentColor]];
    
    
    [createLocation addTarget:self action:@selector(addLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [createLocation setHidden:NO];
    [footer addSubview:createLocation];
    
    return footer;
    
    //  There is something to be said for people who cant actually maths right
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35.0;
}
#pragma mark Sliding Panel Setup
-(void)slidingPanelSetup
{
    _panelViewButton.target = self;
    _panelViewButton.action = @selector(panelPressed:);
    
    //Set the gesture
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}
#pragma mark Range Slider Setup
-(void)configureRangeSlider
{
    //  Configure the frame for the tuition slider
    CGRect tuitionContainerBounds = [self.tuitionContainerView bounds];
    CGRect tuitionLabelBounds = [self.tuitionLabel bounds];
    
    CGRect tuitionSliderRect;
    
    tuitionSliderRect.origin.x = 0.0;
    tuitionSliderRect.origin.y = tuitionContainerBounds.size.height - (tuitionContainerBounds.size.height -tuitionLabelBounds.size.height);
    
    tuitionSliderRect.size.width = tuitionContainerBounds.size.width;
    tuitionSliderRect.size.height = tuitionContainerBounds.size.height - tuitionLabelBounds.size.height;
    
    //  Initialize the tuition slider
    tuitionsSlider = [[NMRangeSlider alloc] initWithFrame:tuitionSliderRect];
    
    //  Set the min and max values
    [tuitionsSlider setMinimumValue:0.0];
    [tuitionsSlider setMaximumValue:100000];
    
    //  Configure visual properties of slider
    [tuitionsSlider setTintColor:CORALCOLOR];
    
    //  Add this view controller to listen for slider's value change
    [tuitionsSlider addTarget:self action:@selector(tuitionRangeDidChange:) forControlEvents:UIControlEventValueChanged];
    
    //  Add as subview
    [self.tuitionContainerView addSubview:tuitionsSlider];
    
    //  Animate the positioning of upper slider
    [tuitionsSlider setUpperValue:100000 animated:YES];
    
    
    
    //  ENROLLMENT SLIDER
    
    CGRect enrollmentSliderFrame;
    
    enrollmentSliderFrame.origin.x = 0.0;
    enrollmentSliderFrame.origin.y = self.enrollmentContainerView.bounds.size.height - (self.enrollmentContainerView.bounds.size.height - self.enrollmentLabel.bounds.size.height);
    
    enrollmentSliderFrame.size.width = self.enrollmentContainerView.bounds.size.width;
    enrollmentSliderFrame.size.height = self.enrollmentContainerView.bounds.size.height - self.enrollmentLabel.bounds.size.height;
    

    enrollmentsSlider = [[NMRangeSlider alloc] initWithFrame:enrollmentSliderFrame];
    

    [enrollmentsSlider addTarget:self action:@selector(enrollmentRangeDidChange:) forControlEvents:UIControlEventValueChanged];
    

    [enrollmentsSlider setMinimumValue:0.0];
    [enrollmentsSlider setMaximumValue:100000];
    

    [enrollmentsSlider setTintColor:CORALCOLOR];
    [self.enrollmentContainerView addSubview:enrollmentsSlider];
    
    [enrollmentsSlider setUpperValue:100000 animated:YES];
    
}
#pragma mark Event Handlers -
#pragma mark Side Panel
-(void)panelPressed:(id) sender
{
    [self.revealViewController rightRevealToggle:sender];
}
#pragma mark Buttons
-(void)privatePressed:(id) sender
{
    [headerChart strokeChartToValue:[NSNumber numberWithInt:1]];
    NSLog(@"\n\nValue for upper slider is %lf\n\n", tuitionsSlider.upperValue);
    
}
-(void)addLocation:(id) sender
{
    [self performSegueWithIdentifier:@"locationPicker" sender:self];
}
- (IBAction)goPress:(id)sender {
    
    [self performSegueWithIdentifier:@"searchResults" sender:self];
}
#pragma mark Sliders
-(void)tuitionRangeDidChange:(id) sender
{
    float up = tuitionsSlider.upperValue;
    float down = tuitionsSlider.lowerValue;
    
    NSLog(@"\n\nTuition lower value was: %lf\nThe upper value was: %lf\n\n", down, up);
    
}
-(void)enrollmentRangeDidChange:(id) sender
{
    float up = enrollmentsSlider.upperValue;
    float down = enrollmentsSlider.lowerValue;
    
    NSLog(@"\n\nEnrollment lower value was: %lf\nThe upper value was: %lf\n\n", down, up);
    
}
#pragma mark Segue Preparation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"locationPicker"]) {
        
        CCLocationPickerViewController *vc = segue.destinationViewController;
        
        vc.delegate = self;
    }
}
#pragma mark Delegate Methods -
-(void)dismissAndPresentCCLocationPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[self locationsTableView] reloadData];
}
-(void)dismissAndAddLocation:(CCLocation *)location
{
    [locationsArray addObject:location];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.locationsTableView reloadData];
}
-(void)aestheticsConfiguation
{
    //  Main view
    
        //  Title
    
        NSString *mainViewTitle = @"Filters";
    
    
    
    //  Labels
    
        //  Global settings. Set it to nil if you would like to specifically configure each one.
    
        NSNumber *fontSizeForLabels = [NSNumber numberWithFloat:16.0];
    
        //  Location label
    
        UIColor *locationLabelTextColor             =   [UIColor black25PercentColor];
        UIColor *locationLabelBackgroundColor       =   [UIColor clearColor];
        
        NSString *locationLabelFontFamily           =   @"Avenir-Book";
        float locationLabelFontSize                 =   16.0;
    
        //  Tuition Label
    
        UIColor *tuitionLabelTextColor              =   [UIColor black25PercentColor];
        UIColor *tuitionLabelBackgroundcolor        =   [UIColor clearColor];
    
        NSString *tuitionLabelFontFamily            =   @"Avenir-Book";
        float tuitionLabelFontSize                  =   14.0;
    
        //  Enrollment label
    
        UIColor *enrollmentLabelTextColor           =   [UIColor black25PercentColor];
        UIColor *enrollmentLabelBackgroundColor     =   [UIColor clearColor];
        
        NSString *enrollmentLabelFontFamily         =   @"Avenir-Book";
        float enrollmentLabelFontSize               =   14.0;
    
        //  School Type Label
    
        UIColor *schoolTypeLabelTextColor           =   [UIColor black25PercentColor];
        UIColor *schoolTypeLabelBackgroundColor     =   [UIColor clearColor];
        
        NSString *schoolTypeLabelFontFamily         =   @"Avenir-Book";
        float schoolTypeLabelFontSize               =   14.0;
    
    //  Container views
    
        //  Location Container view
    
        UIColor *locationContainerBackgroundColor   =   [UIColor whiteColor];
    
        //  Tuition container view
    
        UIColor *tuitionContainerBackgroundColor    =   [UIColor whiteColor];
    
        //  Enrollment container view
    
        UIColor *enrollmentContainerBackgroundColor =   [UIColor whiteColor];
    
        //  School type container view
    
        UIColor *schoolTypeContainerBackgroundColor =   [UIColor whiteColor];
    
/*************** DO NOT CHANGE ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING****************/
    
    //  Create fonts
    
    if (fontSizeForLabels) {
        locationLabelFontSize  = [fontSizeForLabels floatValue];
        tuitionLabelFontSize = [fontSizeForLabels floatValue];
        enrollmentLabelFontSize = [fontSizeForLabels floatValue];
        schoolTypeLabelFontSize = [fontSizeForLabels floatValue];
    }
    UIFont *locationLabelFont = [UIFont fontWithName:locationLabelFontFamily size:locationLabelFontSize];
    
    UIFont *tuitionLabelFont = [UIFont fontWithName:tuitionLabelFontFamily size:tuitionLabelFontSize];
    
    UIFont *enrollmentLabelFont = [UIFont fontWithName:enrollmentLabelFontFamily size:enrollmentLabelFontSize];
    
    UIFont *schoolTypeLabelFont = [UIFont fontWithName:schoolTypeLabelFontFamily size:schoolTypeLabelFontSize];
    
    //  Set things
    
    //Main view
    
    self.title = mainViewTitle;
    
    //Location container view
    
    self.locationsContainerView.backgroundColor = locationContainerBackgroundColor;
    
    //Location Label
    
    self.locationsTitleLabel.textColor = locationLabelTextColor;
    self.locationsTitleLabel.backgroundColor = locationLabelBackgroundColor;
    self.locationsTitleLabel.font = locationLabelFont;
    
    
    //Tuition container view
    
    self.tuitionContainerView.backgroundColor = tuitionContainerBackgroundColor;
    
    //Tuition Label
    
    self.tuitionLabel.textColor = tuitionLabelTextColor;
    self.tuitionLabel.backgroundColor = tuitionLabelBackgroundcolor;
    self.tuitionLabel.font = tuitionLabelFont;
    
    
    //Enrollment Container view
    
    self.enrollmentContainerView.backgroundColor = enrollmentContainerBackgroundColor;
    
    //Enrollment Label
    
    self.enrollmentLabel.textColor = enrollmentLabelTextColor;
    self.enrollmentLabel.backgroundColor = enrollmentLabelBackgroundColor;
    self.enrollmentLabel.font = enrollmentLabelFont;
    
    
    //School type container vew
    
    self.schoolTypeContainerView.backgroundColor = schoolTypeContainerBackgroundColor;
    
    //School Type Label
    
    self.schoolTypeLabel.textColor = schoolTypeLabelTextColor;
    self.schoolTypeLabel.backgroundColor = schoolTypeLabelBackgroundColor;
    self.schoolTypeLabel.font = schoolTypeLabelFont;
    

    
    
    
    
    //Misc button config
    
    [self.privateSchoolButton addTarget:self action:@selector(privatePressed:) forControlEvents:UIControlEventTouchUpInside];
    
}
@end

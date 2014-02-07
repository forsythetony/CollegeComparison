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
    NSMutableArray *locationsArray;
    
    CGFloat tuitionMaximum, populationMaximum;
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
    
    //Set up the data
    [self dataSetup];
    
    //Create the subview to add filter options to
    
    UIView *mainSubview = [self createMainSubview];
    
    //Create the tableview to manage locations filter
    UITableView *locationsTableView = [self createLocationsTableViewInSuperView:mainSubview];
    
    [mainSubview addSubview:locationsTableView];
    
    //[self createSliders];
}
-(void)dataSetup
{
    //Initial plan is to store the locations as dictionaries in an array
    
    //Initialize array
    locationsArray = [NSMutableArray new];
    
    //Create a dummy object
    
    NSDictionary* myLocation = [self createLocationsDictionaryWithAddress:@"811 Kingscliff Rd., Kirkwood, MO"];
    
    [locationsArray addObject:myLocation];
}
- (void)createSliders
{
    //Create frames for sliders
    CGRect tuitionSliderFrame;
    CGRect studentBodySliderFrame;
    
    float sliderHeight = 20.0;
    float sliderWidth = 250.0;
    
    //Configure frame for tuition slider
    tuitionSliderFrame.origin.x = 0.0;
    tuitionSliderFrame.origin.y = 300.0;
    tuitionSliderFrame.size.height = sliderHeight;
    tuitionSliderFrame.size.width = sliderWidth;
    
    //Configure frame for student body slider
    studentBodySliderFrame.origin.x = 0.0;
    studentBodySliderFrame.origin.y = 340.0;
    studentBodySliderFrame.size.height = sliderHeight;
    studentBodySliderFrame.size.width = sliderWidth;
    
    //Initialize sliders
    tuitionSlider = [[UISlider alloc] initWithFrame:tuitionSliderFrame];
    studentBodySlider = [[UISlider alloc] initWithFrame:studentBodySliderFrame];
    
    //Set targets
    [tuitionSlider addTarget:self
                      action:@selector(tuitionSliderDidSlide:)
            forControlEvents:UIControlEventValueChanged];
    
    [studentBodySlider addTarget:self
                          action:@selector(populationSliderDidSlide:)
                forControlEvents:UIControlEventValueChanged];
    
    //Configure aesthetics
    UIColor* futureTrackColor = [UIColor cornflowerColor];
    UIColor *pastTrackColor = [UIColor crimsonColor];
    UIColor *thumbButtonColor = [UIColor black50PercentColor];
    
    [tuitionSlider configureFlatSliderWithTrackColor:pastTrackColor
                                       progressColor:futureTrackColor
                                          thumbColor:thumbButtonColor];
    
    [studentBodySlider configureFlatSliderWithTrackColor:pastTrackColor
                                           progressColor:futureTrackColor
                                              thumbColor:thumbButtonColor];
    
    //Add to view
    [self.view addSubview:tuitionSlider];
    [self.view addSubview:studentBodySlider];
    
}
-(UIView*)createMainSubview
{
    //Get bounds of superview
    
    CGRect superviewBounds = [[UIScreen mainScreen] bounds];
    
    //Create frame for view
    CGRect mainSubviewFrame;
    
    mainSubviewFrame.origin.x = 0.0;
    mainSubviewFrame.origin.y = 150.0;
    mainSubviewFrame.size.width = 320.0;
    mainSubviewFrame.size.height = superviewBounds.size.height - mainSubviewFrame.origin.y;
    
    //Initialize UIView object
    
    UIView *view = [[UIView alloc] initWithFrame:mainSubviewFrame];
    
    //Configure view
    
    UIColor *mainSubviewBackgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3];
    
    [view setBackgroundColor:mainSubviewBackgroundColor];
    
    //Add to superview
    [self.view addSubview:view];
    
    
    return view;
}
-(UITableView*)createLocationsTableViewInSuperView:(UIView*) superView
{
    //Get bounds of superview
    CGRect superviewBounds = superView.bounds;
    
    //Create frame for tableview title
    CGRect titleFrame;
    
    titleFrame.origin = CGPointMake(0.0, 0.0);
    titleFrame.size = CGSizeMake(320.0, 40.0);
    
    //Initialize UILabel
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    
    //Configure text of label
    [titleLabel setText:@"  Locations"];
    
    //Configure visual properties
    
    //Font for titleLabel
    UIFont *titleFont = [UIFont fontWithName:@"Avenir-Book" size:23.0];
    
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setFont:titleFont];
    [titleLabel setBackgroundColor:[UIColor black25PercentColor]];
    [titleLabel setTextColor:[UIColor antiqueWhiteColor]];
    
    //Add to view
    [superView addSubview:titleLabel];
    
    
    
    //Create frame for tableview
    CGRect locationsTableViewFrame;
    
    float tableViewHeight = 150.0;
    
    locationsTableViewFrame.origin.x = 0.0;
    locationsTableViewFrame.origin.y = 40.0;
    locationsTableViewFrame.size.width = 320.0;
    locationsTableViewFrame.size.height = tableViewHeight;
    
    //Create the tableview
    UITableView *locationsTableView = [[UITableView alloc] initWithFrame:locationsTableViewFrame
                                                                   style:UITableViewStylePlain];
    
    //Set data source and delegate for tableView
    [locationsTableView setDelegate:self];
    [locationsTableView setDataSource:self];
    
    //Other configurations for tableView
    [locationsTableView setBackgroundColor:[UIColor clearColor]];
    //Return tableView
    return locationsTableView;
}
-(void)tuitionSliderDidSlide:(id) sender
{
    //Update the value of maximum tuition filter
    
    CGFloat tuitionValue = tuitionSlider.value;
    
    tuitionMaximum = tuitionValue;
}
-(void)populationSliderDidSlide:(id) sender
{
    //Update the value of maximum student body filter
    
    CGFloat populationValue = studentBodySlider.value;
    
    populationMaximum = populationValue;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr {
    
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    
    return center;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locationsArray count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *reusableIdentifier = @"MyCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    
    //Grab the dictionary from the array
    NSDictionary *location = [locationsArray objectAtIndex:indexPath.row];
    
    //Configure cell text
    [cell.textLabel setText:[location objectForKey:@"addressString"]];
    
    //Configure cell visual properties
    [cell setBackgroundColor:[UIColor black75PercentColor]];
    
    return cell;
}
-(NSDictionary*)createLocationsDictionaryWithAddress:(NSString*) address
{
    NSMutableDictionary *locationDictionary = [NSMutableDictionary new];
    
    [locationDictionary setObject:address forKey:@"addressString"];
    
    CLLocationCoordinate2D coordinate = [self getLocationFromAddressString:address];
    
    
    NSValue *coordinateData = [[NSValue alloc] initWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)];
    
    [locationDictionary setObject:coordinateData forKey:@"coordinates"];
    
    return [NSDictionary dictionaryWithDictionary:locationDictionary];
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //Create frame
    CGRect tableFooterFrame;
    
    tableFooterFrame.origin = CGPointMake(0.0, 0.0);
    tableFooterFrame.size.width = 320.0;
    tableFooterFrame.size.height = 40.0;
    
    //Initialize UIView
    UIView *footerView = [[UIView alloc] initWithFrame:tableFooterFrame];
    
    //Configure the view
    [footerView setBackgroundColor:[UIColor hollyGreenColor]];
    [footerView.layer setCornerRadius:5.0];
    
    
    //Add a label to the view
    CGRect labelFrame = CGRectMake(0.0, 0.0, 320.0, 40.0);
    
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:labelFrame];
    
    [mainLabel setText:@"Add Location"];
    [mainLabel setTextColor:[UIColor antiqueWhiteColor]];
    [mainLabel setTextAlignment:NSTextAlignmentCenter];
    
    [footerView addSubview:mainLabel];
    
    return footerView;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40.0;
}

@end

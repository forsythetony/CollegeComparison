//
//  CCAnimationsScreenViewController.m
//  CollegeComparison
//
//  Created by Anthony Forsythe on 11/18/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CCAnimationsScreenViewController.h"
#import <QuartzCore/QuartzCore.h>


#define MIDSECTIONREFERENCEPOINT 200.0
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CCAnimationsScreenViewController () {
    PNBarChart *theMainChart;
    
}
@end

@implementation CCAnimationsScreenViewController

#pragma mark Initialization Methods

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
    //For BarChart
    
    NSDictionary *data = [self packageData];
    
    
    UIView *mainView = [self buildBarChartsWithData:data];
    
    [self.view addSubview:mainView];
    [self addLabelsToView:mainView withData:data];
    
    
    
}

-(UIView*)buildBarChartsWithData:(NSDictionary*) data
{
    CGRect mainViewFrame;
    
    mainViewFrame.origin.x = 0.0;
    mainViewFrame.origin.y = 0.0;
    
    mainViewFrame.size.width = 320.0;
    mainViewFrame.size.height = 345.0;
    
    UIView *mainView = [[UIView alloc] initWithFrame:mainViewFrame];
    
    mainViewFrame.origin.y += 30.0;
    
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:mainViewFrame];
    [barChart setXLabels: [data objectForKey:@"xvalues"]];
    [barChart setYValues: [data objectForKey:@"yvalues"]];
    [barChart setStrokeColor:UIColorFromRGB(0xF05746)];
    [barChart strokeChart];
    
    theMainChart = barChart;
    
    [mainView addSubview:barChart];
    self.barsArray = [NSArray arrayWithArray:[barChart theViews]];
    
    
    NSLog(@"\n%@\n", self.title);

    return mainView;
}
-(NSDictionary*)packageData
{
    NSDictionary *dataDict = self.modifierDictionary;
   
    NSString *collegeOne = [[dataDict objectForKey:@"One"] objectForKey:@"Name"];
    NSString *collegeTwo = [[dataDict objectForKey:@"Two"] objectForKey:@"Name"];
    
    NSString *collegeOneValue = [NSString stringWithFormat:@"%@", [[dataDict objectForKey:@"One"] objectForKey:@"Height"]];
    NSString *collegeTwoValue = [NSString stringWithFormat:@"%@", [[dataDict objectForKey:@"Two"] objectForKey:@"Height"]];

    NSArray *Xvalues = [NSArray arrayWithObjects:collegeOne, collegeTwo, nil];
    NSArray *Yvalues = [NSArray arrayWithObjects:collegeOneValue, collegeTwoValue, nil];
    
    NSDictionary *valuesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:Xvalues, @"xvalues", Yvalues, @"yvalues", nil];
    
    return valuesDictionary;
}
-(void)addLabelsToView:(UIView*) theView withData:(NSDictionary*) theData
{
    /*
    //Get locations
    
    UIView *barOne = [self.barsArray objectAtIndex:0];
    
    CGRect barOneFrame = [barOne bounds];
    
    UIView *barTwo = [self.barsArray objectAtIndex:1];
    
    CGRect barTwoFrame = [barTwo bounds];
    
    
    
    //Configure label sizes
    CGRect collegeOneLabelFrame;
    
    collegeOneLabelFrame.origin.x = 20.0;
    collegeOneLabelFrame.origin.y = 20.0;
    
    collegeOneLabelFrame.size.height = 30.0;
    collegeOneLabelFrame.size.width = 100.0;
    
    CGRect collegeTwoLabelFrame;
    
    collegeTwoLabelFrame.origin.x = collegeOneLabelFrame.origin.x + 100.0;
    collegeTwoLabelFrame.origin.y = collegeOneLabelFrame.origin.y;
    
    collegeTwoLabelFrame.size = collegeOneLabelFrame.size;
    
    //Configure label values
    
    NSString *collegeOneValue = [[theData objectForKey:@"yvalues"] objectAtIndex:0];
    NSString *collegeTwoValue = [[theData objectForKey:@"yvalues"] objectAtIndex:1];
    
    //Create labels
    
    UILabel *collegeOneLabel = [[UILabel alloc] initWithFrame:collegeOneLabelFrame];
    UILabel *collegeTwoLabel = [[UILabel alloc] initWithFrame:collegeTwoLabelFrame];
    
    //Configure label text
    
    [collegeOneLabel setText:collegeOneValue];
    [collegeTwoLabel setText:collegeTwoValue];
    
    //Add to view
    
   // [theView addSubview:collegeOneLabel];
    //[theView addSubview:collegeTwoLabel];
    
    */
    
    NSArray *centersArray = [theMainChart xValueFrames];
    
    NSValue *first = [centersArray objectAtIndex:0];
    
    CGPoint centerPoint = [first CGPointValue];
    
    CGRect labelFrame;
    
    labelFrame.origin = centerPoint;
    
    labelFrame.size.width = 50.0;
    labelFrame.size.height = 30.0;
    
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:labelFrame];
    
    [mainLabel setBackgroundColor:[UIColor blueColor]];
    
    [self.view addSubview: mainLabel];
    
}

@end

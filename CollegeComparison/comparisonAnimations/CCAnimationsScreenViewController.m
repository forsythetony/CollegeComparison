//
//  CCAnimationsScreenViewController.m
//  CollegeComparison
//
//  Created by Anthony Forsythe on 11/18/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CCAnimationsScreenViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PNChart.h"

#define MIDSECTIONREFERENCEPOINT 200.0
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CCAnimationsScreenViewController () {
    
    UIView  *detailViewer,
            *myView,
            *barOneView,
            *barTwoView,
            *line1,
            *line2,
            *line3,
            *line4,
            *line5,
            *line6,
            *underlinerView;
    
    UILabel *titleLabel,
            *barOneLabel,
            *barTwoLabel;
    
    NSArray *arrayOfUnderliners,
            *arrayOfUnderLinersForTuition;
    
    NSMutableDictionary *global,
                        *schoolOne,
                        *schoolTwo;
    
    NSMutableArray  *subViewArray,
                    *subviewArray,
                    *underLinerViewArray;
    
    UIButton *handleView,
             *dismissArea,
             *womenButton,
             *menButton,
             *allButton,
             *inState,
             *outState;
    
    UIColor *barOneColor,
            *barTwoColor;
    
    float   mainHeightMultiplier,
            newWidthForMeAndYou,
            BOTTOMREFERENCEPOINT,
            TOPOFDETAILREFERENCEPOINT,
            MIDDLEOFDETAILVIEWREFERENCEPOINT;

    BOOL    haveRaced,
            detailPanelDisplayed,
            resetting,
            isUp;
    
    
    CGPoint lastPoint;
    
    CGRect  barOneFrame,
            barTwoFrame,
            originalMainViewFrame,
            originalDetailViewFrame;
    
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
    
    [self buildBarChartsWithData:[self packageData]];
}

-(void)buildBarChartsWithData:(NSDictionary*) data
{
    CGRect mainViewFrame;
    
    mainViewFrame.origin.x = 0.0;
    mainViewFrame.origin.y = 0.0;
    
    mainViewFrame.size.width = 320.0;
    mainViewFrame.size.height = 375.0;
    
    
    
    UIView *mainView = [[UIView alloc] initWithFrame:mainViewFrame];
    
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:mainViewFrame];
    [barChart setXLabels: [data objectForKey:@"xvalues"]];
    [barChart setYValues: [data objectForKey:@"yvalues"]];
    [barChart setStrokeColor:UIColorFromRGB(0xF05746)];
    [barChart strokeChart];
    
    [mainView addSubview:barChart];
    
    NSLog(@"\n%@\n", self.title);
    
    [self.view addSubview:barChart];
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

@end

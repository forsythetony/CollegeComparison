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
    //[barChart setXLabels: [data objectForKey:@"xvalues"]];
    
    ChartValueFormattingType formatType = [self determineTypeUsingTitle:self.title];
    
    NSArray *formattedValueLabels = [self formattedArrayWithArray:[data objectForKey:@"yvalues"]
                                               andFormattingStyle:formatType];
    
    NSLog(@"\n%@\n", self.title);
    [barChart setAllXLabelsForBottom:[data objectForKey:@"xvalues"] andTop:formattedValueLabels];
    
    NSArray *yValues;
    
    if (formatType == ChartValueFormattingTypePercent) {
        yValues = [self formatYValuesWithArray:[data objectForKey:@"yvalues"]];
        [barChart setYValueMax:100];
    }
    else
    {
        yValues = [data objectForKey:@"yvalues"];
    }
    [barChart setYValues:yValues];
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
    
    self.title = [[dataDict objectForKey:@"All"] objectForKey:@"Title"];
    
    self.parentViewController.navigationItem.title = self.title;
    
    return valuesDictionary;
}
-(void)addLabelsToView:(UIView*) theView withData:(NSDictionary*) theData
{
    
}
-(NSArray*)formattedArrayWithArray:(NSArray*) array andFormattingStyle:(ChartValueFormattingType) type
{
    NSMutableArray *formattedArray = [NSMutableArray new];
    
    NSNumberFormatter *nf = [NSNumberFormatter new];
    
    switch (type) {
        case ChartValueFormattingTypeCurrency:
            [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
            
            for (NSString* value in array){
                float currencyFloat = [value floatValue];
                
                [formattedArray addObject:[nf stringFromNumber:[NSNumber numberWithFloat:currencyFloat]]];
            }
            break;
        case ChartValueFormattingTypePercent:
            [nf setNumberStyle:NSNumberFormatterPercentStyle];
            
            
            for (NSString *value in array) {
                float percentFloat = [value floatValue];
                [formattedArray addObject:[nf stringFromNumber:[NSNumber numberWithFloat:percentFloat]]];
            }
            break;
        case ChartValueFormattingTypeDecimal:
            [nf setNumberStyle:NSNumberFormatterDecimalStyle];
            
            for (NSString *value in array) {
                float decimalFloat = [value floatValue];
                [formattedArray addObject:[nf stringFromNumber:[NSNumber numberWithFloat:decimalFloat]]];
            }
            break;
        default:
            break;
    }
    
    return [NSArray arrayWithArray:formattedArray];
}
-(ChartValueFormattingType)determineTypeUsingTitle:(NSString*) title
{
    if ([title isEqualToString:@"Tuition"]) {
        return ChartValueFormattingTypeCurrency;
    }
    else if ([title isEqualToString:@"Enrollment Total"])
    {
        return ChartValueFormattingTypeDecimal;
    }
    else if ([title isEqualToString:@"Financial Aid"])
    {
        return ChartValueFormattingTypePercent;
    }
    else
        return ChartValueFormattingTypeDecimal;
    
}
-(NSArray*)formatYValuesWithArray:(NSArray*) array
{
    
    NSMutableArray *fixedArray = [NSMutableArray new];
    
    for (NSString *value in array) {
        float percentValue = [value floatValue];
        
        percentValue *= 100.0;
        
        NSString *fixedValue = [NSString stringWithFormat:@"%.2lf", percentValue];
        
        [fixedArray addObject:fixedValue];
    }
    
    return [NSArray arrayWithArray:fixedArray];
    
    
    
}
@end

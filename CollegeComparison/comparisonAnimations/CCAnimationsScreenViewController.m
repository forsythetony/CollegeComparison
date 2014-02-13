//
//  CCAnimationsScreenViewController.m
//  CollegeComparison
//
//  Created by Anthony Forsythe on 11/18/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CCAnimationsScreenViewController.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
    tuitionPage,
    enrollmentPage,
    financialAidPercentage,
    undefinedPage
}   pageType;

#define MIDSECTIONREFERENCEPOINT 200.0
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define CORALCOLOR UIColorFromRGB(0xF05746)

@interface CCAnimationsScreenViewController () {
    PNBarChart *theMainChart;
    
    NSDictionary *theLook;

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
    //Configure visual properties
    [self configureAesthetics];
    
    //For BarChart
    NSDictionary *data = [self packageData];
    
    pageType currentPage = [self determinePageTypeForString:[[self.modifierDictionary objectForKey:@"All"] objectForKey:@"Title"]];

    UIView *mainView;
    
    if (currentPage == financialAidPercentage) {
        mainView = [self buildDonutChartsWithData:data];
    }
    else
    {
        mainView = [self buildBarChartsWithData:data];
    }
  
    
    [self.view addSubview:mainView];
}

-(UIView*)buildBarChartsWithData:(NSDictionary*) data
{
    CGRect userPrefRect = [[theLook objectForKey:@"bRect"] CGRectValue];
    
    CGRect mainViewFrame;
    
    mainViewFrame.origin = userPrefRect.origin;
    
    mainViewFrame.size.width = userPrefRect.size.width;
    
    if (!IS_IPHONE_5) {
        mainViewFrame.size.height = 345.0 + userPrefRect.size.height;
    }
    else
    {
        mainViewFrame.size.height = 450.0 + userPrefRect.size.height;
    }
    
    UIView *mainView = [[UIView alloc] initWithFrame:mainViewFrame];
    
    mainViewFrame.origin.y += 30.0;
    
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:mainViewFrame];

    [barChart setBackgroundColor:[theLook objectForKey:@"barBackground"]];
    
    
    ChartValueFormattingType formatType = [self determineTypeUsingTitle:self.title];
    
    NSArray *formattedValueLabels = [self formattedArrayWithArray:[data objectForKey:@"yvalues"]
                                               andFormattingStyle:formatType];
    [barChart setAllXlabelsForBottom:[data objectForKey:@"xvalues"] andTop:formattedValueLabels];
    
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
    [barChart setStrokeColor:[theLook objectForKey:@"barColor"]];
    [barChart strokeChart];
    
    theMainChart = barChart;
    
    [mainView addSubview:barChart];
    
    NSLog(@"\n%@\n", self.title);


    return mainView;
}
-(NSDictionary*)packageData
{
    NSDictionary *dataDict = self.modifierDictionary;

    NSArray *Xvalues = [self getXValuesFromData:dataDict];
    NSArray *Yvalues = [self getYValuesFromData:dataDict];
    
    NSDictionary *valuesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:Xvalues, @"xvalues", Yvalues, @"yvalues", nil];
    
    self.title = [[dataDict objectForKey:@"All"] objectForKey:@"Title"];
    
    self.parentViewController.navigationItem.title = self.title;
    
    return valuesDictionary;
}
-(UIView*)buildDonutChartsWithData:(NSDictionary*) theData
{
    NSDictionary *circleGraphConfig = [theLook objectForKey:@"percentageInfo"];
    
    CGRect userPrefRect = [[theLook objectForKey:@"bRect"] CGRectValue];
    
    CGRect mainViewFrame;
    
    mainViewFrame.origin = userPrefRect.origin;
    
    mainViewFrame.size.width = userPrefRect.size.width;
    
    if (!IS_IPHONE_5) {
        mainViewFrame.size.height = 345.0 + userPrefRect.size.height;
    }
    else
    {
        mainViewFrame.size.height = 450.0 + userPrefRect.size.height;
    }
    
    UIView *mainView = [[UIView alloc] initWithFrame:mainViewFrame];

    [mainView setBackgroundColor:[UIColor clearColor]];
    
    
    float midPointOfView = mainView.center.y;
    
    
    //  Font to use for labels
    
    UIFont *labelFont = [UIFont fontWithName:@"Avenir-Heavy" size:20.0];
    
    //  Line width to use for circle charts
    
    NSNumber *lineWidth = [NSNumber numberWithFloat:30.0];
    
    
    
    
    //  Create square one
    CGRect collegeOneSubviewFrame;
    
    collegeOneSubviewFrame.origin = CGPointMake(0.0, 0.0);
    collegeOneSubviewFrame.size.width = 320.0;
    collegeOneSubviewFrame.size.height = midPointOfView;
    
    UIView *collegeOneSubview = [[UIView alloc] initWithFrame:collegeOneSubviewFrame];
    
    [collegeOneSubview setBackgroundColor:[UIColor clearColor]];
    
    [mainView addSubview:collegeOneSubview];
    
    
    
        //  Create label
    
        CGRect collegeOneLabelFrame;
        
        collegeOneLabelFrame.origin = CGPointMake(0.0, 5.0);
        collegeOneLabelFrame.size.width = 320.0;
        collegeOneLabelFrame.size.height = 20.0;
        
        
        UILabel *collegeOneLabel = [[UILabel alloc] initWithFrame:collegeOneLabelFrame];
        
        [collegeOneLabel setText:[[theData objectForKey:@"xvalues"] objectAtIndex:0]];
        [collegeOneLabel setTextAlignment:NSTextAlignmentCenter];
        
        [collegeOneLabel setFont:labelFont];
        
        
        
        [collegeOneSubview addSubview:collegeOneLabel];
    
    
    
        //  Create college one circle chart
    
        CGRect collegeOneCircleFrame;
    
        float squareDimension = midPointOfView * .75;
    
        collegeOneCircleFrame.origin = CGPointMake((mainViewFrame.size.width / 8.0), ((midPointOfView * .25) / 2) - 3.0);
        
    
        
        collegeOneCircleFrame.size = CGSizeMake(squareDimension, squareDimension);
    
    
    
        float schoolOneFloatValue = [[[self.modifierDictionary objectForKey:@"One"] objectForKey:@"Height"] floatValue];
        
        schoolOneFloatValue *= 100.0;
        
        NSNumber *schoolOneValue = [NSNumber numberWithFloat:schoolOneFloatValue];
        
        PNCircleChart *collegeOneCircle = [[PNCircleChart alloc] initWithFrame:collegeOneCircleFrame andTotal:[NSNumber numberWithFloat:100.0] andCurrent:schoolOneValue];
    
    [collegeOneCircle setLineWidth:lineWidth];
    
    [collegeOneCircle setStrokeColor:[circleGraphConfig objectForKey:@"oneColor"]];
    
        [collegeOneSubview addSubview:collegeOneCircle];
        [collegeOneCircle strokeChart];

    //  Create square two
    
    CGRect collegeTwoSubviewFrame;
    
    collegeTwoSubviewFrame.origin = CGPointMake(0.0, midPointOfView);
    
    collegeTwoSubviewFrame.size.width = 320.0;
    collegeTwoSubviewFrame.size.height = midPointOfView;
    
    UIView *collegeTwoSubview = [[UIView alloc] initWithFrame:collegeTwoSubviewFrame];
    
    [collegeTwoSubview setBackgroundColor:[UIColor clearColor]];
    
    [mainView addSubview:collegeTwoSubview];
    
        //  Create square two label
    
        CGRect collegeTwoLabelFrame;
        
        collegeTwoLabelFrame.origin = CGPointMake(0.0, 13.0);
        collegeTwoLabelFrame.size.width = mainViewFrame.size.width;
        collegeTwoLabelFrame.size.height = 20.0;
        
        UILabel *collegeTwoLabel = [[UILabel alloc] initWithFrame:collegeTwoLabelFrame];
        
        [collegeTwoLabel setText:[[theData objectForKey:@"xvalues"] objectAtIndex:1]];
        [collegeTwoLabel setTextAlignment:NSTextAlignmentCenter];
        [collegeTwoLabel setFont:labelFont];
    
    [collegeTwoSubview addSubview:collegeTwoLabel];
    
        //  Create college two circle chart
    
        CGRect collegeTwoCircleFrame;
        
        collegeTwoCircleFrame.origin.x = mainViewFrame.size.width / 8.0;
        collegeTwoCircleFrame.origin.y = ((midPointOfView * .25) / 2) ;
        
        collegeTwoCircleFrame.size = CGSizeMake(squareDimension, squareDimension);
        
        float schoolTwoFloatValue = [[[self.modifierDictionary objectForKey:@"Two"] objectForKey:@"Height"] floatValue];
        
        schoolTwoFloatValue *= 100.0;
        
        NSNumber *schoolTwoNumberValue = [NSNumber numberWithFloat:schoolTwoFloatValue];
        
        PNCircleChart *collegeTwoCircle = [[PNCircleChart alloc] initWithFrame:collegeTwoCircleFrame andTotal:[NSNumber numberWithFloat:100.0] andCurrent:schoolTwoNumberValue];
    
    [collegeTwoCircle setStrokeColor:[circleGraphConfig objectForKey:@"twoColor"]];
    
    
    [collegeTwoCircle setLineWidth:lineWidth];
        [collegeTwoSubview addSubview:collegeTwoCircle];
        
        [collegeTwoCircle strokeChart];
    
    return mainView;
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
-(NSArray*)getYValuesFromData:(NSDictionary*) dataDict
{
    NSMutableArray *array = [NSMutableArray new];
    
    
    NSInteger count = [[[dataDict objectForKey:@"All"] objectForKey:@"Count"] integerValue];
    
    [array addObject:[NSString stringWithFormat:@"%@", [[dataDict objectForKey:@"One"] objectForKey:@"Height"]]];
    [array addObject:[NSString stringWithFormat:@"%@", [[dataDict objectForKey:@"Two"] objectForKey:@"Height"]]];
    
    if (count > 2) {
        [array addObject:[NSString stringWithFormat:@"%@", [[dataDict objectForKey:@"Three"] objectForKey:@"Height"]]];
    }

    
    
    return [NSArray arrayWithArray:array];
    
    
}
-(NSArray*)getXValuesFromData:(NSDictionary*) dataDict
{
    NSMutableArray *array = [NSMutableArray new];
    
    NSInteger count = [[[dataDict objectForKey:@"All"] objectForKey:@"Count"] integerValue];
    
    [array addObject:[[dataDict objectForKey:@"One"] objectForKey:@"Name"]];
    [array addObject:[[dataDict objectForKey:@"Two"] objectForKey:@"Name"]];
    
    if (count > 2) {
        [array addObject:[[dataDict objectForKey:@"Three"] objectForKey:@"Name"]];
    }
    
    return [NSArray arrayWithArray:array];
}
-(pageType)determinePageTypeForString:(NSString*) pageTitle
{
    if ([pageTitle isEqualToString:@"Tuition"]) {
        return tuitionPage;
    }
    else if ([pageTitle isEqualToString:@"Financial Aid"])
    {
        return financialAidPercentage;
    }
    else if ([pageTitle isEqualToString:@"Enrollment"])
    {
        return enrollmentPage;
    }
    else
    {
        return undefinedPage;
    }
}

-(void)configureAesthetics
{
    //  Set the bar color
    
        UIColor *barFillColor = CORALCOLOR; // This is a coral color
    
    //  Set the background color for the bar graphs view
    
        UIColor *barGraphBackgroundColor = [UIColor clearColor];
    
    //Configure the frame of the bar graphs
        CGRect barGraphViewFrame;
    
        //  Set the origin of the view. Point 0,0 is located at the top left of the screen and X values increase
        //  going right and Y values increas going down.
    
            barGraphViewFrame.origin.x = 0.0;
            barGraphViewFrame.origin.y = 0.0;
        
        //  Set the size of the view
        
            barGraphViewFrame.size.width = 320.0;
    
        //  Set a height modifier. Because there's a calculation that checks whether the screen is an iPhone 4 or 5
        //  you can't modify that value directly.
    
            barGraphViewFrame.size.height = 0.0;
    
    //  Configure the appearance of percentage circle graphs
    
        //  Line width
    
            float widthOfCircleGraphLine    =   40.0;

        //  Color for college one graph
    
            UIColor *collegeOneCircleGraphColor     =   [UIColor blueberryColor];
            UIColor *collegeTwoCircleGraphColor     =   [UIColor strawberryColor];
    
        //  Color for college two graph
    
    
/*------------DON'T MESS WITH ANYTHING BELOW THIS LINE UNLESS YOU'RE SURE YOU KNOW WHAT YOU'RE DOING----------------------*/
    
    NSValue *bRect = [NSValue valueWithCGRect:barGraphViewFrame];
    
    NSDictionary *percentageInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:widthOfCircleGraphLine], @"lineWidth", collegeOneCircleGraphColor, @"oneColor", collegeTwoCircleGraphColor, @"twoColor", nil];
    
    
    
    theLook = [NSDictionary dictionaryWithObjectsAndKeys:
                                                           barFillColor,
                                                           @"barColor",
                                                           barGraphBackgroundColor,
                                                           @"barBackground",
                                                           bRect,
                                                           @"bRect", percentageInfo, @"percentageInfo", nil];
}
@end

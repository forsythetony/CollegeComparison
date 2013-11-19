//
//  CCAnimationsScreenViewController.m
//  CollegeComparison
//
//  Created by Anthony Forsythe on 11/18/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CCAnimationsScreenViewController.h"
#define BOTTOMREFERENCEPOINT 378.0

@interface CCAnimationsScreenViewController ()

@end

@implementation CCAnimationsScreenViewController

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
    self.hasAnimated = NO;
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [backgroundView setBackgroundColor:[UIColor blackColor]];
    [backgroundView setAlpha:0.05];
    [self.view addSubview:backgroundView];
    
}
-(void)animateAll {
    
    self.hasAnimated = YES;
    
    NSDictionary *schoolOne = [self.modifierDictionary objectForKey:@"One"];
    NSDictionary *schoolTwo = [self.modifierDictionary objectForKey:@"Two"];
    NSDictionary *global = [self.modifierDictionary objectForKey:@"All"];
    
    [self createTitleLabelWithString:[global objectForKey:@"Title"]];
    
    [self createBackgroundLinesWithHeightModifier:[[global objectForKey:@"LineSpacing"] floatValue]
                                         andLabel:[global objectForKey:@"LineLabel"]
                                 andMoneyModifier:[[global objectForKey:@"MoneyValue"] floatValue]
                                 andNumberOfLines:[[global objectForKey:@"Lines"] integerValue]];
    
    
    UIColor *barOneColor = [UIColor colorWithRed:205.0/255.0 green:86.0/255.0 blue:72.0/255.0 alpha:1.0];;
    UIColor *barTwoColor = [UIColor colorWithRed:113.0/255.0 green:173.0/255.0 blue:237.0/255.0 alpha:1.0];;
    
    
    float width = 60.0;
    float exOrigin = 75.0;
    
    CGPoint mainPoint = CGPointMake(exOrigin, 40.0);
    
    // NSLog(@"SCHOOL ONE: %@ SCHOOL TWO: %@", schoolOneName, schoolTwoName);
    
    [self createViewWithPoint:mainPoint
                     andColor:barOneColor
                    andHeight:[[schoolOne objectForKey:@"Height"] floatValue]
                     andWidth:width
          andHeightMultiplier:[[global objectForKey:@"Multiplier"] floatValue]
                   andCollege:[schoolOne objectForKey:@"Name"]];
    
    
    NSLog(@"EX ORIGIN IS:%lf", exOrigin);
    NSLog(@"MAINPOINT.X IS:%lf", mainPoint.x);
    NSLog(@"SCREEN WIDTH:%lf", self.view.bounds.size.width);
    mainPoint.x = 320 - (exOrigin + width);
    
    
    [self createViewWithPoint:mainPoint
                     andColor:barTwoColor
                    andHeight:[[schoolTwo objectForKey:@"Height"] floatValue]
                     andWidth:width
          andHeightMultiplier:[[global objectForKey:@"Multiplier"] floatValue]
                   andCollege:[schoolTwo objectForKey:@"Name"]];
    
    //CGRect newRect = CGRectMake(self.view.bounds.size.width / 2.0 - (40), 395.0, 80.0, 20.0);
    CGRect oldRect = CGRectMake(0.0, BOTTOMREFERENCEPOINT, self.view.bounds.size.width, 50.0);
    UIView* newView = [[UIView alloc] initWithFrame:oldRect];
    [newView setBackgroundColor:[UIColor clearColor]];
    [newView setAlpha:0.25];
    [self.view addSubview:newView];
    
    
    
   // UIColor *coralColor = [UIColor colorWithRed:205.0/255.0 green:86.0/255.0 blue:72.0/255.0 alpha:1.0];
    
    /*
    UIPageControl *newPageController = [[UIPageControl alloc] initWithFrame:newRect];
    [newPageController setNumberOfPages:4];
    [newPageController setTintColor:[UIColor blackColor]];
    [newPageController setOpaque:YES];
    [newPageController setCurrentPageIndicatorTintColor:coralColor];
    [newPageController setCurrentPage:[self getIndex]];
    [self.view addSubview:newPageController];
    
    [newPageController setAlpha:0.0];
    
    [UIView animateWithDuration:0.75 animations:^{
        [newPageController setAlpha:1.0];
    }];
    */
    
      NSLog(@"I JUST WANT THE WORLD TO KNOW THAT I WAS HERE!");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createViewWithPoint:(CGPoint)point andColor:(UIColor*)backgroundColor andHeight:(float)height andWidth:(float)width andHeightMultiplier:(float)multiplier andCollege:(NSString*)college
{
    UIView *theView = [[UIView alloc] init];
    height *= multiplier;
    
    point.y = BOTTOMREFERENCEPOINT - height/2;
    
    CGRect framez = CGRectMake(point.x, point.y, width, 1.0f);
    
    [theView setFrame:framez];
    
    
    UILabel *collegeLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y - height/2 - 17.0, width, 20.0f)];
    
    [collegeLabel setBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:collegeLabel];
    [collegeLabel setTextColor:[UIColor blackColor]];
    collegeLabel.textAlignment = NSTextAlignmentCenter;
    [collegeLabel setText:college];
    [collegeLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:10.0f]];
    
    
    [[self view] addSubview:theView];
    
    [theView setBackgroundColor:backgroundColor];
    
    theView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.5f animations:^{
        theView.transform = CGAffineTransformScale(theView.transform, 1.0f, height);
        
        theView.alpha = 1.0f;
        
    }];
}

-(void)myCustomFunction
{
    
}

-(void)createTitleLabelWithString:(NSString*) title
{
   
    CGPoint screenCenter = self.view.center;
    float width = self.view.bounds.size.width;
    
    CGRect mainLabelFrame = CGRectMake((screenCenter.x - (width/2)), 10.0, width, 40.0);
    
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:mainLabelFrame];
    
    [mainLabel setText:title];
    [mainLabel setTextAlignment:NSTextAlignmentCenter];
    [mainLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20.0f]];
    [mainLabel setAlpha:0.0];
    [self.view addSubview:mainLabel];
    
    
    [UIView animateWithDuration:0.75 animations:^{
        [mainLabel setAlpha:1.0];
    }];
    
    
    
    
    
}

-(void)createBackgroundLinesWithHeightModifier:(float)modifier andLabel:(NSString*)label andMoneyModifier:(int)moneyModifer andNumberOfLines:(int)lines
{
    
    float time = 0.90f;
    int moneyValue = 0;
    NSString *moneyString = [[NSString alloc] init];
    
    CGPoint lineReferencePoint = self.view.center;
    
    lineReferencePoint.y = BOTTOMREFERENCEPOINT;
    
    //float lineSpacingModifier = [self.unitModifier floatValue];
    
    
    for (int i = 0; i < lines; i++)
    {
       
            NSNumber *WoWmoneyValue = [NSNumber numberWithInt:moneyValue];
            moneyString = [NSString stringWithFormat:label, WoWmoneyValue];
            
            NSLog(@"LINE REFERENCE Y: %lf", lineReferencePoint.y);
        
        
            [self createLineWithPoint:lineReferencePoint andTime:time andString:moneyString];
        
        
        
        
            time = time * 1.05f;
            lineReferencePoint.y -= modifier;
            moneyValue += moneyModifer;
        
        
    }

}

-(void)createLineWithPoint:(CGPoint)point andTime:(float)time andString:(NSString*)string
{
    UIView *lineView = [[UIView alloc] init];
    
    CGPoint myPoint = point;
    
    
    
    myPoint.x += 130.0;
    myPoint.y -= 10.0;
    
    if ([string length] <= 3)
    {
        if ([string length] <=2) {
            myPoint.x += 5.0;
        }
        myPoint.x += 5.0;
    }
    
    if (point.y > 40) {
        [self setSmallLabelsWithString:string andtime:time andPoint:myPoint];
    }

    CGRect theFrame = CGRectMake(point.x, point.y, 1.0f, 1.0);
    
    [lineView setFrame:theFrame];
    [[self view] addSubview:lineView];
    
    [lineView setBackgroundColor:[UIColor grayColor]];

    lineView.alpha = 0.0f;
    
    float widthOfScreen = self.view.bounds.size.width;
    
    [UIView animateWithDuration:time animations:^{
        lineView.transform = CGAffineTransformScale(lineView.transform, widthOfScreen, 1.0f);
        lineView.alpha = 0.25f;
        
    }];
}

-(void)setLabel
{
    CGPoint screenCenter = self.view.center;
    float width = self.view.bounds.size.width;
    
    CGRect mainLabelFrame = CGRectMake((screenCenter.x - (width/2)), 300.0, width, 40.0);
    
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:mainLabelFrame];
    
    //  UIColor* backgroundColor = [UIColor colorWithRed:158.0/255.0 green:158.0/255.0 blue:158.0/255.0 alpha:0.5];
    
    // [mainLabel setBackgroundColor:backgroundColor];
    [mainLabel setText:@"Hello"];
    [mainLabel setTextAlignment:NSTextAlignmentCenter];
    [mainLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20.0f]];
    // [mainLabel setBackgroundColor:[UIColor blackColor]];
    [mainLabel setAlpha:0.0];
    [mainLabel setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:mainLabel];
    
    
    [UIView animateWithDuration:0.75 animations:^{
        [mainLabel setAlpha:1.0];
    }];
    

}
-(void)checkBeforeAnimation
{
    if (self.hasAnimated == NO) {
        [self animateAll];
    }
}

-(void)setSmallLabelsWithString:(NSString*) string andtime:(float)itsTime andPoint:(CGPoint)point
{
    UILabel* theLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, 100.0, 20.0)];
    
    [[self view] addSubview:theLabel];
    [theLabel setTextColor:[UIColor blackColor]];
    [theLabel setBackgroundColor:[UIColor clearColor]];
    [theLabel setText:string];
    [theLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:10.0f]];
    
    
    theLabel.alpha = 0.0f;
    
    [UIView animateWithDuration:itsTime animations:^{
        theLabel.alpha = 1.0f;
        
        
    }];
}

-(int)getIndex
{
    return [[[self.modifierDictionary objectForKey:@"All"] objectForKey:@"Index"] intValue] ;
}
@end

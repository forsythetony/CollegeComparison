//
//  CCAnimationsScreenViewController.m
//  CollegeComparison
//
//  Created by Anthony Forsythe on 11/18/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CCAnimationsScreenViewController.h"
#import <QuartzCore/QuartzCore.h>

#define BOTTOMREFERENCEPOINT 329.0
#define TOPOFDETAILREFERENCEPOINT 100.0
#define MIDSECTIONREFERENCEPOINT 200.0

@interface CCAnimationsScreenViewController () {
    
    UIView *detailViewer, *myView;
    
    UILabel *titleLabel;
    
    NSMutableDictionary *global, *schoolOne, *schoolTwo;
    
    CGRect originalMainViewFrame, originalDetailViewFrame;
    
    BOOL detailPanelDisplayed, resetting, isUp;
    
    UIButton *handleView, *dismissArea, *womenButton, *menButton, *allButton;
    UIButton *inState, *outState;
    
    CGPoint lastPoint;
    
    NSMutableArray *subviewArray;
    
    UIView *barOneView, *barTwoView;
    UILabel *barOneLabel, *barTwoLabel;
    
    CGRect barOneFrame, barTwoFrame;
    
    float mainHeightMultiplier;
    
}
@end

@implementation CCAnimationsScreenViewController

#pragma mark Initialization Methods

-(void)checkBeforeAnimation
{
    
    if (self.hasAnimated == NO)
    {
        [self animateAll];
    }
}

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
    
    
    self.labelPlaces = [[NSMutableArray alloc] init];
    
    subviewArray = [[NSMutableArray alloc] init];
    
    [self justseeing];
}
-(void)animateAll
{
    
    self.hasAnimated = YES;
    detailPanelDisplayed = NO;
    
    originalMainViewFrame = self.view.bounds;
    
    
    schoolOne = [NSMutableDictionary new];
    schoolTwo = [NSMutableDictionary new];
    global = [NSMutableDictionary new];
    
    schoolOne = [self.modifierDictionary objectForKey:@"One"];
    schoolTwo = [self.modifierDictionary objectForKey:@"Two"];
    global = [self.modifierDictionary objectForKey:@"All"];
    
    if (![[global objectForKey:@"Title"] isEqualToString:@"Enrollment Total"]) {
         [self createTitleLabelWithString:[global objectForKey:@"Title"]];
    }
   
    
    
    [self createBackgroundLinesWithHeightModifier:[[global objectForKey:@"LineSpacing"] floatValue]
                                         andLabel:[global objectForKey:@"LineLabel"]
                                 andMoneyModifier:[[global objectForKey:@"MoneyValue"] floatValue]
                                 andNumberOfLines:[[global objectForKey:@"Lines"] integerValue]];
    
    
    UIColor *barOneColor = [UIColor colorWithRed:205.0/255.0 green:86.0/255.0 blue:72.0/255.0 alpha:1.0];;
    UIColor *barTwoColor = [UIColor colorWithRed:113.0/255.0 green:173.0/255.0 blue:237.0/255.0 alpha:1.0];;
    
    
    float width = 60.0;
    float exOrigin = 60.0;
    
    CGPoint mainPoint = CGPointMake(exOrigin, 40.0);
    
//    if ([[global objectForKey:@"Title"] isEqualToString:@"Financial Aid"]) {
//        [self buttonsForMenAndWomen];
//    }
    
    [self createGrowingBarWithPoint:mainPoint
                           andColor:barOneColor
                          andHeight:[[schoolOne objectForKey:@"Height"] floatValue]
                           andWidth:width
                andHeightMultiplier:[[global objectForKey:@"Multiplier"] floatValue]
                         andCollege:[schoolOne objectForKey:@"Name"]
     
                           andLabel:barOneLabel];
    
    
    mainPoint.x = 320 - (exOrigin + width);
    
    
    [self createGrowingBarWithPoint:mainPoint
                           andColor:barTwoColor
                          andHeight:[[schoolTwo objectForKey:@"Height"] floatValue]
                           andWidth:width
                andHeightMultiplier:[[global objectForKey:@"Multiplier"] floatValue]
                         andCollege:[schoolTwo objectForKey:@"Name"]
     
                           andLabel:barTwoLabel];
    
    CGRect oldRect = CGRectMake(0.0, BOTTOMREFERENCEPOINT, self.view.bounds.size.width, 50.0);
    
    UIView* newView = [[UIView alloc] initWithFrame:oldRect];
    [newView setBackgroundColor:[UIColor clearColor]];
    [newView setAlpha:0.25];
   // [self.view addSubview:newView];
    [self customAddSubview:newView toSuperView:self.view];
    
    [self.view bringSubviewToFront:myView];
    
    [self.view bringSubviewToFront:menButton];
    [self.view bringSubviewToFront:womenButton];
    
    
    NSArray *subviewsOfView = [self.view subviews];
    
    NSLog(@"\n\nNumber of Subviews: %i\n\nIndex of WomenButton: %i", [subviewsOfView count], [subviewsOfView indexOfObject:womenButton]);
    
    
    
}

#pragma mark Main Animation Methods -

-(void)createTitleLabelWithString:(NSString*) title
{
    
    CGPoint screenCenter = self.view.center;
    float width = self.view.bounds.size.width;
    
    CGRect mainLabelFrame = CGRectMake((screenCenter.x - (width/2)), 0.0, width, 40.0);
    
    titleLabel = [[UILabel alloc] initWithFrame:mainLabelFrame];
    
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20.0f]];
    [titleLabel setAlpha:0.0];
    //[self.view addSubview:titleLabel];
    [self customAddSubview:titleLabel toSuperView:self.view];
    
    [UIView animateWithDuration:0.75 animations:^{
        [titleLabel setAlpha:1.0];
    }];
}

-(void)createBackgroundLinesWithHeightModifier:(float)modifier andLabel:(NSString*)label andMoneyModifier:(int)moneyModifer andNumberOfLines:(int)lines
{
    float time = 0.90f;
    
    int moneyValue = 0;
    NSString *moneyString = [[NSString alloc] init];
    
    CGPoint lineReferencePoint = self.view.center;
    
    lineReferencePoint.y = BOTTOMREFERENCEPOINT;
    
    for (int i = 0; i < lines; i++)
    {
        
        NSNumber *moneyValueObject = [NSNumber numberWithInt:moneyValue];
        moneyString = [NSString stringWithFormat:label, moneyValueObject];
        
        NSLog(@"LINE REFERENCE Y: %lf", lineReferencePoint.y);
        
        if (lineReferencePoint.y > 30.0) {
            [self createLineWithPoint:lineReferencePoint andTime:time andString:moneyString];
        }
        
        time *= 1.05f;
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
        if ([string length] <=2)
        {
            myPoint.x += 5.0;
        }
        
        myPoint.x += 5.0;
    }
    if (point.y > 30)
    {
        [self setSmallLabelsWithString:string andtime:time andPoint:myPoint];
    }
    
    CGRect theFrame = CGRectMake(point.x, point.y, 1.0f, 1.0);
    
    [lineView setFrame:theFrame];
//    [[self view] addSubview:lineView];
    [self customAddSubview:lineView toSuperView:self.view];
    
    [lineView setBackgroundColor:[UIColor blackColor]];
    
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
    
    [mainLabel setText:@"Hello"];
    [mainLabel setTextAlignment:NSTextAlignmentCenter];
    [mainLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20.0f]];
    [mainLabel setAlpha:0.0];
    [mainLabel setBackgroundColor:[UIColor redColor]];
  //  [self.view addSubview:mainLabel];
    [self customAddSubview:mainLabel toSuperView:self.view];
    
    
    [UIView animateWithDuration:0.75 animations:^{
        [mainLabel setAlpha:1.0];
    }];
}

-(void)setSmallLabelsWithString:(NSString*) string andtime:(float)itsTime andPoint:(CGPoint)point
{
    
    UILabel* theLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y + -5.0, 100.0, 20.0)];
    //[[self view] addSubview:theLabel];
    [self customAddSubview:theLabel toSuperView:self.view];
    
    [theLabel setTextColor:[UIColor blackColor]];
    [theLabel setBackgroundColor:[UIColor clearColor]];
    [theLabel setText:string];
    [theLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:10.0f]];
    
    theLabel.alpha = 0.0f;
    
    [UIView animateWithDuration:itsTime animations:^{
        theLabel.alpha = 1.0f;
    }];
}



-(void)createGrowingBarWithPoint:(CGPoint)point andColor:(UIColor*)backgroundColor andHeight:(float)height andWidth:(float)width andHeightMultiplier:(float)multiplier andCollege:(NSString*)college andLabel:(UILabel*) mainCollegeLabel
{

    UIView *mainBarView = [[UIView alloc] init];
    height *= multiplier;
    mainHeightMultiplier = multiplier;
    point.y = BOTTOMREFERENCEPOINT;
    
    CGRect framez = CGRectMake(point.x, point.y, width, 1.0f);
    
    [mainBarView setFrame:framez];
    
    CGRect labelFrame = CGRectMake(point.x, BOTTOMREFERENCEPOINT - 15.0 - 10.0, width, 30.0f);
    mainCollegeLabel = [[UILabel alloc] initWithFrame:labelFrame];
    mainCollegeLabel.numberOfLines = 2;
    
    self.mainFrame = CGRectMake(point.x, BOTTOMREFERENCEPOINT - 30.0, width, 20.0f);
    [mainCollegeLabel setBackgroundColor:[UIColor clearColor]];
   // [[self view] addSubview:mainCollegeLabel];
    [self customAddSubview:mainCollegeLabel toSuperView:self.view];
    
    [mainCollegeLabel setTextColor:[UIColor blackColor]];
    mainCollegeLabel.textAlignment = NSTextAlignmentCenter;
    [mainCollegeLabel setText:college];
    [mainCollegeLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:10.0f]];
    [mainCollegeLabel setAlpha:0.750];
    
    
//    [[self view] addSubview:theView];
    [self customAddSubview:mainBarView toSuperView:self.view];
    
    [mainBarView setBackgroundColor:backgroundColor];
    
    mainBarView.alpha = 0.75f;
    
    NSLog(@"\n\nFrame Origin x = %lf\n\n", framez.origin.x);
    
    
    CGRect testRect = CGRectMake(framez.origin.x, framez.origin.y, framez.size.width, -(height));
    
    NSLog(@"\nFrame Value in Creation: %@\n", NSStringFromCGRect(testRect));
    
    
    if (framez.origin.x < 100.0) {
        barOneFrame = CGRectMake(framez.origin.x, framez.origin.y, framez.size.width, -(height));
        barOneView = mainBarView;
        barOneLabel = mainCollegeLabel;
        
    }
   else if (framez.origin.x > 100.0)
    {
         barTwoFrame = CGRectMake(framez.origin.x, framez.origin.y, framez.size.width, -(height));
        barTwoView = mainBarView;
        barTwoLabel = mainCollegeLabel;
    }
    
    [UIView animateWithDuration:1.0f animations:^{
        
        [mainBarView setFrame:CGRectMake(framez.origin.x, framez.origin.y, framez.size.width, -(height))];
        mainBarView.alpha = 1.0f;
        [mainCollegeLabel setAlpha:1.0f];
        [mainCollegeLabel setFrame:CGRectMake(point.x, point.y - height - 27.0, width, 30.0f)];
        
    }];
    
    CGRect saveFrame = CGRectMake(point.x, point.y - height - 17.0, width, 20.0f);
    
    
    [self.labelPlaces addObject:[NSValue valueWithCGRect:saveFrame]];
}

#pragma mark Creating Information Panel -

-(void)createPanelByMove
{
    
    if (!detailViewer)
    {
        
        detailPanelDisplayed = YES;
        
        detailViewer = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, BOTTOMREFERENCEPOINT + 1.0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        originalDetailViewFrame = detailViewer.bounds;
        
        UIImage *backgroundImage = [UIImage imageNamed:@"ios-linen.png"];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        
//        [detailViewer addSubview:backgroundImageView];
        [self customAddSubview:backgroundImageView toSuperView:detailViewer];
        
        [detailViewer sendSubviewToBack:backgroundImageView];
        [detailViewer setBackgroundColor:[UIColor grayColor]];
      //  [self.view addSubview:detailViewer];
        [self customAddSubview:detailViewer toSuperView:self.view];
        
        
        // NSLog(@"Width: %f Height: %f", self.view.bounds.size.width, self.view.bounds.size.height);
        
        
        [self setPropertiesOfDetailView];
        
        UIView *swipeGestureSubview = [[UIView alloc] initWithFrame:detailViewer.bounds];
        
        [swipeGestureSubview setBackgroundColor:[UIColor clearColor]];
        
//        [detailViewer addSubview:swipeGestureSubview];
        [self customAddSubview:swipeGestureSubview toSuperView:detailViewer];
        
        
    }
}

-(void)removeInformationPanel
{
    
    //This will remove the information panel along with the info handle
    if (resetting == YES)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            [detailViewer setAlpha:0.0];
            [handleView setAlpha:0.0];
            
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x,
                                                  self.view.bounds.size.height,
                                                  self.view.bounds.size.width,
                                                  self.view.bounds.size.height)];
                
                [detailViewer removeFromSuperview];
                [handleView removeFromSuperview];
                [dismissArea removeFromSuperview];
                dismissArea = nil;
                detailViewer = nil;
                handleView = nil;
            }];
        }];
    }
}

-(void)setPropertiesOfDetailView
{
    
    int index = [[global objectForKey:@"Index"] integerValue];
    switch (index) {
        case 0:
            [self configureDetailViewForOverall];
            break;
        case 1:
            [self configureDetailViewForTuition];
            break;
        case 2:
            [self configureDetailViewForPopulation];
            break;
        case 3:
            [self configureDetailViewForAid];
            break;
        default:
            //  [self configureDetailViewForAid];
            break;
    }
}

-(void)removeDuringTransition
{
    if (detailPanelDisplayed == YES) {
        
        resetting = YES;
        [self removeInformationPanel];
        resetting = NO;
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer*) gestureRecognizer
{
    
    CGPoint thePoint = [gestureRecognizer locationInView:self.view];
    
    //    NSLog(@"%.f", lastPoint.y - thePoint.y);
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        if (thePoint.y >= TOPOFDETAILREFERENCEPOINT && isUp == NO) {
            
            [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x,
                                              thePoint.y,
                                              self.view.bounds.size.width,
                                              self.view.bounds.size.height)];
            
            [handleView setFrame:CGRectMake(self.view.center.x - (35.0 / 2.0),
                                            thePoint.y - 15.0,
                                            35.0,
                                            20.0)];
        }
        
        else if (isUp == YES)
        {
            
            
            if (thePoint.y <= TOPOFDETAILREFERENCEPOINT)
            {
                thePoint.y = TOPOFDETAILREFERENCEPOINT;
            }
            
            
            [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x,
                                              thePoint.y,
                                              self.view.bounds.size.width,
                                              self.view.bounds.size.height)];
            
            [handleView setFrame:CGRectMake(self.view.center.x - (35.0 / 2.0),
                                            thePoint.y - 15.0,
                                            35.0,
                                            20.0)];
        }
        
        
        [self.view bringSubviewToFront:handleView];
        
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if (thePoint.y < MIDSECTIONREFERENCEPOINT)
        {
            
            if (lastPoint.y - thePoint.y < - 7.0)
            {
                
                [UIView animateWithDuration:0.25 animations:^{
                    [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x,
                                                      self.view.bounds.size.height,
                                                      self.view.bounds.size.width,
                                                      self.view.bounds.size.height)];
                    
                    [handleView setFrame:CGRectMake(self.view.center.x - (35.0 / 2.0),
                                                    BOTTOMREFERENCEPOINT - 15.0,
                                                    35.0,
                                                    20.0)];
                }];
                
                isUp = NO;
                
                
            }
            else
            {
                [UIView animateWithDuration:0.25 animations:^{
                    [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x,
                                                      TOPOFDETAILREFERENCEPOINT,
                                                      self.view.bounds.size.width,
                                                      self.view.bounds.size.height)];
                    
                    [handleView setFrame:CGRectMake(self.view.center.x - (35.0 / 2.0),
                                                    TOPOFDETAILREFERENCEPOINT - 15.0,
                                                    35.0,
                                                    20.0)];
                }];
                
                isUp = YES;
            }
            
        }
        
        else if (lastPoint.y >= MIDSECTIONREFERENCEPOINT)
        {
            if (lastPoint.y - thePoint.y > 7.0) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x,
                                                      TOPOFDETAILREFERENCEPOINT,
                                                      self.view.bounds.size.width,
                                                      self.view.bounds.size.height)];
                    
                    [handleView setFrame:CGRectMake(self.view.center.x - (35.0 / 2.0),
                                                    TOPOFDETAILREFERENCEPOINT - 15.0,
                                                    35.0,
                                                    20.0)];
                }];
                
                isUp = YES;
                
            }
            
            else if ((int)(lastPoint.y - thePoint.y) == 0 && thePoint.y > BOTTOMREFERENCEPOINT - 15.0)
            {
                [self createPanelByMove];
                [self bounceAnimation];
                isUp = NO;
            }
            else
            {
                [UIView animateWithDuration:0.25 animations:^{
                    [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x,
                                                      self.view.bounds.size.height,
                                                      self.view.bounds.size.width,
                                                      self.view.bounds.size.height)];
                    
                    [handleView setFrame:CGRectMake(self.view.center.x - (35.0 / 2.0),
                                                    BOTTOMREFERENCEPOINT - 15.0,
                                                    35.0,
                                                    20.0)];
                    
                    isUp = NO;
                }];
                
            }
        }
        
        resetting = YES;
        [self buttonToDismiss];
        resetting = NO;
        
    }
    
    
    
    lastPoint = thePoint;
}

-(void)createHandle
{
    
    //    NSLog(@"hello there peoples");
    if (!handleView)
    {
        
        [self createPanelByMove];
        
        handleView = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - (35.0 / 2.0),
                                                                BOTTOMREFERENCEPOINT - 15.0,
                                                                35.0,
                                                                20.0)];
        
        [handleView addTarget:self action:@selector(bounceAnimation) forControlEvents:UIControlEventTouchUpInside];
        
        handleView.layer.cornerRadius = 2.5;
        [handleView setBackgroundColor:[UIColor colorWithRed:0.0
                                                       green:0.0
                                                        blue:0.0
                                                       alpha:0.3]];
        
        
        UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(-3.0,
                                                                       -25.0,
                                                                       40.0,
                                                                       40.0)];
        
        [moreLabel setText:@"Info"];
        
        moreLabel.font = [UIFont fontWithName:@"Avenir-Book" size:10.0];
        moreLabel.textAlignment = NSTextAlignmentCenter;
        
        float why = 5.0;
        
        for (int i = 0; i < 2; i++)
        {
            UIView *lines = [[UIView alloc] initWithFrame:CGRectMake(7.5, why, 20.0, 2.0)];
            
            
            lines.layer.cornerRadius = 2.0;
            
            [lines setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.15]];
            
//            [handleView addSubview:lines];
            [self customAddSubview:lines toSuperView:handleView];
            
            why += 5.0;
        }
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        
        longPressRecognizer.minimumPressDuration = .001;
        
        [handleView addGestureRecognizer:longPressRecognizer];
        
//        [handleView addSubview:moreLabel];
        [self customAddSubview:moreLabel toSuperView:handleView];
        
//        [self.view addSubview:handleView];
        [self customAddSubview:handleView toSuperView:self.view];
        
    }
    
    
}
-(void)bounceAnimation
{
    
    [UIView animateWithDuration:0.35 animations:^{
        
        [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x,
                                          BOTTOMREFERENCEPOINT - 70.0,
                                          self.view.bounds.size.width,
                                          self.view.bounds.size.height)];
        
        [handleView setFrame:CGRectMake(self.view.center.x - (handleView.bounds.size.width/2),
                                        BOTTOMREFERENCEPOINT - 85.0,
                                        handleView.bounds.size.width,
                                        handleView.bounds.size.height)];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.35 animations:^{
            
            [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x,
                                              BOTTOMREFERENCEPOINT + 1.0,
                                              self.view.bounds.size.width,
                                              self.view.bounds.size.height)];
            
            [handleView setFrame:CGRectMake(self.view.center.x - (handleView.bounds.size.width / 2),
                                            BOTTOMREFERENCEPOINT - 15.0,
                                            handleView.bounds.size.width,
                                            handleView.bounds.size.height)];
            
        } completion:^(BOOL finished) {
            
            [self.view bringSubviewToFront:handleView];
            
        }];
        
    }];
    
}

-(void)buttonToDismiss
{
    if (isUp == YES && !dismissArea) {
        
        dismissArea = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                                 self.view.bounds.origin.y,
                                                                 self.view.bounds.size.width,
                                                                 200.0)];
        
        
        [dismissArea addTarget:self action:@selector(dismissInformationPanel) forControlEvents:UIControlEventTouchUpInside];
        
        [dismissArea setBackgroundColor:[UIColor clearColor]];
        
//        [self.view addSubview:dismissArea];
        [self customAddSubview:dismissArea toSuperView:self.view];
    }
    
    
}

-(void)dismissInformationPanel {
    
    [UIView animateWithDuration:.6 animations:^{
        
        [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x,
                                          BOTTOMREFERENCEPOINT + 1.0,
                                          self.view.bounds.size.width,
                                          self.view.bounds.size.height)];
        
        [handleView setFrame:CGRectMake(self.view.center.x - (handleView.bounds.size.width / 2),
                                        BOTTOMREFERENCEPOINT - 15.0,
                                        handleView.bounds.size.width,
                                        handleView.bounds.size.height)];
        
    } completion:^(BOOL finished) {
        
        [dismissArea removeFromSuperview];
        
    }];
}

-(void)replaceHandle
{
    if (!handleView) {
        [self createPanelByMove];
        
        handleView = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - (35.0 / 2.0),
                                                                BOTTOMREFERENCEPOINT - 15.0,
                                                                35.0,
                                                                20.0)];
        
        [handleView addTarget:self action:@selector(bounceAnimation) forControlEvents:UIControlEventTouchUpInside];
        
        handleView.layer.cornerRadius = 2.5;
        [handleView setBackgroundColor:[UIColor colorWithRed:0.0
                                                       green:0.0
                                                        blue:0.0
                                                       alpha:0.3]];
        
        
        UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(-3.0,
                                                                       -25.0,
                                                                       40.0,
                                                                       40.0)];
        [moreLabel setText:@"Info"];
        
        moreLabel.font = [UIFont fontWithName:@"Avenir-Book" size:10.0];
        moreLabel.textAlignment = NSTextAlignmentCenter;
        
        float why = 5.0;
        
        for (int i = 0; i < 2; i++) {
            
            UIView *lines = [[UIView alloc] initWithFrame:CGRectMake(7.5,
                                                                     why,
                                                                     20.0,
                                                                     2.0)];
            
            lines.layer.cornerRadius = 2.0;
            
            [lines setBackgroundColor:[UIColor colorWithRed:0.0
                                                      green:0.0
                                                       blue:0.0
                                                      alpha:0.15]];
            
//            [handleView addSubview:lines];
            [self customAddSubview:lines toSuperView:handleView];
            
            why += 5.0;
        }
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        
        longPressRecognizer.minimumPressDuration = .001;
        
        [handleView addGestureRecognizer:longPressRecognizer];
        
//        [handleView addSubview:moreLabel];
        [self customAddSubview:moreLabel toSuperView:handleView];
        
        [handleView setAlpha:0.0];
//        [self.view addSubview:handleView];
        [self customAddSubview:handleView toSuperView:self.view];
        
        [UIView animateWithDuration:0.2 animations:^{
            [handleView setAlpha:1.0];
        }];
        
    }
    
        
    
    
    
    
    
}
#pragma mark Unique Detail Panel Configurations

-(void)configureDetailViewForOverall
{
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [dismissButton addTarget:self action:@selector(removeInformationPanel) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:dismissButton];
    [self customAddSubview:dismissButton toSuperView:self.view];
    
    CGRect newFrame = CGRectMake(15.0, 20.0, 200.0, 30.0);
    
    UILabel *mainTitleLabel = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y += 30.0;
    newFrame.origin.x = 5.0;
    newFrame.size.width = 100.0;
    
    UILabel *collegeOne = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y += 35.0;
    
    UILabel *collegeTwo = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.x += newFrame.size.width + 5.0;
    
    newFrame.size.width += 100.0;
    UILabel *collegeTwoTuitionValue = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y -= 35.0;
    
    UILabel *collegeOneTuitionValue = [[UILabel alloc] initWithFrame:newFrame];
    
    
    NSString *titleFromDictionary = [global objectForKey:@"Title"];
    NSString *titleString = [NSString stringWithFormat:@"%@ Stats:", titleFromDictionary];
    
    [mainTitleLabel setText:titleString];
    [mainTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mainTitleLabel setTextColor:[UIColor whiteColor]];
    [mainTitleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    
    NSString *collegeOneNameString = [NSString stringWithFormat:@"%@:", [schoolOne objectForKey:@"Name"]];
    
    [collegeOne setText:collegeOneNameString];
    [collegeOne setBackgroundColor:[UIColor clearColor]];
    [collegeOne setTextColor:[UIColor whiteColor]];
    [collegeOne setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeOne setTextAlignment:NSTextAlignmentRight];
    [collegeOne setBackgroundColor:[UIColor clearColor]];
    
    NSString *CollegeTwoNameString = [NSString stringWithFormat:@"%@:", [schoolTwo objectForKey:@"Name"]];
    
    [collegeTwo setText:CollegeTwoNameString];
    [collegeTwo setBackgroundColor:[UIColor clearColor]];
    [collegeTwo setTextColor:[UIColor whiteColor]];
    [collegeTwo setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeTwo setTextAlignment:NSTextAlignmentRight];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    UIColor *coralColor = [UIColor colorWithRed:205.0/255.0 green:86.0/255.0 blue:72.0/255.0 alpha:1.0];
    
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    float number = [[schoolOne objectForKey:@"Height"] floatValue];
    
    NSString *CollegeValueString = [NSString stringWithFormat:@"#%.0f", number];
    
    [collegeOneTuitionValue setText:CollegeValueString];
    [collegeOneTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeOneTuitionValue setTextColor:coralColor];
    [collegeOneTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeOneTuitionValue setTextAlignment:NSTextAlignmentLeft];
    [collegeOneTuitionValue setBackgroundColor:[UIColor clearColor]];
    
    
    number = [[schoolTwo objectForKey:@"Height"] floatValue];
    
    CollegeValueString = [NSString stringWithFormat:@"#%.0f", number];
    
    [collegeTwoTuitionValue setText:CollegeValueString];
    [collegeTwoTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeTwoTuitionValue setTextColor:coralColor];
    [collegeTwoTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeTwoTuitionValue setTextAlignment:NSTextAlignmentLeft];
    
    
    
    
    
    //    NSLog(@"Length of String: %i", [titleString length]);
    
    float lineWhy = 47.0;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(14.0, lineWhy, 1.0, 1.0)];
    
    [line setBackgroundColor:[UIColor grayColor]];
    
//    [detailViewer addSubview:line];
    [self customAddSubview:line toSuperView:detailViewer];
    
    float newWidth = (float)([titleString length] * 7.5);
    
//    [detailViewer addSubview:mainTitleLabel];
    [self customAddSubview:mainTitleLabel toSuperView:detailViewer];
    
    
    
//    [detailViewer addSubview:collegeOne];
    [self customAddSubview:collegeOne toSuperView:detailViewer];
//    [detailViewer addSubview:collegeTwo];
    [self customAddSubview:collegeTwo toSuperView:detailViewer];

//    [detailViewer addSubview:collegeOneTuitionValue];
    [self customAddSubview:collegeOneTuitionValue toSuperView:detailViewer];
    
//    [detailViewer addSubview:collegeTwoTuitionValue];
    [self customAddSubview:collegeTwoTuitionValue toSuperView:detailViewer];
    
    [UIView animateWithDuration:1.0 animations:^{
        [line setFrame:CGRectMake(14.0, lineWhy, newWidth, 1.0)];
    }];
}


-(void)configureDetailViewForPopulation
{
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [dismissButton addTarget:self action:@selector(removeInformationPanel) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:dismissButton];
    [self customAddSubview:dismissButton toSuperView:self.view];
    
    CGRect newFrame = CGRectMake(15.0, 20.0, 200.0, 30.0);
    
    UILabel *mainTitleLabel = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y += 30.0;
    newFrame.origin.x = 5.0;
    newFrame.size.width = 100.0;
    
    UILabel *collegeOne = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y += 35.0;
    
    UILabel *collegeTwo = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.x += newFrame.size.width + 5.0;
    
    newFrame.size.width += 100.0;
    UILabel *collegeTwoTuitionValue = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y -= 35.0;
    
    UILabel *collegeOneTuitionValue = [[UILabel alloc] initWithFrame:newFrame];
    
    
    NSString *titleFromDictionary = [global objectForKey:@"Title"];
    NSString *titleString = [NSString stringWithFormat:@"%@ Stats:", titleFromDictionary];
    
    [mainTitleLabel setText:titleString];
    [mainTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mainTitleLabel setTextColor:[UIColor whiteColor]];
    [mainTitleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    
    NSString *collegeOneNameString = [NSString stringWithFormat:@"%@:", [schoolOne objectForKey:@"Name"]];
    
    [collegeOne setText:collegeOneNameString];
    [collegeOne setBackgroundColor:[UIColor clearColor]];
    [collegeOne setTextColor:[UIColor whiteColor]];
    [collegeOne setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeOne setTextAlignment:NSTextAlignmentRight];
    [collegeOne setBackgroundColor:[UIColor clearColor]];
    
    NSString *CollegeTwoNameString = [NSString stringWithFormat:@"%@:", [schoolTwo objectForKey:@"Name"]];
    
    [collegeTwo setText:CollegeTwoNameString];
    [collegeTwo setBackgroundColor:[UIColor clearColor]];
    [collegeTwo setTextColor:[UIColor whiteColor]];
    [collegeTwo setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeTwo setTextAlignment:NSTextAlignmentRight];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    UIColor *coralColor = [UIColor colorWithRed:205.0/255.0 green:86.0/255.0 blue:72.0/255.0 alpha:1.0];
    
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    float number = [[schoolOne objectForKey:@"Height"] floatValue];
    
    NSString *CollegeValueString = [NSString stringWithFormat:@"%.0f students", number];
    
    [collegeOneTuitionValue setText:CollegeValueString];
    [collegeOneTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeOneTuitionValue setTextColor:coralColor];
    [collegeOneTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeOneTuitionValue setTextAlignment:NSTextAlignmentLeft];
    [collegeOneTuitionValue setBackgroundColor:[UIColor clearColor]];
    
    
    number = [[schoolTwo objectForKey:@"Height"] floatValue];
    
    CollegeValueString = [NSString stringWithFormat:@"%.0f students", number];
    
    [collegeTwoTuitionValue setText:CollegeValueString];
    [collegeTwoTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeTwoTuitionValue setTextColor:coralColor];
    [collegeTwoTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeTwoTuitionValue setTextAlignment:NSTextAlignmentLeft];
    
    
    
    
    
    //    NSLog(@"Length of String: %i", [titleString length]);
    
    float lineWhy = 47.0;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(14.0, lineWhy, 1.0, 1.0)];
    
    [line setBackgroundColor:[UIColor grayColor]];
    
//    [detailViewer addSubview:line];
    [self customAddSubview:line toSuperView:detailViewer];
    
    float newWidth = (float)([titleString length] * 7.5);
    
    //    [detailViewer addSubview:mainTitleLabel];
    [self customAddSubview:mainTitleLabel toSuperView:detailViewer];
    
    //    [detailViewer addSubview:collegeOne];
    [self customAddSubview:collegeOne toSuperView:detailViewer];
    //    [detailViewer addSubview:collegeTwo];
    [self customAddSubview:collegeTwo toSuperView:detailViewer];
    
    //    [detailViewer addSubview:collegeOneTuitionValue];
    [self customAddSubview:collegeOneTuitionValue toSuperView:detailViewer];
    
    //    [detailViewer addSubview:collegeTwoTuitionValue];
    [self customAddSubview:collegeTwoTuitionValue toSuperView:detailViewer];
    [UIView animateWithDuration:1.0 animations:^{
        [line setFrame:CGRectMake(14.0, lineWhy, newWidth, 1.0)];
    }];
    
}
-(void)configureDetailViewForAid
{
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [dismissButton addTarget:self action:@selector(removeInformationPanel) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:dismissButton];
    [self customAddSubview:dismissButton toSuperView:self.view];
    
    CGRect newFrame = CGRectMake(15.0, 20.0, 200.0, 30.0);
    
    UILabel *mainTitleLabel = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y += 30.0;
    newFrame.origin.x = 5.0;
    newFrame.size.width = 100.0;
    
    UILabel *collegeOne = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y += 35.0;
    
    UILabel *collegeTwo = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.x += newFrame.size.width + 5.0;
    
    UILabel *collegeTwoTuitionValue = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y -= 35.0;
    
    UILabel *collegeOneTuitionValue = [[UILabel alloc] initWithFrame:newFrame];
    
    
    NSString *titleFromDictionary = [global objectForKey:@"Title"];
    NSString *titleString = [NSString stringWithFormat:@"%@ Stats:", titleFromDictionary];
    
    [mainTitleLabel setText:titleString];
    [mainTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mainTitleLabel setTextColor:[UIColor whiteColor]];
    [mainTitleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    
    NSString *collegeOneNameString = [NSString stringWithFormat:@"%@:", [schoolOne objectForKey:@"Name"]];
    
    [collegeOne setText:collegeOneNameString];
    [collegeOne setBackgroundColor:[UIColor clearColor]];
    [collegeOne setTextColor:[UIColor whiteColor]];
    [collegeOne setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeOne setTextAlignment:NSTextAlignmentRight];
    
    NSString *CollegeTwoNameString = [NSString stringWithFormat:@"%@:", [schoolTwo objectForKey:@"Name"]];
    
    [collegeTwo setText:CollegeTwoNameString];
    [collegeTwo setBackgroundColor:[UIColor clearColor]];
    [collegeTwo setTextColor:[UIColor whiteColor]];
    [collegeTwo setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeTwo setTextAlignment:NSTextAlignmentRight];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    UIColor *coralColor = [UIColor colorWithRed:205.0/255.0 green:86.0/255.0 blue:72.0/255.0 alpha:1.0];
    
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    float number = [[schoolOne objectForKey:@"Height"] floatValue];
    
    number /= 100.0;
    
    NSNumber* realNumber = [NSNumber numberWithFloat:number];
    
    NSString *CollegeValueString = [numberFormatter stringFromNumber:realNumber];
    
    [collegeOneTuitionValue setText:CollegeValueString];
    [collegeOneTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeOneTuitionValue setTextColor:coralColor];
    [collegeOneTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeOneTuitionValue setTextAlignment:NSTextAlignmentLeft];
    
    
    number = [[schoolTwo objectForKey:@"Height"] floatValue];
    
    number /= 100.0;
    
    realNumber = [NSNumber numberWithFloat:number];
    
    
    CollegeValueString = [numberFormatter stringFromNumber:realNumber];
    
    
    
    [collegeTwoTuitionValue setText:CollegeValueString];
    [collegeTwoTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeTwoTuitionValue setTextColor:coralColor];
    [collegeTwoTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeTwoTuitionValue setTextAlignment:NSTextAlignmentLeft];
    
    
    
    
    
    //    NSLog(@"Length of String: %i", [titleString length]);
    
    float lineWhy = 47.0;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(14.0, lineWhy, 1.0, 1.0)];
    
    [line setBackgroundColor:[UIColor grayColor]];
    
//    [detailViewer addSubview:line];
    [self customAddSubview:line toSuperView:detailViewer];
    
    float newWidth = (float)([titleString length] * 7.5);
    
    //    [detailViewer addSubview:mainTitleLabel];
    [self customAddSubview:mainTitleLabel toSuperView:detailViewer];
    
    
    
    //    [detailViewer addSubview:collegeOne];
    [self customAddSubview:collegeOne toSuperView:detailViewer];
    //    [detailViewer addSubview:collegeTwo];
    [self customAddSubview:collegeTwo toSuperView:detailViewer];
    
    //    [detailViewer addSubview:collegeOneTuitionValue];
    [self customAddSubview:collegeOneTuitionValue toSuperView:detailViewer];
    
    //    [detailViewer addSubview:collegeTwoTuitionValue];
    [self customAddSubview:collegeTwoTuitionValue toSuperView:detailViewer];
    [UIView animateWithDuration:1.0 animations:^{
        [line setFrame:CGRectMake(14.0, lineWhy, newWidth, 1.0)];
    }];
}
-(void)configureDetailViewForTuition
{
    //Create dismiss button
    
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [dismissButton addTarget:self action:@selector(removeInformationPanel) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:dismissButton];
    [self customAddSubview:dismissButton toSuperView:self.view];
    
    CGRect newFrame = CGRectMake(15.0, 20.0, 200.0, 30.0);
    
    UILabel *mainTitleLabel = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y += 30.0;
    newFrame.origin.x = 5.0;
    newFrame.size.width = 100.0;
    
    UILabel *collegeOne = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y += 35.0;
    
    UILabel *collegeTwo = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.x += newFrame.size.width + 5.0;
    
    UILabel *collegeTwoTuitionValue = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y -= 35.0;
    
    UILabel *collegeOneTuitionValue = [[UILabel alloc] initWithFrame:newFrame];
    
    
    NSString *titleFromDictionary = [global objectForKey:@"Title"];
    NSString *titleString = [NSString stringWithFormat:@"%@ Stats:", titleFromDictionary];
    
    [mainTitleLabel setText:titleString];
    [mainTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mainTitleLabel setTextColor:[UIColor whiteColor]];
    [mainTitleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    
    NSString *collegeOneNameString = [NSString stringWithFormat:@"%@:", [schoolOne objectForKey:@"Name"]];
    
    [collegeOne setText:collegeOneNameString];
    [collegeOne setBackgroundColor:[UIColor clearColor]];
    [collegeOne setTextColor:[UIColor whiteColor]];
    [collegeOne setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeOne setTextAlignment:NSTextAlignmentRight];
    
    NSString *CollegeTwoNameString = [NSString stringWithFormat:@"%@:", [schoolTwo objectForKey:@"Name"]];
    
    [collegeTwo setText:CollegeTwoNameString];
    [collegeTwo setBackgroundColor:[UIColor clearColor]];
    [collegeTwo setTextColor:[UIColor whiteColor]];
    [collegeTwo setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeTwo setTextAlignment:NSTextAlignmentRight];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    UIColor *coralColor = [UIColor colorWithRed:205.0/255.0 green:86.0/255.0 blue:72.0/255.0 alpha:1.0];
    
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSString *CollegeValueString = [numberFormatter stringFromNumber:[schoolOne objectForKey:@"Height"]];
    
    [collegeOneTuitionValue setText:CollegeValueString];
    [collegeOneTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeOneTuitionValue setTextColor:coralColor];
    [collegeOneTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeOneTuitionValue setTextAlignment:NSTextAlignmentLeft];
    
    CollegeValueString = [numberFormatter stringFromNumber:[schoolTwo objectForKey:@"Height"]];
    
    [collegeTwoTuitionValue setText:CollegeValueString];
    [collegeTwoTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeTwoTuitionValue setTextColor:coralColor];
    [collegeTwoTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [collegeTwoTuitionValue setTextAlignment:NSTextAlignmentLeft];
    
    //    NSLog(@"Length of String: %i", [titleString length]);
    
    float lineWhy = 47.0;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(14.0, lineWhy, 1.0, 1.0)];
    
    [line setBackgroundColor:[UIColor grayColor]];
    
//    [detailViewer addSubview:line];
    [self customAddSubview:detailViewer toSuperView:line];
    
    float newWidth = (float)([titleString length] * 7.5);
    
    //    [detailViewer addSubview:mainTitleLabel];
    [self customAddSubview:mainTitleLabel toSuperView:detailViewer];
    
    //    [detailViewer addSubview:collegeOne];
    [self customAddSubview:collegeOne toSuperView:detailViewer];
    //    [detailViewer addSubview:collegeTwo];
    [self customAddSubview:collegeTwo toSuperView:detailViewer];
    
    //    [detailViewer addSubview:collegeOneTuitionValue];
    [self customAddSubview:collegeOneTuitionValue toSuperView:detailViewer];
    
    //    [detailViewer addSubview:collegeTwoTuitionValue];
    [self customAddSubview:collegeTwoTuitionValue toSuperView:detailViewer];    [UIView animateWithDuration:1.0 animations:^{
        [line setFrame:CGRectMake(14.0, lineWhy, newWidth, 1.0)];
    }];
}

#pragma mark Helper Methods -

-(int)getIndex
{
    
    return [[[self.modifierDictionary objectForKey:@"All"] objectForKey:@"Index"] intValue];
}


-(void)justseeing
{
    UIPageControl *pageControl = [UIPageControl appearance];
    
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    UIColor *coralColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:.050];
    
    UIColor *barTwoColor = [UIColor colorWithRed:113.0/255.0 green:173.0/255.0 blue:237.0/255.0 alpha:1.0];;
    pageControl.currentPageIndicatorTintColor = barTwoColor;
    pageControl.backgroundColor = coralColor;
    
    
    [pageControl setFrame:CGRectMake(0.0, 0.0, 320.0, 20.0)];
    
    
}

-(void)buttonsForMenAndWomen
{
    
    if (allButton) {
        
        
        MUITCollege *collegeOne, *collegeTwo;
        NSNumber *malePopulation, *malePopulationTwo;
        
        collegeOne = [global objectForKey:@"Object One"];
        malePopulation = [NSNumber numberWithInteger:collegeOne.enrollment_total];
        
        collegeTwo = [global objectForKey:@"Object Two"];
        malePopulationTwo = [NSNumber numberWithInteger:collegeTwo.enrollment_total];
        
        [schoolOne setValue:malePopulation forKey:@"Height"];
        [schoolTwo setValue:malePopulationTwo forKey:@"Height"];
        
        [self resizeBarsWithOptionSwitching:YES];
        
        womenButton.backgroundColor = [UIColor clearColor];
        allButton.backgroundColor = [UIColor grayColor];
        menButton.backgroundColor = [UIColor clearColor];
        
        [allButton removeFromSuperview];
        allButton = nil;
        
        [womenButton removeFromSuperview];
        womenButton = nil;
        
        [menButton removeFromSuperview];
        menButton = nil;
        
       
    }

    
    
    if (!allButton) {
    
   
    NSLog(@"I RAN I RAN I RAN");
    CGRect buttonFrame = CGRectMake(0.0, 10.0, 75.0, 20.0);
    
    womenButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [womenButton setTag:1];
    [womenButton addTarget:self action:@selector(changePopulationViewWithButton:) forControlEvents:UIControlEventTouchDown];
    [womenButton setTitle:@"By Women"
                 forState:UIControlStateNormal];
    womenButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
   // womenButton.titleLabel.textColor = [UIColor blackColor];
    
    [womenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [womenButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    womenButton.backgroundColor = [UIColor clearColor];
    womenButton.layer.cornerRadius = 4.0;
    buttonFrame.origin.x = self.view.bounds.size.width - 75.0;
    
    menButton = [[UIButton alloc] initWithFrame:buttonFrame];
    menButton.tag = 2;
    [menButton addTarget:self action:@selector(changePopulationViewWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [menButton setTitle:@"By Men" forState:UIControlStateNormal];
    menButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:12.0];
    menButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  //  menButton.titleLabel.textColor = [UIColor blackColor];
    
    [menButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [menButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    menButton.backgroundColor = [UIColor clearColor];
    
    menButton.layer.cornerRadius = 4.0;
    
    CGPoint screenCenter = self.view.center;
    float width = self.view.bounds.size.width - (75 * 2);
    
    buttonFrame = CGRectMake((screenCenter.x - (width/2)), 0.0, width, 40.0);
    
    allButton = [[UIButton alloc] initWithFrame:buttonFrame];
    allButton.tag = 3;
    [allButton addTarget:self action:@selector(changePopulationViewWithButton:) forControlEvents:UIControlEventTouchUpInside];
    allButton.backgroundColor = [UIColor blueColor];
    

    [allButton setTitle:@"Enrollment Total" forState:UIControlStateNormal];
    
    [allButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [allButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:20.0f]];
    
    [allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [allButton setBackgroundColor:[UIColor colorWithWhite:0/255.0 alpha:0.17]];
    allButton.layer.cornerRadius = 4.0;
    
    //[self.view addSubview:titleLabel];
    [self customAddSubview:allButton toSuperView:self.view];
    
    
    
    [self customAddSubview:womenButton toSuperView:self.view];
    [self customAddSubview:menButton toSuperView:self.view];
    }
    
    
}

-(void)changePopulationViewWithButton:(UIButton*) sender
{
    NSNumber *schoolOneValue, *schoolTwoValue, *malePopulation, *malePopulationTwo;
    
    schoolOneValue = [NSNumber new];
    schoolTwoValue = [NSNumber new];
    MUITCollege *collegeOne, *collegeTwo;
    
    UIButton *testButton = (UIButton*)sender;
    
    
    NSLog(@"\n\n\n\nHELLO THERE\n\n\n\n");
    
    switch (testButton.tag) {
        case 1:
            
            
            collegeOne = [global objectForKey:@"Object One"];
            malePopulation = [NSNumber numberWithInteger:collegeOne.enrollment_women];
            
            collegeTwo = [global objectForKey:@"Object Two"];
            malePopulationTwo = [NSNumber numberWithInteger:collegeTwo.enrollment_women];
            
            
            [schoolOne setValue:malePopulation forKey:@"Height"];
            [schoolTwo setValue:malePopulationTwo forKey:@"Height"];
            
            
//            [self customRemoveAllSubviews];
            [self resizeBarsWithOptionSwitching:NO];
            
            womenButton.backgroundColor = [UIColor colorWithWhite:0/255.0 alpha:0.17];
            allButton.backgroundColor = [UIColor clearColor];
            menButton.backgroundColor = [UIColor clearColor];
            break;
        case 2:
            
            collegeOne = [global objectForKey:@"Object One"];
            malePopulation = [NSNumber numberWithInteger:collegeOne.enrollment_men];
            
            collegeTwo = [global objectForKey:@"Object Two"];
            malePopulationTwo = [NSNumber numberWithInteger:collegeTwo.enrollment_men];
            
            [schoolOne setValue:malePopulation forKey:@"Height"];
            [schoolTwo setValue:malePopulationTwo forKey:@"Height"];
            
            [self resizeBarsWithOptionSwitching:NO];
            
            womenButton.backgroundColor = [UIColor clearColor];
            allButton.backgroundColor = [UIColor clearColor];
            menButton.backgroundColor = [UIColor colorWithWhite:0/255.0 alpha:0.17];

            
            break;
        case 3:
            
            collegeOne = [global objectForKey:@"Object One"];
            malePopulation = [NSNumber numberWithInteger:collegeOne.enrollment_total];
            
            collegeTwo = [global objectForKey:@"Object Two"];
            malePopulationTwo = [NSNumber numberWithInteger:collegeTwo.enrollment_total];
            
            [schoolOne setValue:malePopulation forKey:@"Height"];
            [schoolTwo setValue:malePopulationTwo forKey:@"Height"];
            
            [self resizeBarsWithOptionSwitching:NO];

            womenButton.backgroundColor = [UIColor clearColor];
            allButton.backgroundColor = [UIColor colorWithWhite:0/255.0 alpha:0.17];
            menButton.backgroundColor = [UIColor clearColor];

            
            break;
            
    }
}

-(void)customAddSubview:(UIView*) ourSubview toSuperView:(UIView*) ourSuperView
{
    
    [subviewArray addObject:ourSubview];
    
    [ourSuperView addSubview:ourSubview];
 
}

-(void)customRemoveAllSubviews
{
    
    
    for (int i = 0; i < [subviewArray count]; i++) {
        UIView *theView = subviewArray[i];
        
        [theView removeFromSuperview];
        theView = nil;
        [subviewArray removeObject:theView];
    }
    
    
}

-(void)resizeBarsWithOptionSwitching:(BOOL) switching
{
    float barOneHeightValue = [[schoolOne objectForKey:@"Height"] floatValue];
    float barTwoHeightValue = [[schoolTwo objectForKey:@"Height"] floatValue];
    
    float multiplier = [[global objectForKey:@"Multiplier"] floatValue];
    barOneHeightValue *= multiplier;
    barTwoHeightValue *= multiplier;
    
    NSLog(@"Float Value One: %lf", barOneHeightValue);
    
    barOneHeightValue *= -1;
    barTwoHeightValue *= -1;
    
    if (switching == NO) {
        
    [UIView animateWithDuration:1.0f animations:^{
        
        [barOneView setFrame:CGRectMake(barOneFrame.origin.x, BOTTOMREFERENCEPOINT, barOneFrame.size.width, barOneHeightValue)];
        [barTwoView setFrame:CGRectMake(barTwoFrame.origin.x, BOTTOMREFERENCEPOINT, barTwoFrame.size.width, barTwoHeightValue)];
        
      
        
        
        [barOneLabel setFrame:CGRectMake(barOneLabel.center.x - (barOneLabel.bounds.size.width/2),
                                        self.view.bounds.size.height + barOneHeightValue - 28.0, barOneLabel.bounds.size.width, barOneLabel.bounds.size.height)];
        
        [barTwoLabel setFrame:CGRectMake(barTwoLabel.center.x - (barTwoLabel.bounds.size.width/2), self.view.bounds.size.height + barTwoHeightValue - 28.0, barTwoLabel.bounds.size.width, barTwoLabel.bounds.size.height)];
        
        
    
    }];
    }
    else if (switching == YES)
    {
        [barOneView setFrame:CGRectMake(barOneFrame.origin.x, BOTTOMREFERENCEPOINT, barOneFrame.size.width, barOneHeightValue)];
        [barTwoView setFrame:CGRectMake(barTwoFrame.origin.x, BOTTOMREFERENCEPOINT, barTwoFrame.size.width, barTwoHeightValue)];
        
        
        
        
        [barOneLabel setFrame:CGRectMake(barOneLabel.center.x - (barOneLabel.bounds.size.width/2),
                                         self.view.bounds.size.height + barOneHeightValue - 28.0, barOneLabel.bounds.size.width, barOneLabel.bounds.size.height)];
        
        [barTwoLabel setFrame:CGRectMake(barTwoLabel.center.x - (barTwoLabel.bounds.size.width/2), self.view.bounds.size.height + barTwoHeightValue - 28.0, barTwoLabel.bounds.size.width, barTwoLabel.bounds.size.height)];
    }
   
    
    
}

-(void)buttonsForInStateAndOutWithOptionFirst:(BOOL)first
{
    if (inState) {
        
        
        MUITCollege *collegeOne, *collegeTwo;
        NSNumber *inStateTutionOne, *inStateTutionTwo;
        
        collegeOne = [global objectForKey:@"Object One"];
        inStateTutionOne = [NSNumber numberWithInteger:collegeOne.tuition_in_state];
        
        collegeTwo = [global objectForKey:@"Object Two"];
        inStateTutionTwo = [NSNumber numberWithInteger:collegeTwo.tuition_in_state];
        
        [schoolOne setValue:inStateTutionOne forKey:@"Height"];
        [schoolTwo setValue:inStateTutionTwo forKey:@"Height"];
        
        [self resizeBarsWithOptionSwitching:YES];
        
        inState.backgroundColor = [UIColor clearColor];
        outState.backgroundColor = [UIColor colorWithWhite:0/255.0 alpha:0.17];
        
        [allButton removeFromSuperview];
        allButton = nil;
        
        [inState removeFromSuperview];
        inState = nil;
        
        [outState removeFromSuperview];
        outState = nil;
        
        
    }
    
    
    
    if (!inState) {
        
        CGRect buttonFrame = CGRectMake(0.0, 10.0, 75.0, 20.0);
        
        inState = [[UIButton alloc] initWithFrame:buttonFrame];
        [inState setTag:1];
        [inState addTarget:self action:@selector(changeTuitionWithButton:) forControlEvents:UIControlEventTouchDown];
        [inState setTitle:@"In State"
                     forState:UIControlStateNormal];
        inState.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14.0];
        // inState.titleLabel.textColor = [UIColor blackColor];
        
        [inState setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [inState setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [inState.titleLabel setTextAlignment:NSTextAlignmentRight];
        
        inState.backgroundColor = [UIColor clearColor];
        inState.layer.cornerRadius = 4.0;
        buttonFrame.origin.x = self.view.bounds.size.width - 75.0;
        
        outState = [[UIButton alloc] initWithFrame:buttonFrame];
        outState.tag = 2;
        [outState addTarget:self action:@selector(changeTuitionWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [outState setTitle:@"Out of State" forState:UIControlStateNormal];
        outState.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:12.0];
        outState.titleLabel.textAlignment = NSTextAlignmentLeft;
        //  outState.titleLabel.textColor = [UIColor blackColor];
        
        [outState setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [outState setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        outState.backgroundColor = [UIColor clearColor];
        
        outState.layer.cornerRadius = 4.0;
        
        if (first) {
            [inState setBackgroundColor:[UIColor clearColor]];
            [outState setBackgroundColor:[UIColor colorWithWhite:0/255.0 alpha:0.17]];
        }
        
        
        [self customAddSubview:inState toSuperView:self.view];
        [self customAddSubview:outState toSuperView:self.view];
    }
    

}
-(void)changeTuitionWithButton:(UIButton*) sender
{
    NSNumber *schoolOneValue, *schoolTwoValue, *malePopulation, *malePopulationTwo;
    
    schoolOneValue = [NSNumber new];
    schoolTwoValue = [NSNumber new];
    MUITCollege *collegeOne, *collegeTwo;
    
    UIButton *testButton = (UIButton*)sender;

    switch (testButton.tag) {
        case 1:
            
            
            collegeOne = [global objectForKey:@"Object One"];
            malePopulation = [NSNumber numberWithInteger:collegeOne.tuition_in_state];
            
            collegeTwo = [global objectForKey:@"Object Two"];
            malePopulationTwo = [NSNumber numberWithInteger:collegeTwo.tuition_in_state];
            
            
            [schoolOne setValue:malePopulation forKey:@"Height"];
            [schoolTwo setValue:malePopulationTwo forKey:@"Height"];
            
            
            //            [self customRemoveAllSubviews];
            [self resizeBarsWithOptionSwitching:NO];
            
            womenButton.backgroundColor = [UIColor colorWithWhite:0/255.0 alpha:0.17];
            menButton.backgroundColor = [UIColor clearColor];
            break;
        case 2:
            
            collegeOne = [global objectForKey:@"Object One"];
            malePopulation = [NSNumber numberWithInteger:collegeOne.tuition_out_state];
            
            collegeTwo = [global objectForKey:@"Object Two"];
            malePopulationTwo = [NSNumber numberWithInteger:collegeTwo.tuition_out_state];
            
            [schoolOne setValue:malePopulation forKey:@"Height"];
            [schoolTwo setValue:malePopulationTwo forKey:@"Height"];
            
            [self resizeBarsWithOptionSwitching:NO];
            
            womenButton.backgroundColor = [UIColor clearColor];
            menButton.backgroundColor = [UIColor colorWithWhite:0/255.0 alpha:0.17];
            
            
            break;

            
    }
}

@end

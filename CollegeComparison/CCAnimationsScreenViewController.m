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

-(void)checkBeforeAnimation
{
    if (self.hasAnimated == NO)
    {
        [self animateAll];
        
    }
    else if([[global objectForKey:@"Title"] isEqualToString:@"Tuition"])
    {
        [self buttonsForInStateAndOutWithOptionFirst:YES];
    }
    else
    {
        [self removeUnderliners];
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
    
    self.labelPlaces = [NSMutableArray new];
    subviewArray = [NSMutableArray new];
    underLinerViewArray = [NSMutableArray new];
    
    [self setArrayOfUnderliners];
    [self justseeing];
    
    if (IS_IPHONE_5)
    {
        BOTTOMREFERENCEPOINT = 417.0;
        TOPOFDETAILREFERENCEPOINT = 175.0;
        MIDDLEOFDETAILVIEWREFERENCEPOINT = (BOTTOMREFERENCEPOINT + TOPOFDETAILREFERENCEPOINT) / 2.0;
    }
    else
    {
        BOTTOMREFERENCEPOINT = 329.0;
        TOPOFDETAILREFERENCEPOINT = 100.0;
        MIDDLEOFDETAILVIEWREFERENCEPOINT = 200.0;
    }
    
}
-(void)animateAll
{
    haveRaced = NO;
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
                                 andNumberOfLines:(int)[[global objectForKey:@"Lines"] integerValue]];
    
    //This is a coral color
    barOneColor = [UIColor colorWithRed:205.0/255.0
                                  green:86.0/255.0
                                   blue:72.0/255.0
                                  alpha:1.0];
    //This is a blue color
    barTwoColor = [UIColor colorWithRed:113.0/255.0
                                  green:173.0/255.0
                                   blue:237.0/255.0
                                  alpha:1.0];
    
    float width = 60.0;
    float exOrigin = 60.0;
    
    CGPoint mainPoint = CGPointMake(exOrigin, 40.0);
    
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
    [self customAddSubview:newView toSuperView:self.view];
    
    [self.view bringSubviewToFront:myView];
    
    [self.view bringSubviewToFront:menButton];
    [self.view bringSubviewToFront:womenButton];
    
}

#pragma mark Main Animation Methods -

-(void)createTitleLabelWithString:(NSString*) title
{
    
    CGPoint screenCenter = self.view.center;
    float width = self.view.bounds.size.width;
    
    CGRect mainLabelFrame = CGRectMake((screenCenter.x - (width/2)),
                                       0.0,
                                       width,
                                       40.0);
    
    titleLabel = [[UILabel alloc] initWithFrame:mainLabelFrame];
    
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont fontWithName:@"Avenir-Book"
                                        size:20.0f]];
    [titleLabel setAlpha:0.0];
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
        
        if (lineReferencePoint.y > 40.0)
        {
            [self createLineWithPoint:lineReferencePoint
                              andTime:time
                            andString:moneyString];
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
        [self setSmallLabelsWithString:string
                               andtime:time
                              andPoint:myPoint];
    }
    
    CGRect theFrame = CGRectMake(point.x, point.y,
                                 1.0f, 1.0);
    
    [lineView setFrame:theFrame];

    [self customAddSubview:lineView toSuperView:self.view];
    
    [lineView setBackgroundColor:[UIColor blackColor]];
    
    lineView.alpha = 0.0f;
    
    float widthOfScreen = self.view.bounds.size.width;
    
    [UIView animateWithDuration:time animations:^{
        lineView.transform = CGAffineTransformScale(lineView.transform,
                                                    widthOfScreen,
                                                    1.0f);
        lineView.alpha = 0.25f;
    }];
}

-(void)setLabel
{
    
    CGPoint screenCenter = self.view.center;
    float width = self.view.bounds.size.width;
    
    CGRect mainLabelFrame = CGRectMake((screenCenter.x - (width/2)), 300.0,
                                       width, 40.0);
    
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:mainLabelFrame];
    
    [mainLabel setText:@"Hello"];
    [mainLabel setTextAlignment:NSTextAlignmentCenter];
    [mainLabel setFont:[UIFont fontWithName:@"Avenir-Book"
                                       size:20.0f]];
    [mainLabel setAlpha:0.0];
    [mainLabel setBackgroundColor:[UIColor redColor]];
    
    [self customAddSubview:mainLabel toSuperView:self.view];
    
    
    [UIView animateWithDuration:0.75 animations:^{
        [mainLabel setAlpha:1.0];
    }];
}

-(void)setSmallLabelsWithString:(NSString*) string andtime:(float)itsTime andPoint:(CGPoint)point
{
    
    UILabel* theLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y + -5.0, 100.0, 20.0)];

    [self customAddSubview:theLabel toSuperView:self.view];
    
    [theLabel setBackgroundColor:[UIColor clearColor]];
    theLabel.alpha = 0.0f;
    
    [theLabel setText:string];
    [theLabel setTextColor:[UIColor blackColor]];
    [theLabel setFont:[UIFont fontWithName:@"Avenir-Book"
                                      size:10.0f]];
    
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
    
    CGRect framez = CGRectMake(point.x, point.y,
                               width, 1.0f);
    
    [mainBarView setFrame:framez];
    
    [mainBarView setBackgroundColor:backgroundColor];
    
    mainBarView.alpha = 0.75f;

    CGRect labelFrame = CGRectMake(point.x, BOTTOMREFERENCEPOINT - 15.0 - 10.0,
                                   width, 30.0f);
    
    mainCollegeLabel = [[UILabel alloc] initWithFrame:labelFrame];
    
    [mainCollegeLabel setBackgroundColor:[UIColor clearColor]];
    [mainCollegeLabel setAlpha:0.750];
    mainCollegeLabel.numberOfLines = 2;
    
    [mainCollegeLabel setTextColor:[UIColor blackColor]];
    mainCollegeLabel.textAlignment = NSTextAlignmentCenter;
    [mainCollegeLabel setText:college];
    [mainCollegeLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:10.0f]];

    self.mainFrame = CGRectMake(point.x, BOTTOMREFERENCEPOINT - 30.0,
                                width, 20.0f);
    
    [self customAddSubview:mainCollegeLabel toSuperView:self.view];
    
    [self customAddSubview:mainBarView toSuperView:self.view];
    
    if (framez.origin.x < 100.0)
    {
        barOneFrame = CGRectMake(framez.origin.x, framez.origin.y,
                                 framez.size.width, -(height));
        barOneView = mainBarView;
        barOneLabel = mainCollegeLabel;
    }
   else if (framez.origin.x > 100.0)
    {
        barTwoFrame = CGRectMake(framez.origin.x, framez.origin.y,
                                 framez.size.width, -(height));
        barTwoView = mainBarView;
        barTwoLabel = mainCollegeLabel;
    }
    
    [UIView animateWithDuration:1.0f animations:^{
        
        [mainBarView setFrame:CGRectMake(framez.origin.x, framez.origin.y,
                                         framez.size.width, -(height))];
        mainBarView.alpha = 1.0f;
        [mainCollegeLabel setAlpha:1.0f];
        [mainCollegeLabel setFrame:CGRectMake(point.x, point.y - height - 27.0,
                                              width, 30.0f)];
    }];
    
    CGRect saveFrame = CGRectMake(point.x, point.y - height - 17.0,
                                  width, 20.0f);
    
    [self.labelPlaces addObject:[NSValue valueWithCGRect:saveFrame]];
}

#pragma mark Creating Information Panel -

-(void)createPanelByMove
{
    
    if (!detailViewer)
    {
        
        detailPanelDisplayed = YES;
        
        detailViewer = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, BOTTOMREFERENCEPOINT + 1.0,
                                                                self.view.bounds.size.width, self.view.bounds.size.height)];
        
        originalDetailViewFrame = detailViewer.bounds;
        
        UIImage *backgroundImage = [UIImage imageNamed:@"ios-linen.jpg"];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        
        [self customAddSubview:backgroundImageView toSuperView:detailViewer];
        
        [detailViewer sendSubviewToBack:backgroundImageView];
        [detailViewer setBackgroundColor:[UIColor grayColor]];
        
        [self customAddSubview:detailViewer toSuperView:self.view];
        
        [self setPropertiesOfDetailView];
        
        UIView *swipeGestureSubview = [[UIView alloc] initWithFrame:detailViewer.bounds];
        
        [swipeGestureSubview setBackgroundColor:[UIColor clearColor]];
        
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
                [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height,
                                                  self.view.bounds.size.width, self.view.bounds.size.height)];
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
    
    int index = (int)[[global objectForKey:@"Index"] integerValue];
    switch (index)
    {
        case 0:
            [self configureDetailViewForTuitionNewBecauseIDontCare];
            break;
        case 1:
            [self configureDetailViewForPopulation];
            break;
        case 2:
            [self configureDetailViewForAid];
            break;
        default:
            break;
    }
}

-(void)removeDuringTransition
{
    if (detailPanelDisplayed == YES)
    {
        resetting = YES;
        [self removeInformationPanel];
        resetting = NO;
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer*) gestureRecognizer
{
    
    CGPoint thePoint = [gestureRecognizer locationInView:self.view];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        if (thePoint.y >= TOPOFDETAILREFERENCEPOINT && isUp == NO)
        {
            [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x, thePoint.y,
                                              self.view.bounds.size.width, self.view.bounds.size.height)];
            
            [handleView setFrame:CGRectMake(self.view.center.x - (35.0 / 2.0), thePoint.y - 15.0,
                                            35.0, 20.0)];
        }
        else if (isUp == YES)
        {
            if (thePoint.y <= TOPOFDETAILREFERENCEPOINT)
            {
                thePoint.y = TOPOFDETAILREFERENCEPOINT;
            }
            
            [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x, thePoint.y,
                                              self.view.bounds.size.width, self.view.bounds.size.height)];
            
            [handleView setFrame:CGRectMake(self.view.center.x - (35.0 / 2.0), thePoint.y - 15.0,
                                            35.0, 20.0)];
        }
        
        if (thePoint.y > MIDDLEOFDETAILVIEWREFERENCEPOINT)
        {
            [self andTheyreOff];
        }
        
        [self.view bringSubviewToFront:handleView];
        
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if (thePoint.y < MIDDLEOFDETAILVIEWREFERENCEPOINT)
        {
            if (lastPoint.y - thePoint.y < - 7.0)
            {
                
                [UIView animateWithDuration:0.25 animations:^{
                    [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height,
                                                      self.view.bounds.size.width, self.view.bounds.size.height)];
                    
                    [handleView setFrame:CGRectMake(self.view.center.x - (35.0 / 2.0), BOTTOMREFERENCEPOINT - 15.0,
                                                    35.0, 20.0)];
                }];
                
                isUp = NO;
                
            }
            else
            {
                [UIView animateWithDuration:0.25 animations:^{
                    [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x, TOPOFDETAILREFERENCEPOINT,
                                                      self.view.bounds.size.width, self.view.bounds.size.height)];
                    
                    [handleView setFrame:CGRectMake(self.view.center.x - (35.0 / 2.0), TOPOFDETAILREFERENCEPOINT - 15.0,
                                                    35.0, 20.0)];
                }];
                
                
                isUp = YES;
            }
            
        }
        
        else if (lastPoint.y >= MIDDLEOFDETAILVIEWREFERENCEPOINT)
        {
            if (lastPoint.y - thePoint.y > 7.0) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x, TOPOFDETAILREFERENCEPOINT,
                                                      self.view.bounds.size.width, self.view.bounds.size.height)];
                    
                    [handleView setFrame:CGRectMake(self.view.center.x - (35.0 / 2.0), TOPOFDETAILREFERENCEPOINT - 15.0,
                                                    35.0, 20.0)];
                }];
                
                
                isUp = YES;
            }
            
            else if ((int)(lastPoint.y - thePoint.y) == 0
                     && thePoint.y > BOTTOMREFERENCEPOINT - 15.0)
            {
                [self createPanelByMove];
                [self bounceAnimation];
                isUp = NO;
            }
            else
            {
                [UIView animateWithDuration:0.25 animations:^{
                    [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height,
                                                      self.view.bounds.size.width, self.view.bounds.size.height)];
                    
                    [handleView setFrame:CGRectMake(self.view.center.x - (35.0 / 2.0), BOTTOMREFERENCEPOINT - 15.0,
                                                    35.0, 20.0)];
                    
                    isUp = NO;
                }];
                
            }
        }
    }
    
    lastPoint = thePoint;
}

-(void)createHandle
{
    if (!handleView)
    {
        
        [self createPanelByMove];
        
        handleView = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - (35.0 / 2.0), BOTTOMREFERENCEPOINT - 15.0,
                                                                35.0, 20.0)];
        
        [handleView addTarget:self
                       action:@selector(bounceAnimation)
             forControlEvents:UIControlEventTouchUpInside];
        
        handleView.layer.cornerRadius = 2.5;
        [handleView setBackgroundColor:[UIColor colorWithRed:0.0
                                                       green:0.0
                                                        blue:0.0
                                                       alpha:0.3]];
        
        UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(-3.0, -25.0,
                                                                       40.0, 40.0)];
        
        [moreLabel setText:@"Info"];
        moreLabel.font = [UIFont fontWithName:@"Avenir-Book" size:10.0];
        moreLabel.textAlignment = NSTextAlignmentCenter;
        
        float why = 5.0;
        
        for (int i = 0; i < 2; i++)
        {
            UIView *lines = [[UIView alloc] initWithFrame:CGRectMake(7.5, why,
                                                                     20.0, 2.0)];
        
            lines.layer.cornerRadius = 2.0;
            
            [lines setBackgroundColor:[UIColor colorWithRed:0.0
                                                      green:0.0
                                                       blue:0.0
                                                      alpha:0.15]];
            
            [self customAddSubview:lines toSuperView:handleView];
            
            why += 5.0;
        }
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(handleLongPress:)];
        
        longPressRecognizer.minimumPressDuration = .001;
        
        [handleView addGestureRecognizer:longPressRecognizer];
        
        [self customAddSubview:moreLabel toSuperView:handleView];
        
        [self customAddSubview:handleView toSuperView:self.view];
        
    }
}
-(void)bounceAnimation
{
    
    [UIView animateWithDuration:0.35 animations:^{
        
        [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x, BOTTOMREFERENCEPOINT - 70.0,
                                          self.view.bounds.size.width, self.view.bounds.size.height)];
        
        [handleView setFrame:CGRectMake(self.view.center.x - (handleView.bounds.size.width/2), BOTTOMREFERENCEPOINT - 85.0,
                                        handleView.bounds.size.width, handleView.bounds.size.height)];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.35 animations:^{
            
            [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x, BOTTOMREFERENCEPOINT + 1.0,
                                              self.view.bounds.size.width, self.view.bounds.size.height)];
            
            [handleView setFrame:CGRectMake(self.view.center.x - (handleView.bounds.size.width / 2), BOTTOMREFERENCEPOINT - 15.0,
                                            handleView.bounds.size.width, handleView.bounds.size.height)];
            
        } completion:^(BOOL finished) {
            
            [self.view bringSubviewToFront:handleView];
            
        }];
        
    }];
    
}

-(void)dismissInformationPanel {
    
    [UIView animateWithDuration:.6 animations:^{
        
        [detailViewer setFrame:CGRectMake(self.view.bounds.origin.x, BOTTOMREFERENCEPOINT + 1.0,
                                          self.view.bounds.size.width, self.view.bounds.size.height)];
        
        [handleView setFrame:CGRectMake(self.view.center.x - (handleView.bounds.size.width / 2), BOTTOMREFERENCEPOINT - 15.0,
                                        handleView.bounds.size.width, handleView.bounds.size.height)];
        
    } completion:^(BOOL finished) {
        
        [dismissArea removeFromSuperview];
        
    }];
}

-(void)replaceHandle
{
    if (!handleView)
    {
        [self createPanelByMove];
        
        handleView = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - (35.0 / 2.0), BOTTOMREFERENCEPOINT - 15.0,
                                                                35.0, 20.0)];
        
        [handleView addTarget:self
                       action:@selector(bounceAnimation)
             forControlEvents:UIControlEventTouchUpInside];
        
        handleView.layer.cornerRadius = 2.5;
        [handleView setBackgroundColor:[UIColor colorWithRed:0.0
                                                       green:0.0
                                                        blue:0.0
                                                       alpha:0.3]];
        
        
        UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(-3.0, -25.0,
                                                                       40.0, 40.0)];
        
        [moreLabel setText:@"Info"];
        moreLabel.font = [UIFont fontWithName:@"Avenir-Book" size:10.0];
        moreLabel.textAlignment = NSTextAlignmentCenter;
        
        float why = 5.0;
        
        for (int i = 0; i < 2; i++)
        {
            UIView *lines = [[UIView alloc] initWithFrame:CGRectMake(7.5, why,
                                                                     20.0, 2.0)];
            
            lines.layer.cornerRadius = 2.0;
            
            [lines setBackgroundColor:[UIColor colorWithRed:0.0
                                                      green:0.0
                                                       blue:0.0
                                                      alpha:0.15]];
            
            [self customAddSubview:lines toSuperView:handleView];
            
            why += 5.0;
        }
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(handleLongPress:)];
        
        longPressRecognizer.minimumPressDuration = .001;
        
        [handleView addGestureRecognizer:longPressRecognizer];
        
        [self customAddSubview:moreLabel toSuperView:handleView];
        
        [handleView setAlpha:0.0];

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
    
    [dismissButton addTarget:self
                      action:@selector(removeInformationPanel)
            forControlEvents:UIControlEventTouchUpInside];
    
    [dismissButton setBackgroundColor:[UIColor clearColor]];

    [self customAddSubview:dismissButton toSuperView:self.view];
    
    CGRect newFrame = CGRectMake(15.0, 20.0,
                                 200.0, 30.0);
    
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
    [mainTitleLabel setFont:[UIFont fontWithName:@"Avenir-Book"
                                            size:15.0]];
    
    NSString *collegeOneNameString = [NSString stringWithFormat:@"%@:", [schoolOne objectForKey:@"Name"]];
    
    [collegeOne setText:collegeOneNameString];
    [collegeOne setBackgroundColor:[UIColor clearColor]];
    [collegeOne setTextColor:[UIColor whiteColor]];
    [collegeOne setFont:[UIFont fontWithName:@"Avenir-Book"
                                        size:15.0]];
    [collegeOne setTextAlignment:NSTextAlignmentRight];
    [collegeOne setBackgroundColor:[UIColor clearColor]];
    
    NSString *CollegeTwoNameString = [NSString stringWithFormat:@"%@:", [schoolTwo objectForKey:@"Name"]];
    
    [collegeTwo setText:CollegeTwoNameString];
    [collegeTwo setBackgroundColor:[UIColor clearColor]];
    [collegeTwo setTextColor:[UIColor whiteColor]];
    [collegeTwo setFont:[UIFont fontWithName:@"Avenir-Book"
                                        size:15.0]];
    [collegeTwo setTextAlignment:NSTextAlignmentRight];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    UIColor *coralColor = [UIColor colorWithRed:205.0/255.0
                                          green:86.0/255.0
                                           blue:72.0/255.0
                                          alpha:1.0];
    
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    float number = [[schoolOne objectForKey:@"Height"] floatValue];
    
    NSString *CollegeValueString = [NSString stringWithFormat:@"#%.0f", number];
    
    [collegeOneTuitionValue setText:CollegeValueString];
    [collegeOneTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeOneTuitionValue setTextColor:coralColor];
    [collegeOneTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book"
                                                    size:15.0]];
    [collegeOneTuitionValue setTextAlignment:NSTextAlignmentLeft];
    [collegeOneTuitionValue setBackgroundColor:[UIColor clearColor]];
    
    number = [[schoolTwo objectForKey:@"Height"] floatValue];
    
    CollegeValueString = [NSString stringWithFormat:@"#%.0f", number];
    
    [collegeTwoTuitionValue setText:CollegeValueString];
    [collegeTwoTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeTwoTuitionValue setTextColor:coralColor];
    [collegeTwoTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book"
                                                    size:15.0]];
    [collegeTwoTuitionValue setTextAlignment:NSTextAlignmentLeft];

    
    float lineWhy = 47.0;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(14.0, lineWhy,
                                                            1.0, 1.0)];
    
    [line setBackgroundColor:[UIColor grayColor]];
    
    [self customAddSubview:line toSuperView:detailViewer];
    
    float newWidth = (float)([titleString length] * 7.5);
    
    [self customAddSubview:mainTitleLabel toSuperView:detailViewer];

    [self customAddSubview:collegeOne toSuperView:detailViewer];

    [self customAddSubview:collegeTwo toSuperView:detailViewer];

    [self customAddSubview:collegeOneTuitionValue toSuperView:detailViewer];
    
    [self customAddSubview:collegeTwoTuitionValue toSuperView:detailViewer];
    
    [UIView animateWithDuration:1.0 animations:^{
        [line setFrame:CGRectMake(14.0, lineWhy,
                                  newWidth, 1.0)];
    }];
}


-(void)configureDetailViewForPopulation
{
    UIColor *coralColor = [UIColor colorWithRed:205.0/255.0
                                          green:86.0/255.0
                                           blue:72.0/255.0
                                          alpha:1.0];
    
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width,
                                                                         self.view.bounds.size.height)];
    
    [dismissButton addTarget:self
                      action:@selector(removeInformationPanel)
            forControlEvents:UIControlEventTouchUpInside];
    
    [dismissButton setBackgroundColor:[UIColor clearColor]];
    
    [self customAddSubview:dismissButton toSuperView:self.view];
    
    CGRect newFrame = CGRectMake(15.0, 20.0,
                                 200.0, 40.0);
    
    UILabel *mainTitleLabel = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y += 35.0;
    newFrame.origin.x = 95.0;
    newFrame.size.width = 100.0;
    
    UILabel *collegeOne = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.x += 100.0;
    
    UILabel *collegeTwo = [[UILabel alloc] initWithFrame:newFrame];
    
    
    newFrame.origin.x -= 100.0;
    newFrame.origin.y += 40.0;
    
    
    newFrame.size.width = 100.0;
    
    float rowOneOrigin = newFrame.origin.x;
    UILabel *collegeTwoTuitionValue = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.x += 102.0;
    
    line1 = [[UIView alloc] initWithFrame:CGRectMake(20.0, 95.0, 1.0, 1.0)];
    [line1 setBackgroundColor:[UIColor grayColor]];
    
    line2 = [[UIView alloc] initWithFrame:CGRectMake(95.0, 73.0, 1.0, 1.0)];
    [line2 setBackgroundColor:[UIColor grayColor]];
    
    line3 = [[UIView alloc] initWithFrame:CGRectMake(65.0, 135.0, 1.0, 1.0)];
    [line3 setBackgroundColor:[UIColor grayColor]];
    
    line6 = [[UIView alloc] initWithFrame:CGRectMake(65.0, 175.0, 1.0, 1.0)];
    [line6 setBackgroundColor:[UIColor grayColor]];
    
    
    float rowTwoOrigin = newFrame.origin.x;
    line5 = [[UIView alloc] initWithFrame:CGRectMake(85.0 + 110.0, 78.0,
                                                     1.0, 1.0)];
    [line5 setBackgroundColor:[UIColor grayColor]];
    
    UILabel *collegeOneTuitionValue = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.size.width -= 5.0;
    newFrame.origin.x -= 207.0;
    
    UILabel *rowOneString = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y += 40.0;
    
    UILabel *rowTwoString = [[UILabel alloc] initWithFrame:newFrame];
    
    CGRect thirdFrame = CGRectMake(newFrame.origin.x, newFrame.origin.y + 40.0,
                                   newFrame.size.width, newFrame.size.height);
    
    UILabel *rowThreeString = [[UILabel alloc] initWithFrame:thirdFrame];
    
    newFrame.origin.x = rowOneOrigin;
    newFrame.size.width += 5.0;
    UILabel *row2Col1 = [[UILabel alloc] initWithFrame:newFrame];
    
    thirdFrame = newFrame;
    
    thirdFrame.origin.y += 40.0;
    
    UILabel *row3Col1 = [[UILabel alloc] initWithFrame:thirdFrame];
    
    thirdFrame.origin.x = rowTwoOrigin;
    
    UILabel *row3Col2 = [[UILabel alloc] initWithFrame:thirdFrame];
    
    newFrame.origin.x = rowTwoOrigin;
    UILabel *row2Col2 = [[UILabel alloc] initWithFrame:newFrame];
    
    [rowOneString setBackgroundColor:[UIColor clearColor]];
    [rowOneString setText:@"Total"];
    [rowOneString setTextColor:coralColor];
    [rowOneString setFont:[UIFont fontWithName:@"Avenir-Book"
                                          size:14.0]];
    [rowOneString setTextAlignment:NSTextAlignmentRight];
    
    [rowTwoString setBackgroundColor:[UIColor clearColor]];
    [rowTwoString setText:@"Men"];
    [rowTwoString setTextColor:coralColor];
    [rowTwoString setFont:[UIFont fontWithName:@"Avenir-Book"
                                          size:14.0]];
    [rowTwoString setTextAlignment:NSTextAlignmentRight];
    
    [rowThreeString setBackgroundColor:[UIColor clearColor]];
    [rowThreeString setText:@"Women"];
    [rowThreeString setTextColor:coralColor];
    [rowThreeString setFont:[UIFont fontWithName:@"Avenir-Book"
                                            size:14.0]];
    [rowThreeString setTextAlignment:NSTextAlignmentRight];
    
    NSString *titleString = [NSString stringWithFormat:@"Enrollment Stats:"];
    
    [mainTitleLabel setText:titleString];
    [mainTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mainTitleLabel setTextColor:[UIColor whiteColor]];
    [mainTitleLabel setFont:[UIFont fontWithName:@"Avenir-Book"
                                            size:15.0]];
    
    NSString *collegeOneNameString = [NSString stringWithFormat:@"%@", [schoolOne objectForKey:@"Name"]];
    
    [collegeOne setText:collegeOneNameString];
    [collegeOne setBackgroundColor:[UIColor clearColor]];
    [collegeOne setTextColor:[UIColor whiteColor]];
    [collegeOne setFont:[UIFont fontWithName:@"Avenir-Book"
                                        size:13.0]];
    [collegeOne setTextAlignment:NSTextAlignmentCenter];
    [collegeOne setBackgroundColor:[UIColor clearColor]];
    collegeOne.numberOfLines = 2;
    
    NSString *CollegeTwoNameString = [NSString stringWithFormat:@"%@", [schoolTwo objectForKey:@"Name"]];
    
    [collegeTwo setText:CollegeTwoNameString];
    [collegeTwo setBackgroundColor:[UIColor clearColor]];
    [collegeTwo setTextColor:[UIColor whiteColor]];
    [collegeTwo setFont:[UIFont fontWithName:@"Avenir-Book" size:13.0]];
    [collegeTwo setTextAlignment:NSTextAlignmentCenter];
    collegeTwo.numberOfLines = 2;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    
    MUITCollege *dummyCollege = [global objectForKey:@"Object Two"];
    
    
    NSString *CollegeValueString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:(int)dummyCollege.enrollment_total]];
    
    [collegeOneTuitionValue setText:CollegeValueString];
    [collegeOneTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeOneTuitionValue setTextColor:coralColor];
    [collegeOneTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book" size:14.0]];
    [collegeOneTuitionValue setTextAlignment:NSTextAlignmentCenter];
    [collegeOneTuitionValue setBackgroundColor:[UIColor clearColor]];
    
    dummyCollege = [global objectForKey:@"Object One"];
    
    CollegeValueString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:(int)dummyCollege.enrollment_total]];
    
    [collegeTwoTuitionValue setText:CollegeValueString];
    [collegeTwoTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeTwoTuitionValue setTextColor:coralColor];
    [collegeTwoTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book"
                                                    size:14.0]];
    [collegeTwoTuitionValue setTextAlignment:NSTextAlignmentCenter];
    
    dummyCollege = [global objectForKey:@"Object One"];
    
    CollegeValueString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:(int)dummyCollege.enrollment_men]];
    
    [row2Col1 setText:CollegeValueString];
    [row2Col1 setBackgroundColor:[UIColor clearColor]];
    [row2Col1 setTextColor:coralColor];
    [row2Col1 setFont:[UIFont fontWithName:@"Avenir-Book"
                                      size:14.0]];
    [row2Col1 setTextAlignment:NSTextAlignmentCenter];
    
    dummyCollege = [global objectForKey:@"Object Two"];
    
    CollegeValueString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:(int)dummyCollege.enrollment_men]];
    
    [row2Col2 setText:CollegeValueString];
    [row2Col2 setBackgroundColor:[UIColor clearColor]];
    [row2Col2 setTextColor:coralColor];
    [row2Col2 setFont:[UIFont fontWithName:@"Avenir-Book"
                                      size:14.0]];
    [row2Col2 setTextAlignment:NSTextAlignmentCenter];
    
    dummyCollege = [global objectForKey:@"Object Two"];
    CollegeValueString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:(int)dummyCollege.enrollment_women]];
    [row3Col1 setText:CollegeValueString];
    [row3Col1 setBackgroundColor:[UIColor clearColor]];
    [row3Col1 setTextColor:coralColor];
    [row3Col1 setFont:[UIFont fontWithName:@"Avenir-Book"
                                      size:14.0]];
    [row3Col1 setTextAlignment:NSTextAlignmentCenter];
    
    dummyCollege = [global objectForKey:@"Object Two"];
    
    CollegeValueString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:(int)dummyCollege.enrollment_women]];
    
    [row3Col2 setText:CollegeValueString];
    [row3Col2 setBackgroundColor:[UIColor clearColor]];
    [row3Col2 setTextColor:coralColor];
    [row3Col2 setFont:[UIFont fontWithName:@"Avenir-Book" size:14.0]];
    [row3Col2 setTextAlignment:NSTextAlignmentCenter];
    
    float lineWhy = 50.0;
    
    line4 = [[UIView alloc] initWithFrame:CGRectMake(16.0, lineWhy,
                                                     1.0, 1.0)];
    
    [line4 setBackgroundColor:[UIColor grayColor]];
    
    [self customAddSubview:line4 toSuperView:detailViewer];
    
    newWidthForMeAndYou = (float)([titleString length] * 7.5);
    
    [self customAddSubview:mainTitleLabel toSuperView:detailViewer];
    
    [self customAddSubview:collegeOne toSuperView:detailViewer];
    [self customAddSubview:collegeTwo toSuperView:detailViewer];
    
    [self customAddSubview:collegeOneTuitionValue toSuperView:detailViewer];
    [self customAddSubview:collegeTwoTuitionValue toSuperView:detailViewer];
    
    [self customAddSubview:line1 toSuperView:detailViewer];
    [self customAddSubview:line2 toSuperView:detailViewer];
    [self customAddSubview:line3 toSuperView:detailViewer];
    [self customAddSubview:line5 toSuperView:detailViewer];
    [self customAddSubview:line6 toSuperView:detailViewer];
    
    
    [self customAddSubview:rowOneString toSuperView:detailViewer];
    [self customAddSubview:rowTwoString toSuperView:detailViewer];
    [self customAddSubview:rowThreeString toSuperView:detailViewer];
    
    [self customAddSubview:row2Col1 toSuperView:detailViewer];
    [self customAddSubview:row2Col2 toSuperView:detailViewer];
    [self customAddSubview:row3Col1 toSuperView:detailViewer];
    [self customAddSubview:row3Col2 toSuperView:detailViewer];

}
-(void)configureDetailViewForAid
{
    UIColor *coralColor = [UIColor colorWithRed:205.0/255.0
                                          green:86.0/255.0
                                           blue:72.0/255.0
                                          alpha:1.0];
    
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width,
                                                                         self.view.bounds.size.height)];
    
    [dismissButton addTarget:self
                      action:@selector(removeInformationPanel)
            forControlEvents:UIControlEventTouchUpInside];
    
    [dismissButton setBackgroundColor:[UIColor clearColor]];

    [self customAddSubview:dismissButton toSuperView:self.view];
    
    CGRect newFrame = CGRectMake(15.0, 20.0,
                                 200.0, 40.0);
    
    UILabel *mainTitleLabel = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y += 35.0;
    newFrame.origin.x = 95.0;
    newFrame.size.width = 100.0;
    
    UILabel *collegeOne = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.x += 100.0;
    
    UILabel *collegeTwo = [[UILabel alloc] initWithFrame:newFrame];
    
    
    newFrame.origin.x -= 100.0;
    newFrame.origin.y += 40.0;

    newFrame.size.width = 100.0;
    
    float rowOneOrigin = newFrame.origin.x;
    UILabel *collegeTwoTuitionValue = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.x += 102.0;
    
    line1 = [[UIView alloc] initWithFrame:CGRectMake(20.0, 95.0,
                                                     1.0, 1.0)];
    [line1 setBackgroundColor:[UIColor grayColor]];
    
    line2 = [[UIView alloc] initWithFrame:CGRectMake(95.0, 73.0,
                                                     1.0, 1.0)];
    [line2 setBackgroundColor:[UIColor grayColor]];
    
    line3 = [[UIView alloc] initWithFrame:CGRectMake(65.0, 135.0,
                                                     1.0, 1.0)];
    [line3 setBackgroundColor:[UIColor grayColor]];
    
    line6 = [[UIView alloc] initWithFrame:CGRectMake(65.0, 175.0,
                                                     1.0, 1.0)];
    [line6 setBackgroundColor:[UIColor grayColor]];
    
    float rowTwoOrigin = newFrame.origin.x;
    
    line5 = [[UIView alloc] initWithFrame:CGRectMake(85.0 + 110.0, 78.0,
                                                     1.0, 1.0)];
    [line5 setBackgroundColor:[UIColor grayColor]];
    
    UILabel *collegeOneTuitionValue = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.size.width -= 5.0;
    newFrame.origin.x -= 207.0;
    
    UILabel *rowOneString = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y += 40.0;
    
    UILabel *rowTwoString = [[UILabel alloc] initWithFrame:newFrame];
    
    CGRect thirdFrame = CGRectMake(newFrame.origin.x, newFrame.origin.y + 40.0,
                                   newFrame.size.width, newFrame.size.height);
    
    UILabel *rowThreeString = [[UILabel alloc] initWithFrame:thirdFrame];
    
    newFrame.origin.x = rowOneOrigin;
    newFrame.size.width += 5.0;
    UILabel *row2Col1 = [[UILabel alloc] initWithFrame:newFrame];
    
    thirdFrame = newFrame;
    
    thirdFrame.origin.y += 40.0;
    
    UILabel *row3Col1 = [[UILabel alloc] initWithFrame:thirdFrame];
    
    thirdFrame.origin.x = rowTwoOrigin;
    
    UILabel *row3Col2 = [[UILabel alloc] initWithFrame:thirdFrame];
    
    newFrame.origin.x = rowTwoOrigin;
    UILabel *row2Col2 = [[UILabel alloc] initWithFrame:newFrame];
    
    [rowOneString setBackgroundColor:[UIColor clearColor]];
    [rowOneString setText:@"Percent\nReceive"];
    [rowOneString setTextColor:coralColor];
    [rowOneString setFont:[UIFont fontWithName:@"Avenir-Book"
                                          size:12.0]];
    [rowOneString setTextAlignment:NSTextAlignmentRight];
    rowOneString.numberOfLines = 2;
    
    NSString *titleString = [NSString stringWithFormat:@"Financial Aid Stats:"];
    
    [mainTitleLabel setText:titleString];
    [mainTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mainTitleLabel setTextColor:[UIColor whiteColor]];
    [mainTitleLabel setFont:[UIFont fontWithName:@"Avenir-Book"
                                            size:15.0]];
    
    NSString *collegeOneNameString = [NSString stringWithFormat:@"%@", [schoolOne objectForKey:@"Name"]];
    
    [collegeOne setText:collegeOneNameString];
    [collegeOne setBackgroundColor:[UIColor clearColor]];
    [collegeOne setTextColor:[UIColor whiteColor]];
    [collegeOne setFont:[UIFont fontWithName:@"Avenir-Book"
                                        size:13.0]];
    [collegeOne setTextAlignment:NSTextAlignmentCenter];
    [collegeOne setBackgroundColor:[UIColor clearColor]];
    collegeOne.numberOfLines = 2;
    
    NSString *CollegeTwoNameString = [NSString stringWithFormat:@"%@", [schoolTwo objectForKey:@"Name"]];
    
    [collegeTwo setText:CollegeTwoNameString];
    [collegeTwo setBackgroundColor:[UIColor clearColor]];
    [collegeTwo setTextColor:[UIColor whiteColor]];
    [collegeTwo setFont:[UIFont fontWithName:@"Avenir-Book"
                                        size:13.0]];
    [collegeTwo setTextAlignment:NSTextAlignmentCenter];
    collegeTwo.numberOfLines = 2;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    
    MUITCollege *dummyCollege = [global objectForKey:@"Object Two"];
    
    NSString *CollegeValueString = [NSString stringWithFormat:@"%i%%", (int)dummyCollege.percent_receive_financial_aid];
    
    [collegeOneTuitionValue setText:CollegeValueString];
    [collegeOneTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeOneTuitionValue setTextColor:coralColor];
    [collegeOneTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book"
                                                    size:14.0]];
    [collegeOneTuitionValue setTextAlignment:NSTextAlignmentCenter];
    [collegeOneTuitionValue setBackgroundColor:[UIColor clearColor]];
    
    dummyCollege = [global objectForKey:@"Object One"];
    CollegeValueString = [NSString stringWithFormat:@"%li%%", (long)dummyCollege.percent_receive_financial_aid];
    
    [collegeTwoTuitionValue setText:CollegeValueString];
    [collegeTwoTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeTwoTuitionValue setTextColor:coralColor];
    [collegeTwoTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book"
                                                    size:14.0]];
    [collegeTwoTuitionValue setTextAlignment:NSTextAlignmentCenter];
    
    float lineWhy = 50.0;
    
    line4 = [[UIView alloc] initWithFrame:CGRectMake(16.0, lineWhy,
                                                     1.0, 1.0)];
    
    [line4 setBackgroundColor:[UIColor grayColor]];
    
    [self customAddSubview:line4 toSuperView:detailViewer];
    
    newWidthForMeAndYou = (float)([titleString length] * 7.5);
    
    [self customAddSubview:mainTitleLabel toSuperView:detailViewer];
    
    [self customAddSubview:collegeOne toSuperView:detailViewer];
    [self customAddSubview:collegeTwo toSuperView:detailViewer];
    
    [self customAddSubview:collegeOneTuitionValue toSuperView:detailViewer];
    [self customAddSubview:collegeTwoTuitionValue toSuperView:detailViewer];
    
    [self customAddSubview:line1 toSuperView:detailViewer];
    [self customAddSubview:line2 toSuperView:detailViewer];
    [self customAddSubview:line3 toSuperView:detailViewer];
    [self customAddSubview:line5 toSuperView:detailViewer];
    
    [self customAddSubview:rowOneString toSuperView:detailViewer];
    [self customAddSubview:rowTwoString toSuperView:detailViewer];
    [self customAddSubview:rowThreeString toSuperView:detailViewer];
    
    [self customAddSubview:row2Col1 toSuperView:detailViewer];
    [self customAddSubview:row2Col2 toSuperView:detailViewer];
    [self customAddSubview:row3Col1 toSuperView:detailViewer];
    [self customAddSubview:row3Col2 toSuperView:detailViewer];
}
-(void)configureDetailViewForTuitionNewBecauseIDontCare
{
    UIColor *coralColor = [UIColor colorWithRed:205.0/255.0
                                          green:86.0/255.0
                                           blue:72.0/255.0
                                          alpha:1.0];
    
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width,
                                                                         self.view.bounds.size.height)];
    
    [dismissButton addTarget:self action:@selector(removeInformationPanel) forControlEvents:UIControlEventTouchUpInside];
    [dismissButton setBackgroundColor:[UIColor clearColor]];
    [self customAddSubview:dismissButton toSuperView:self.view];
    
    CGRect newFrame = CGRectMake(15.0, 20.0,
                                 200.0, 40.0);
    
    UILabel *mainTitleLabel = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y += 35.0;
    newFrame.origin.x = 95.0;
    newFrame.size.width = 100.0;
    
    UILabel *collegeOne = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.x += 100.0;
    
    UILabel *collegeTwo = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.x -= 100.0;
    newFrame.origin.y += 40.0;

    newFrame.size.width = 100.0;
    
    float rowOneOrigin = newFrame.origin.x;
    UILabel *collegeTwoTuitionValue = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.x += 102.0;
    
    line1 = [[UIView alloc] initWithFrame:CGRectMake(20.0, 95.0,
                                                     1.0, 1.0)];
    [line1 setBackgroundColor:[UIColor grayColor]];
    
    line2 = [[UIView alloc] initWithFrame:CGRectMake(95.0, 73.0,
                                                     1.0, 1.0)];
    [line2 setBackgroundColor:[UIColor grayColor]];
    
    line3 = [[UIView alloc] initWithFrame:CGRectMake(65.0, 135.0,
                                                     1.0, 1.0)];
    [line3 setBackgroundColor:[UIColor grayColor]];
    
    float rowTwoOrigin = newFrame.origin.x;
    
    line5 = [[UIView alloc] initWithFrame:CGRectMake(85.0 + 110.0, 78.0,
                                                     1.0, 1.0)];
    [line5 setBackgroundColor:[UIColor grayColor]];
    
    UILabel *collegeOneTuitionValue = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.size.width -= 5.0;
    newFrame.origin.x -= 207.0;
    
    UILabel *rowOneString = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.y += 40.0;
    
    UILabel *rowTwoString = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.x = rowOneOrigin;
    newFrame.size.width += 5.0;
    UILabel *row2Col1 = [[UILabel alloc] initWithFrame:newFrame];
    
    newFrame.origin.x = rowTwoOrigin;
    UILabel *row2Col2 = [[UILabel alloc] initWithFrame:newFrame];
    
    [rowOneString setBackgroundColor:[UIColor clearColor]];
    [rowOneString setText:@"In State"];
    [rowOneString setTextColor:coralColor];
    [rowOneString setFont:[UIFont fontWithName:@"Avenir-Book"
                                          size:14.0]];
    [rowOneString setTextAlignment:NSTextAlignmentRight];
    
    [rowTwoString setBackgroundColor:[UIColor clearColor]];
    [rowTwoString setText:@"Out of State"];
    [rowTwoString setTextColor:coralColor];
    [rowTwoString setFont:[UIFont fontWithName:@"Avenir-Book"
                                          size:14.0]];
    [rowTwoString setTextAlignment:NSTextAlignmentRight];

    NSString *titleFromDictionary = [global objectForKey:@"Title"];
    NSString *titleString = [NSString stringWithFormat:@"%@ Stats:", titleFromDictionary];
    
    [mainTitleLabel setText:titleString];
    [mainTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mainTitleLabel setTextColor:[UIColor whiteColor]];
    [mainTitleLabel setFont:[UIFont fontWithName:@"Avenir-Book"
                                            size:15.0]];
    
    NSString *collegeOneNameString = [NSString stringWithFormat:@"%@", [schoolOne objectForKey:@"Name"]];
    
    [collegeOne setText:collegeOneNameString];
    [collegeOne setBackgroundColor:[UIColor clearColor]];
    [collegeOne setTextColor:[UIColor whiteColor]];
    [collegeOne setFont:[UIFont fontWithName:@"Avenir-Book"
                                        size:13.0]];
    [collegeOne setTextAlignment:NSTextAlignmentCenter];
    [collegeOne setBackgroundColor:[UIColor clearColor]];
    collegeOne.numberOfLines = 2;
    
    NSString *CollegeTwoNameString = [NSString stringWithFormat:@"%@", [schoolTwo objectForKey:@"Name"]];
    
    [collegeTwo setText:CollegeTwoNameString];
    [collegeTwo setBackgroundColor:[UIColor clearColor]];
    [collegeTwo setTextColor:[UIColor whiteColor]];
    [collegeTwo setFont:[UIFont fontWithName:@"Avenir-Book"
                                        size:13.0]];
    [collegeTwo setTextAlignment:NSTextAlignmentCenter];
    collegeTwo.numberOfLines = 2;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    
    MUITCollege *dummyCollege = [global objectForKey:@"Object Two"];
    
    NSString *CollegeValueString = [NSString stringWithFormat:@"%@",
                                    [numberFormatter stringFromNumber:[NSNumber numberWithInt:(int)dummyCollege.tuition_in_state]]];
    
    [collegeOneTuitionValue setText:CollegeValueString];
    [collegeOneTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeOneTuitionValue setTextColor:coralColor];
    [collegeOneTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book"
                                                    size:14.0]];
    [collegeOneTuitionValue setTextAlignment:NSTextAlignmentCenter];
    [collegeOneTuitionValue setBackgroundColor:[UIColor clearColor]];
    
    
    dummyCollege = [global objectForKey:@"Object One"];
    
    CollegeValueString = [NSString stringWithFormat:@"%@",
                          [numberFormatter stringFromNumber:[NSNumber numberWithInt:(int)dummyCollege.tuition_in_state]]];
    
    [collegeTwoTuitionValue setText:CollegeValueString];
    [collegeTwoTuitionValue setBackgroundColor:[UIColor clearColor]];
    [collegeTwoTuitionValue setTextColor:coralColor];
    [collegeTwoTuitionValue setFont:[UIFont fontWithName:@"Avenir-Book"
                                                    size:14.0]];
    [collegeTwoTuitionValue setTextAlignment:NSTextAlignmentCenter];
    
    
    dummyCollege = [global objectForKey:@"Object One"];

    CollegeValueString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:(int)dummyCollege.tuition_out_state]];
    
    [row2Col1 setText:CollegeValueString];
    [row2Col1 setBackgroundColor:[UIColor clearColor]];
    [row2Col1 setTextColor:coralColor];
    [row2Col1 setFont:[UIFont fontWithName:@"Avenir-Book"
                                      size:14.0]];
    [row2Col1 setTextAlignment:NSTextAlignmentCenter];
    
    
    dummyCollege = [global objectForKey:@"Object Two"];

    CollegeValueString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:(int)dummyCollege.tuition_out_state]];
    
    [row2Col2 setText:CollegeValueString];
    [row2Col2 setBackgroundColor:[UIColor clearColor]];
    [row2Col2 setTextColor:coralColor];
    [row2Col2 setFont:[UIFont fontWithName:@"Avenir-Book" size:14.0]];
    [row2Col2 setTextAlignment:NSTextAlignmentCenter];
    
    float lineWhy = 50.0;
    
    line4 = [[UIView alloc] initWithFrame:CGRectMake(16.0, lineWhy,
                                                     1.0, 1.0)];
    
    [line4 setBackgroundColor:[UIColor grayColor]];
    
    [self customAddSubview:line4 toSuperView:detailViewer];
    
    newWidthForMeAndYou = (float)([titleString length] * 7.5);
    
    [self customAddSubview:mainTitleLabel toSuperView:detailViewer];
    
    [self customAddSubview:collegeOne toSuperView:detailViewer];
    [self customAddSubview:collegeTwo toSuperView:detailViewer];
    
    [self customAddSubview:collegeOneTuitionValue toSuperView:detailViewer];
    [self customAddSubview:collegeTwoTuitionValue toSuperView:detailViewer];

    [self customAddSubview:line1 toSuperView:detailViewer];
    [self customAddSubview:line2 toSuperView:detailViewer];
    [self customAddSubview:line3 toSuperView:detailViewer];
    [self customAddSubview:line5 toSuperView:detailViewer];
    
    [self customAddSubview:rowOneString toSuperView:detailViewer];
    [self customAddSubview:rowTwoString toSuperView:detailViewer];
    
    [self customAddSubview:row2Col1 toSuperView:detailViewer];
    [self customAddSubview:row2Col2 toSuperView:detailViewer];
    
}
#pragma mark Creating Buttons Near Title Text -
-(void)buttonsForMenAndWomen
{
    
    if (allButton)
    {
        
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
    
    
    
    if (!allButton)
    {
        
        CGRect buttonFrame = CGRectMake(0.0, 10.0,
                                        75.0, 20.0);
        
        underlinerView = [[UIView alloc] initWithFrame:[[arrayOfUnderliners objectAtIndex:2] CGRectValue]];
        
        underlinerView.backgroundColor = barTwoColor;
        
        underlinerView.layer.cornerRadius = 5.0;
        
        [underLinerViewArray addObject:underlinerView];
        
        womenButton = [[UIButton alloc] initWithFrame:buttonFrame];
        
        [womenButton setTag:1];
        [womenButton addTarget:self
                        action:@selector(changePopulationViewWithButton:)
              forControlEvents:UIControlEventTouchDown];
        
        [womenButton setTitle:@"By Women"
                     forState:UIControlStateNormal];
        womenButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Book"
                                                      size:12.0];
        womenButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [womenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [womenButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        womenButton.backgroundColor = [UIColor clearColor];
        womenButton.layer.cornerRadius = 4.0;
        
        
        buttonFrame.origin.x = self.view.bounds.size.width - 75.0;
        
        
        menButton = [[UIButton alloc] initWithFrame:buttonFrame];
        
        [menButton addTarget:self
                      action:@selector(changePopulationViewWithButton:)
            forControlEvents:UIControlEventTouchUpInside];
        menButton.tag = 2;
        
        [menButton setTitle:@"By Men" forState:UIControlStateNormal];
        menButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Book"
                                                    size:12.0];
        menButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [menButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        menButton.backgroundColor = [UIColor clearColor];
        menButton.layer.cornerRadius = 4.0;
        
        
        CGPoint screenCenter = self.view.center;
        float width = self.view.bounds.size.width - (75 * 2);
        
        buttonFrame = CGRectMake((screenCenter.x - (width/2)), 1.0, width, 40.0);
        
        allButton = [[UIButton alloc] initWithFrame:buttonFrame];
        allButton.tag = 3;
        [allButton addTarget:self
                      action:@selector(changePopulationViewWithButton:)
            forControlEvents:UIControlEventTouchUpInside];
        
        [allButton setTitle:@"Enrollment Total"
                   forState:UIControlStateNormal];
        [allButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [allButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book"
                                                      size:20.0f]];
        [allButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [allButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        allButton.layer.cornerRadius = 4.0;
        
        
        [self customAddSubview:allButton toSuperView:self.view];
        [self customAddSubview:womenButton toSuperView:self.view];
        [self customAddSubview:menButton toSuperView:self.view];
        [self customAddSubview:underlinerView toSuperView:self.view];
        
    }
    
}
-(void)changePopulationViewWithButton:(UIButton*) sender
{
    NSNumber *schoolOneValue, *schoolTwoValue, *malePopulation, *malePopulationTwo;
    
    schoolOneValue = [NSNumber new];
    schoolTwoValue = [NSNumber new];
    MUITCollege *collegeOne, *collegeTwo;
    
    UIButton *testButton = (UIButton*)sender;
    
    switch (testButton.tag)
    {
        case 1:
            
            collegeOne = [global objectForKey:@"Object One"];
            malePopulation = [NSNumber numberWithInteger:collegeOne.enrollment_women];
            
            collegeTwo = [global objectForKey:@"Object Two"];
            malePopulationTwo = [NSNumber numberWithInteger:collegeTwo.enrollment_women];
            
            [schoolOne setValue:malePopulation forKey:@"Height"];
            [schoolTwo setValue:malePopulationTwo forKey:@"Height"];
            
            [self resizeBarsWithOptionSwitching:NO];
            
            allButton.backgroundColor = [UIColor clearColor];
            menButton.backgroundColor = [UIColor clearColor];
            
            [self shiftWithFrameValue:[arrayOfUnderliners objectAtIndex:0]];
            
            
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
            
            [self shiftWithFrameValue:[arrayOfUnderliners objectAtIndex:1]];
            
            
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
            menButton.backgroundColor = [UIColor clearColor];
            [self shiftWithFrameValue:[arrayOfUnderliners objectAtIndex:2]];
            
            
            break;
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
            
            [barOneView setFrame:CGRectMake(barOneFrame.origin.x, BOTTOMREFERENCEPOINT,
                                            barOneFrame.size.width, barOneHeightValue)];
            [barTwoView setFrame:CGRectMake(barTwoFrame.origin.x, BOTTOMREFERENCEPOINT,
                                            barTwoFrame.size.width, barTwoHeightValue)];
            
            [barOneLabel setFrame:CGRectMake(barOneLabel.center.x - (barOneLabel.bounds.size.width/2),
                                             self.view.bounds.size.height + barOneHeightValue - 28.0,
                                             barOneLabel.bounds.size.width,
                                             barOneLabel.bounds.size.height)];
            
            [barTwoLabel setFrame:CGRectMake(barTwoLabel.center.x - (barTwoLabel.bounds.size.width/2),
                                             self.view.bounds.size.height + barTwoHeightValue - 28.0,
                                             barTwoLabel.bounds.size.width,
                                             barTwoLabel.bounds.size.height)];
        }];
    }
    else if (switching == YES)
    {
        
        [barOneView setFrame:CGRectMake(barOneFrame.origin.x, BOTTOMREFERENCEPOINT, barOneFrame.size.width, barOneHeightValue)];
        [barTwoView setFrame:CGRectMake(barTwoFrame.origin.x, BOTTOMREFERENCEPOINT, barTwoFrame.size.width, barTwoHeightValue)];
        
        [barOneLabel setFrame:CGRectMake(barOneLabel.center.x - (barOneLabel.bounds.size.width/2),
                                         self.view.bounds.size.height + barOneHeightValue - 28.0,
                                         barOneLabel.bounds.size.width,
                                         barOneLabel.bounds.size.height)];
        
        [barTwoLabel setFrame:CGRectMake(barTwoLabel.center.x - (barTwoLabel.bounds.size.width/2),
                                         self.view.bounds.size.height + barTwoHeightValue - 28.0,
                                         barTwoLabel.bounds.size.width,
                                         barTwoLabel.bounds.size.height)];
    }
    
}
-(void)buttonsForInStateAndOutWithOptionFirst:(BOOL)first
{
    if (inState)
    {
        MUITCollege *collegeOne, *collegeTwo;
        NSNumber *inStateTutionOne, *inStateTutionTwo;
        
        collegeOne = [global objectForKey:@"Object One"];
        inStateTutionOne = [NSNumber numberWithInteger:collegeOne.tuition_out_state];
        
        collegeTwo = [global objectForKey:@"Object Two"];
        inStateTutionTwo = [NSNumber numberWithInteger:collegeTwo.tuition_out_state];
        
        [schoolOne setValue:inStateTutionOne forKey:@"Height"];
        [schoolTwo setValue:inStateTutionTwo forKey:@"Height"];
        
        [self resizeBarsWithOptionSwitching:YES];
        
        inState.backgroundColor = [UIColor clearColor];
        outState.backgroundColor = [UIColor colorWithRed:113.0/255.0
                                                   green:173.0/255.0
                                                    blue:237.0/255.0
                                                   alpha:0.75];
        
        [allButton removeFromSuperview];
        allButton = nil;
        
        [inState removeFromSuperview];
        inState = nil;
        
        [outState removeFromSuperview];
        outState = nil;
        
    }
    
    if (!inState)
    {
        CGRect buttonFrame = CGRectMake(0.0, 10.0,
                                        75.0, 20.0);
        
        underlinerView = [[UIView alloc] initWithFrame:[[arrayOfUnderLinersForTuition objectAtIndex:1] CGRectValue]];
        
        underlinerView.backgroundColor = barTwoColor;
        
        underlinerView.layer.cornerRadius = 5.0;
        
        [underLinerViewArray addObject:underlinerView];
        
        inState = [[UIButton alloc] initWithFrame:buttonFrame];
        [inState setTag:1];
        [inState addTarget:self
                    action:@selector(changeTuitionWithButton:)
          forControlEvents:UIControlEventTouchUpInside];
        
        [inState setTitle:@"In State"
                 forState:UIControlStateNormal];
        inState.titleLabel.font = [UIFont fontWithName:@"Avenir-Book"
                                                  size:13.0];
        [inState setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [inState setTitleColor:[UIColor whiteColor] forState:UIControlStateReserved];
        [inState.titleLabel setTextAlignment:NSTextAlignmentRight];
        
        inState.backgroundColor = [UIColor clearColor];
        inState.layer.cornerRadius = 4.0;
        buttonFrame.origin.x = self.view.bounds.size.width - 75.0;
        
        outState = [[UIButton alloc] initWithFrame:buttonFrame];
        outState.tag = 2;
        [outState addTarget:self
                     action:@selector(changeTuitionWithButton:)
           forControlEvents:UIControlEventTouchUpInside];
        
        [outState setTitle:@"Out of State" forState:UIControlStateNormal];
        outState.titleLabel.font = [UIFont fontWithName:@"Avenir-Book"
                                                   size:13.0];
        outState.titleLabel.textAlignment = NSTextAlignmentLeft;
        [outState setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [outState setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        outState.backgroundColor = [UIColor clearColor];
        outState.layer.cornerRadius = 4.0;
        
        if (first)
        {
            [inState setBackgroundColor:[UIColor clearColor]];
            [self shiftWithFrameValue:[arrayOfUnderLinersForTuition objectAtIndex:1]];
        }
        
        [self customAddSubview:inState toSuperView:self.view];
        [self customAddSubview:outState toSuperView:self.view];
        [self customAddSubview:underlinerView toSuperView:self.view];
    }
    
    
}
-(void)changeTuitionWithButton:(UIButton*) sender
{
    NSNumber *schoolOneValue, *schoolTwoValue, *malePopulation, *malePopulationTwo;
    
    schoolOneValue = [NSNumber new];
    schoolTwoValue = [NSNumber new];
    MUITCollege *collegeOne, *collegeTwo;
    
    UIButton *testButton = (UIButton*)sender;
    
    switch (testButton.tag)
    {
        case 1:
            
            collegeOne = [global objectForKey:@"Object One"];
            malePopulation = [NSNumber numberWithInteger:collegeOne.tuition_in_state];
            
            collegeTwo = [global objectForKey:@"Object Two"];
            malePopulationTwo = [NSNumber numberWithInteger:collegeTwo.tuition_in_state];
            
            
            [schoolOne setValue:malePopulation forKey:@"Height"];
            [schoolTwo setValue:malePopulationTwo forKey:@"Height"];
            
            [self resizeBarsWithOptionSwitching:NO];
            
            outState.backgroundColor = [UIColor clearColor];
            [self shiftWithFrameValue:[arrayOfUnderLinersForTuition objectAtIndex:0]];
            
            
            break;
        case 2:
            
            collegeOne = [global objectForKey:@"Object One"];
            malePopulation = [NSNumber numberWithInteger:collegeOne.tuition_out_state];
            
            collegeTwo = [global objectForKey:@"Object Two"];
            malePopulationTwo = [NSNumber numberWithInteger:collegeTwo.tuition_out_state];
            
            [schoolOne setValue:malePopulation forKey:@"Height"];
            [schoolTwo setValue:malePopulationTwo forKey:@"Height"];
            
            [self resizeBarsWithOptionSwitching:NO];
            
            inState.backgroundColor = [UIColor clearColor];
            
            [self shiftWithFrameValue:[arrayOfUnderLinersForTuition objectAtIndex:1]];
            
            
            break;
    }
}

-(void)addAgain:(BOOL) first
{
    CGRect buttonFrame = CGRectMake(0.0, 10.0,
                                    75.0, 20.0);
    
    inState = [[UIButton alloc] initWithFrame:buttonFrame];
    [inState setTag:1];
    [inState addTarget:self
                action:@selector(changeTuitionWithButton:)
      forControlEvents:UIControlEventTouchDown];
    [inState setTitle:@"In State"
             forState:UIControlStateNormal];
    inState.titleLabel.font = [UIFont fontWithName:@"Avenir-Book"
                                              size:14.0];
    
    [inState setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [inState setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [inState.titleLabel setTextAlignment:NSTextAlignmentRight];
    
    inState.backgroundColor = [UIColor clearColor];
    inState.layer.cornerRadius = 4.0;
    buttonFrame.origin.x = self.view.bounds.size.width - 75.0;
    
    outState = [[UIButton alloc] initWithFrame:buttonFrame];
    outState.tag = 2;
    [outState addTarget:self
                 action:@selector(changeTuitionWithButton:)
       forControlEvents:UIControlEventTouchUpInside];
    
    [outState setTitle:@"Out of State"
              forState:UIControlStateNormal];
    outState.titleLabel.font = [UIFont fontWithName:@"Avenir-Book"
                                               size:12.0];
    outState.titleLabel.textAlignment = NSTextAlignmentLeft;
    [outState setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [outState setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    outState.backgroundColor = [UIColor clearColor];
    outState.layer.cornerRadius = 4.0;
    
    if (first)
    {
        [inState setBackgroundColor:[UIColor clearColor]];
        [outState setBackgroundColor:[UIColor colorWithRed:113.0/255.0
                                                     green:173.0/255.0
                                                      blue:237.0/255.0
                                                     alpha:0.75]];
    }
    
    
    [self customAddSubview:inState toSuperView:self.view];
    [self customAddSubview:outState toSuperView:self.view];
    
    [self.view bringSubviewToFront:inState];
    [self.view bringSubviewToFront:outState];
}

-(void)andTheyreOff
{
    
    float theBoat;
    
    if ([[global objectForKey:@"Title"] isEqualToString:@"Financial Aid"])
    {
        theBoat = 50.0;
    }
    else
    {
        theBoat = 0.0;
    }
    
    
    [UIView animateWithDuration:1.0 animations:^{
        [line1 setFrame:CGRectMake(20.0, 95.0,
                                   275.0, 1.0)];
        [line1 setAlpha:0.5];
        [line2 setAlpha:0.5];
        [line2 setFrame:CGRectMake(95.0, 73.0,
                                   1.0, 140.0 - theBoat)];
        [line3 setAlpha:0.2];
        [line3 setFrame:CGRectMake(65, 135.0,
                                   230.0, 1.0)];
        [line4 setFrame:CGRectMake(16.0, 50.0,
                                   newWidthForMeAndYou, 1.0)];
        [line4 setAlpha:0.8];
        [line5 setFrame:CGRectMake(85.0 + 110.0, 82.0,
                                   1.0, 131.0 - theBoat)];
        [line5 setAlpha:0.2];
        [line6 setFrame:CGRectMake(65.0, 175.0,
                                   230.0, 1.0)];
        [line6 setAlpha:0.2];
    }];
    
}

-(void)setArrayOfUnderliners
{
    NSMutableArray *mutableUnderliners = [NSMutableArray new];
    
    float width = self.view.bounds.size.width - (75 * 2);
    float widthOne = 76.0;
    CGRect leftFrame = CGRectMake(womenButton.center.x, 29.0,
                                  widthOne, 3.0);
    [mutableUnderliners addObject:[NSValue valueWithCGRect:leftFrame]];
    
    widthOne = 60.0;
    CGRect rightFrame = CGRectMake(self.view.bounds.size.width - widthOne - 7.0, 29.0,
                                   widthOne, 3.0);
    [mutableUnderliners addObject:[NSValue valueWithCGRect:rightFrame]];
    
    CGRect middleFrame = CGRectMake((self.view.center.x - (width/2)), 32.0,
                                    width, 3.0);
    [mutableUnderliners addObject:[NSValue valueWithCGRect:middleFrame]];
    
    if (!arrayOfUnderliners)
    {
        arrayOfUnderliners = [NSArray arrayWithArray:mutableUnderliners];
    }
    
    [mutableUnderliners removeAllObjects];
    
    width = self.view.bounds.size.width - (75 * 2);
    widthOne = 43.0;
    leftFrame = CGRectMake(womenButton.center.x + 16.0, 29.0,
                           widthOne, 3.0);
    [mutableUnderliners addObject:[NSValue valueWithCGRect:leftFrame]];
    
    widthOne = 60.0;
    rightFrame = CGRectMake(self.view.bounds.size.width - widthOne - 7.0, 29.0,
                            widthOne, 3.0);
    [mutableUnderliners addObject:[NSValue valueWithCGRect:rightFrame]];
    
    if (!arrayOfUnderLinersForTuition)
    {
        arrayOfUnderLinersForTuition = [NSArray arrayWithArray:mutableUnderliners];
    }
}

-(void)shiftWithFrameValue:(NSValue*) frameValue
{
    CGRect frame = [frameValue CGRectValue];
    
    [UIView animateWithDuration:0.3 animations:^{
        [underlinerView setFrame:frame];
    }];
}
-(void)removeUnderliners
{
    for (UIView* theView in underLinerViewArray)
    {
        [theView removeFromSuperview];
        
    }
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
    
    UIColor *coralColor = [UIColor colorWithRed:0.0/255.0
                                          green:0.0/255.0
                                           blue:0.0/255.0
                                          alpha:.050];
    
    pageControl.currentPageIndicatorTintColor = barTwoColor;
    pageControl.backgroundColor = coralColor;

    [pageControl setFrame:CGRectMake(0.0, 0.0,
                                     320.0, 20.0)];
}




-(void)customAddSubview:(UIView*) ourSubview toSuperView:(UIView*) ourSuperView
{
    
    [subviewArray addObject:ourSubview];
    
    [ourSuperView addSubview:ourSubview];
 
}

-(void)customRemoveAllSubviews
{
    
    for (int i = 0; i < [subviewArray count]; i++)
    {
        UIView *theView = subviewArray[i];
        
        [theView removeFromSuperview];
        theView = nil;
        [subviewArray removeObject:theView];
    }
    
}



@end

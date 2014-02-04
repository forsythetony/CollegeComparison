//
//  CCAnimationPageViewController.m
//  CollegeComparison
//
//  Created by Anthony Forsythe on 11/18/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CCAnimationPageViewController.h"
#import "CCAnimationsScreenViewController.h"

#define NUMBEROFVIEWCONTROLLERS 3

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@interface CCAnimationPageViewController () {
    
    NSMutableArray *sectionTitles,
                    *schoolOneValues,
                    *schoolTwoValues,
                    *labelModifier,
                    *lineLabelArray,
                    *linesArray,
                    *moneyValueArray,
                    *heightMultiplierArray,
                    *chapterTexts,
                    *viewControllersForMe;
    
    NSString *schoolOneTitle,
                *schoolTwoTitle;
    
    NSMutableDictionary *modifierDictionary;
    
    UINavigationItem *myNavigationItem;
    
    BOOL Mycompleted;
}

@end

@implementation CCAnimationPageViewController

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
    [super viewDidLoad];
    //Initial Configuration of View
    [self configureNavigationBar];
    
    //Data packaging and setting methods
    [self dataPackager];
    [self setAllArrays];
    
    [self createViewControllers];
    
    //Initialization and configuration of page view
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    
    CCAnimationsScreenViewController *initialVC = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialVC];
    
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    
    [self.pageViewController.view setFrame:[self.view bounds]];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    UIColor *coralColorMuted = [UIColor colorWithRed:205.0/255.0
                                               green:86.0/255.0
                                                blue:72.0/255.0
                                               alpha:0.5];
    
    UIColor *blueishColor = [UIColor colorWithRed:113.0/255.0
                                         green:173.0/255.0
                                          blue:237.0/255.0
                                         alpha:1.0];

    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = coralColorMuted;
    pageControl.currentPageIndicatorTintColor = blueishColor;
    
    

}

#pragma mark Data Source Methods -

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfViewController:(CCAnimationsScreenViewController*)viewController];
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(CCAnimationsScreenViewController*)viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    return [self viewControllerAtIndex:index];
    
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return NUMBEROFVIEWCONTROLLERS;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
     return 0;
}

#pragma mark Delegate Methods -

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    
   
}
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}

#pragma mark Data Setup Methods -

-(void)setAllArrays
{
    sectionTitles  = [[NSMutableArray alloc] init];
    schoolOneValues = [[NSMutableArray alloc] init];
    labelModifier = [[NSMutableArray alloc] init];
    schoolTwoValues = [[NSMutableArray alloc] init];
    lineLabelArray = [[NSMutableArray alloc] init];
    moneyValueArray = [[NSMutableArray alloc] init];
    linesArray = [[NSMutableArray alloc] init];
    heightMultiplierArray = [[NSMutableArray alloc] init];
    
    int schoolOneValue;
    int schoolTwoValue;
    float schoolOneFloatValue;
    float schoolTwoFloatValue;
    float unitValue;
    float moneyValue;
    float heightMultiplier;
    int lines;
    float modifier;
    
    MUITCollege *dummyCollege;
    
    
    for (int i = 0; i < NUMBEROFVIEWCONTROLLERS; i++)
    {
        switch (i)
        {
            case 0:
                
                [sectionTitles addObject:@"Tuition"];
            
                dummyCollege = self.twoColleges[0];
                schoolOneFloatValue = (float)dummyCollege.tuition_out_state;
                
                dummyCollege = self.twoColleges[1];
                schoolTwoFloatValue = (float)dummyCollege.tuition_out_state;
                
                break;
            case 1:
                
                [sectionTitles addObject:@"Enrollment Total"];
                
                dummyCollege = self.twoColleges[0];
                schoolOneFloatValue = (float)dummyCollege.enrollment_total;
                
                dummyCollege = self.twoColleges[1];
                schoolTwoFloatValue = (float)dummyCollege.enrollment_total;
                
                break;
            case 2:
                
                [sectionTitles addObject:@"Financial Aid"];
                
                NSArray *schoolAidValues = [self checkFinancialAidValues];
                
                schoolOneFloatValue = [[schoolAidValues objectAtIndex:0] floatValue];
                schoolTwoFloatValue = [[schoolAidValues objectAtIndex:1] floatValue];
                
                break;
        }
        
        NSNumber *numberValue = [NSNumber numberWithFloat:schoolOneFloatValue];
        [schoolOneValues addObject:numberValue];
        
        numberValue = [NSNumber numberWithFloat:schoolTwoFloatValue];
        [schoolTwoValues addObject:numberValue];
        
        
    }
}

-(void)createViewControllers
{
    NSUInteger capacity = [sectionTitles count];
    
    viewControllersForMe = [[NSMutableArray alloc] init];
    
    MUITCollege *dummyCollege;
    
    if (self.twoColleges == nil)
    {
        [self dataPackager];
    }
    
    for (int i = 0; i < capacity; i++)
    {
        
        NSNumber* schoolHeight = [schoolOneValues objectAtIndex:i];
        
        NSArray *settingKeysForSchool = [NSArray arrayWithObjects:
                                         @"Name",
                                         @"Height",
                                         nil];
        
        dummyCollege = self.twoColleges[0];
        
        NSArray *schoolOneValue = [NSArray arrayWithObjects:
                                   [self shortenString:dummyCollege.name],
                                   schoolHeight,
                                   nil];
        
        NSMutableDictionary *schoolOneSettings = [NSMutableDictionary dictionaryWithObjects:schoolOneValue
                                                                                    forKeys:settingKeysForSchool];
        
        schoolHeight = [schoolTwoValues objectAtIndex:i];
        
        dummyCollege = self.twoColleges[1];
        NSArray *schoolTwoValue = [NSArray arrayWithObjects:
                                   [self shortenString:dummyCollege.name],
                                   schoolHeight,
                                   nil];
        
        NSMutableDictionary *schoolTwoSettings = [NSMutableDictionary dictionaryWithObjects:schoolTwoValue
                                                                                    forKeys:settingKeysForSchool];
        
        NSArray *settingKeysForView = [NSArray arrayWithObjects:
                                       @"Title",
                                       @"Object One",
                                       @"Object Two",
                                       nil];
        
        NSArray *settingObjectsForView = [NSArray arrayWithObjects:
                                          [sectionTitles objectAtIndex:i],
                                          [self.twoColleges objectAtIndex:0],
                                          [self.twoColleges objectAtIndex:1],
                                          nil];
        
        NSMutableDictionary *generalSettings = [NSMutableDictionary dictionaryWithObjects:settingObjectsForView
                                                                    forKeys:settingKeysForView];
        
        NSMutableDictionary *viewControllerInformation = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                   schoolOneSettings, @"One",
                                                   schoolTwoSettings, @"Two",
                                                   generalSettings, @"All",
                                                   nil];
        
        
        CCAnimationsScreenViewController *cVC = [[CCAnimationsScreenViewController alloc] init];
        [cVC setModifierDictionary:viewControllerInformation];
        
        cVC.myIndex = i;
        
        [viewControllersForMe addObject:cVC];
    }
    
    
}

#pragma mark Methods for Dynamic Bar Height

-(float)determineBestForTuitionWithMoneyValue:(float) moneyValue andMaxInteger:(NSInteger)max andModifier:(float)modifier
{
    moneyValue *= 1000;
    
    float viewHeight = self.view.bounds.size.height;
    
    viewHeight -= modifier;
    
    float user = (float)max / moneyValue;
    
    return viewHeight/user;
}

-(float)determineBestForPopulationWithMoneyValue:(float) moneyValue andMaxInteger:(NSInteger)maxFloat andModifier:(float)modifier
{
    
    moneyValue *= 1000;
    
    float viewHeight = self.view.bounds.size.height;
    
    viewHeight -= modifier;
    
    float user = (float)maxFloat / moneyValue;
    
    return viewHeight/user;
}

-(int)determineLineNumberFromUnitValue:(float) unitValue andModifier:(float) modifier
{
    float screenHeight = self.view.bounds.size.height;
    
    int lines = (int)(screenHeight / unitValue);
    
    return lines;
}


#pragma mark View Configuration Methods -

-(void)configureNavigationBar
{
    self.navigationItem.title = @"Comparison";
    
    myNavigationItem = self.navigationItem;
}

#pragma mark Helper Methods -

-(CCAnimationsScreenViewController*)viewControllerAtIndex:(NSUInteger) index
{
    if (index > sectionTitles.count - 1)
    {
        return nil;
    }
    
    return [viewControllersForMe objectAtIndex:index];
}

-(NSInteger)indexOfViewController:(CCAnimationsScreenViewController*) viewController
{
    int indexValue = viewController.myIndex;
    
    return indexValue;
    
}

-(void)dataPackager
{
    //If no colleges were passed to this view controller than just package it with some dummy data so something is visible

    if (!self.twoColleges)
    {
        NSLog(@"\n\nColleges were not passed.\n\n");
        MUITCollege *collegeOne = [MUITCollege new];
        MUITCollege *collegeTwo = [MUITCollege new];
        
        collegeOne.name = @"Dummy College";
        collegeTwo.name = @"Dummy University";
        
        collegeOne.enrollment_total = 30000;
        collegeTwo.enrollment_total = 50000;
        
        collegeOne.tuition_in_state = 25000;
        collegeTwo.tuition_in_state= 65000;
        
        collegeOne.tuition_out_state = 45000;
        collegeTwo.tuition_out_state = 85000;
        
        collegeOne.percent_receive_financial_aid = 34;
        collegeTwo.percent_receive_financial_aid = 54;
        
        
        collegeOne.enrollment_men = 35000;
        collegeOne.enrollment_women = 5000;
        
        collegeTwo.enrollment_men = 10000;
        collegeTwo.enrollment_women = 20000;
        
        self.twoColleges = [[NSArray alloc] initWithObjects:collegeOne, collegeTwo, nil];
    }

}

-(NSString*)shortenString:(NSString*) string
{
    NSString *theString = [NSString stringWithString:string];
    
    NSMutableArray *aList = [NSMutableArray arrayWithObjects:@"University", @"Missouri", @"-", @"Alabama", nil];
    NSMutableArray *bList = [NSMutableArray arrayWithObjects:@"U", @"M", @"\n", @"A", nil];
    
    for (int i = 0; i < [aList count]; i++) {
        theString = [theString stringByReplacingOccurrencesOfString:aList[i] withString:bList[i]];
    }
    
    return theString;
    
}

-(NSArray*)checkFinancialAidValues {
    
    if (self.twoColleges)
    {
        MUITCollege *dummyCollege = self.twoColleges[0];
        
        CGFloat schoolOneValue = (CGFloat)dummyCollege.percent_receive_financial_aid;
        
        if (schoolOneValue > 100 || schoolOneValue < 0) {
            schoolOneValue = 0;
        }
        
        dummyCollege = self.twoColleges[1];
        
        CGFloat schoolTwoValue = (CGFloat)dummyCollege.percent_receive_financial_aid;
        
        if (schoolTwoValue > 100 || schoolTwoValue < 0) {
            schoolTwoValue = 0;
        }
        
        schoolOneValue /= 100.0;
        schoolTwoValue /= 100.0;
        
        
        NSArray *arrayToReturn = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:(CGFloat)schoolOneValue],
                                  [NSNumber numberWithFloat:(CGFloat)schoolTwoValue],
                                  nil];
        
        return arrayToReturn;
        
    }
    
    return nil;
}

@end

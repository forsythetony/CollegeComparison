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


@interface CCAnimationPageViewController () {
    
    NSMutableArray *sectionTitles;
    NSMutableArray *schoolOneValues;
    NSMutableArray *schoolTwoValues;
    NSMutableArray *labelModifier;
    NSMutableArray *lineLabelArray;
    NSMutableArray *linesArray;
    NSMutableArray *moneyValueArray;
    NSMutableArray *heightMultiplierArray;
    
    NSString *schoolOneTitle;
    NSString *schoolTwoTitle;
    
    NSMutableArray *chapterTexts;
    
    NSMutableArray *viewControllersForMe;
    NSDictionary *modifierDictionary;
    
    BOOL Mycompleted;
    
    UINavigationItem *myNavigationItem;
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
    [self dataPackager];
    [self configureNavigationBar];
    //Set up all arrays with data and create view controllers based on those arrays
    [self setAllArrays];
    [self createViewControllers];
    
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    
    
    
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    CCAnimationsScreenViewController *initialVC = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialVC];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self.pageViewController.view setFrame:[self.view bounds]];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [[viewControllers objectAtIndex:0] animateAll];
    [[viewControllers objectAtIndex:0] createHandle];
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

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    
    if ([pendingViewControllers firstObject]) {
        
        CCAnimationsScreenViewController *theView = [pendingViewControllers firstObject];
        [theView checkBeforeAnimation];
        theView.hasAnimated = YES;
        
        int index = [[[theView.modifierDictionary objectForKey:@"All"] objectForKey:@"Index"] integerValue];
        
        for (int i = 0; i < NUMBEROFVIEWCONTROLLERS; i++) {
            if (i == index) {
                [theView createHandle];
            }
            else
            {
                
                CCAnimationsScreenViewController *newView = [self viewControllerAtIndex:i];
                [newView removeDuringTransition];
            }
        }
        
    }
}
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed) {
        if ([previousViewControllers firstObject]) {
            CCAnimationsScreenViewController *theView = [previousViewControllers firstObject];
            
            [theView replaceHandle];
        }
    }
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
    float unitValue;
    float moneyValue;
    float heightMultiplier;
    int lines;
    float modifier;
    
    MUITCollege *dummyCollege;
    
    
    for (int i = 0; i < NUMBEROFVIEWCONTROLLERS; i++) {
        switch (i) {
                //            case 0:
                //                [sectionTitles addObject:@"Overall"];
                //                schoolOneValue = 3.0;
                //                schoolTwoValue = 5.0;
                //                [lineLabelArray addObject:@""];
                //                unitValue = 40.0;
                //                moneyValue = 0.0;
                //                lines = 10;
                //                heightMultiplier = 40.0;
                //                break;
            case 0:
                [sectionTitles addObject:@"Tuition"];
                
                
                
                dummyCollege = self.twoColleges[0];
                schoolOneValue= dummyCollege.tuition_in_state;
                
                dummyCollege = self.twoColleges[1];
                schoolTwoValue = dummyCollege.tuition_in_state;
                [lineLabelArray addObject:@"%@k"];
                moneyValue = 10.0;
                modifier = 220;
                unitValue = [self determineBestForTuitionWithMoneyValue:(moneyValue) andMaxInteger:MAX(schoolTwoValue, schoolOneValue) andModifier:modifier];
                heightMultiplier = (unitValue / (moneyValue * 1000));
                lines = [self determineLineNumberFromUnitValue:unitValue andModifier:modifier];
                break;
            case 1:
                [sectionTitles addObject:@"Enrollment Total"];
                
                dummyCollege = self.twoColleges[0];
                schoolOneValue = dummyCollege.enrollment_total;
                dummyCollege = self.twoColleges[1];
                schoolTwoValue = dummyCollege.enrollment_total;
                [lineLabelArray addObject:@"%@k"];
                
                moneyValue = 10.0;
                modifier = 250;
                unitValue = [self determineBestForPopulationWithMoneyValue:(moneyValue) andMaxInteger:MAX(schoolOneValue, schoolTwoValue) andModifier:modifier];
                heightMultiplier = (unitValue / (moneyValue * 1000));
                
                lines = [self determineLineNumberFromUnitValue:unitValue andModifier:modifier];
                
                break;
            case 2:
                [sectionTitles addObject:@"Financial Aid"];
                NSArray *schoolAidValues = [self checkFinancialAidValues];
                schoolOneValue = [[schoolAidValues objectAtIndex:0] intValue];
                schoolTwoValue = [[schoolAidValues objectAtIndex:1] intValue];
                [lineLabelArray addObject:@"%@%%"];
                moneyValue = 10.0;
                lines = 11;
                unitValue = 29.0;
                heightMultiplier = (unitValue / (moneyValue));
                break;
        }
        
        NSNumber *numberValue = [NSNumber numberWithFloat:schoolOneValue];
        [schoolOneValues addObject:numberValue];
        
        numberValue = [NSNumber numberWithFloat:schoolTwoValue];
        [schoolTwoValues addObject:numberValue];
        
        numberValue = [NSNumber numberWithFloat:unitValue];
        [labelModifier addObject:numberValue];
        
        numberValue = [NSNumber numberWithFloat:moneyValue];
        [moneyValueArray addObject:numberValue];
        
        numberValue = [NSNumber numberWithInt:lines];
        [linesArray addObject:numberValue];
        
        numberValue = [NSNumber numberWithFloat:heightMultiplier];
        [heightMultiplierArray addObject:numberValue];
        
    }
}

-(void)createViewControllers
{
    NSUInteger capacity = [sectionTitles count];
    
    viewControllersForMe = [[NSMutableArray alloc] init];
    
    MUITCollege *dummyCollege;
    
    if (self.twoColleges == nil) {
        [self dataPackager];
    }
    
    for (int i = 0; i < capacity; i++) {
        
        NSNumber* schoolHeight = [schoolOneValues objectAtIndex:i];
        
        NSArray *settingKeysForSchool = [NSArray arrayWithObjects:@"Name", @"Height", nil];
        
        dummyCollege = self.twoColleges[0];
        NSArray *schoolOneValue = [NSArray arrayWithObjects:
                                   [self shortenString:dummyCollege.name],
                                   schoolHeight,
                                   nil];
        
        NSDictionary *schoolOneSettings = [NSDictionary dictionaryWithObjects:schoolOneValue forKeys:settingKeysForSchool];
        
        schoolHeight = [schoolTwoValues objectAtIndex:i];
        
        dummyCollege = self.twoColleges[1];
        NSArray *schoolTwoValue = [NSArray arrayWithObjects:
                                   [self shortenString:dummyCollege.name],
                                   schoolHeight,
                                   nil];
        NSDictionary *schoolTwoSettings = [NSDictionary dictionaryWithObjects:schoolTwoValue forKeys:settingKeysForSchool];
        
        NSArray *settingKeysForView = [NSArray arrayWithObjects:
                                       @"Title",
                                       @"LineSpacing",
                                       @"LineLabel",
                                       @"Index",
                                       @"Lines",
                                       @"MoneyValue",
                                       @"Multiplier",
                                       @"My Navigation Item",
                                       @"Object One",
                                       @"Object Two",
                                       nil];
        
        NSArray *settingObjectsForView = [NSArray arrayWithObjects:
                                          [sectionTitles objectAtIndex:i],
                                          [labelModifier objectAtIndex:i],
                                          [lineLabelArray objectAtIndex:i],
                                          [NSNumber numberWithInt:i],
                                          [linesArray objectAtIndex:i],
                                          [moneyValueArray objectAtIndex:i],
                                          [heightMultiplierArray objectAtIndex:i],
                                          myNavigationItem,
                                          [self.twoColleges objectAtIndex:0],
                                          [self.twoColleges objectAtIndex:1],
                                          nil];
        
        NSLog(@"MY INDEX IS: %@", [NSNumber numberWithInt:i]);
        NSDictionary *generalSettings = [NSDictionary dictionaryWithObjects:settingObjectsForView
                                                                    forKeys:settingKeysForView];
        
        NSDictionary *viewControllerInformation = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   schoolOneSettings, @"One",
                                                   schoolTwoSettings, @"Two",
                                                   generalSettings, @"All",
                                                   nil];
        
        
        CCAnimationsScreenViewController *cVC = [[CCAnimationsScreenViewController alloc] init];
        [cVC setModifierDictionary:viewControllerInformation];
        
        
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
    UIColor *coralColor = [UIColor colorWithRed:205.0/255.0 green:86.0/255.0 blue:72.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = coralColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = @"Comparison";
    
    myNavigationItem = self.navigationItem;
}

#pragma mark Helper Methods -

-(CCAnimationsScreenViewController*)viewControllerAtIndex:(NSUInteger) index
{
    if (index > sectionTitles.count - 1) {
        return nil;
    }
    
    return [viewControllersForMe objectAtIndex:index];
}

-(NSInteger)indexOfViewController:(CCAnimationsScreenViewController*) viewController
{
    NSNumber *indexValue = [[viewController.modifierDictionary objectForKey:@"All"] objectForKey:@"Index"];
    
    return [indexValue integerValue];
    
}

-(void)dataPackager
{
    
    MUITCollege *collegeOne = [MUITCollege new];
    MUITCollege *collegeTwo = [MUITCollege new];
    
    collegeOne.name = @"University of Missouri- Columbia";
    collegeTwo.name = @"University of Missouri- St. Louis";
    
    collegeOne.enrollment_total = 40000;
    collegeTwo.enrollment_total = 30000;
    
    collegeOne.tuition_in_state = 25000;
    collegeTwo.tuition_in_state= 65000;
    
    collegeOne.percent_receive_financial_aid = 34;
    collegeTwo.percent_receive_financial_aid = 54;
    
    self.twoColleges = [[NSArray alloc] initWithObjects:collegeOne, collegeTwo, nil];
    
}

-(NSString*)shortenString:(NSString*) string
{
    NSString *theString = [NSString stringWithString:string];
    
    NSMutableArray *aList = [NSMutableArray arrayWithObjects:@"University", @"Missouri", @"-", nil];
    NSMutableArray *bList = [NSMutableArray arrayWithObjects:@"U", @"M", @"\n", nil];
    
    for (int i = 0; i < [aList count]; i++) {
        theString = [theString stringByReplacingOccurrencesOfString:aList[i] withString:bList[i]];
    }
    
    return theString;
    
}

-(NSArray*)checkFinancialAidValues {
    
    if (self.twoColleges) {
        MUITCollege *dummyCollege = self.twoColleges[0];
        
        NSInteger schoolOneValue = dummyCollege.percent_receive_financial_aid;
        
        if (schoolOneValue > 100 || schoolOneValue < 0) {
            schoolOneValue = 0;
        }
        
        dummyCollege = self.twoColleges[1];
        
        NSInteger schoolTwoValue = dummyCollege.percent_receive_financial_aid;
        
        if (schoolTwoValue > 100 || schoolTwoValue < 0) {
            schoolTwoValue = 0;
        }
        
        
        NSArray *arrayToReturn = [NSArray arrayWithObjects:[NSNumber numberWithInt:schoolOneValue], [NSNumber numberWithInt:schoolTwoValue], nil];
        
        
        return arrayToReturn;
        
    }
    
    return nil;
}

@end

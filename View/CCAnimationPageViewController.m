//
//  CCAnimationPageViewController.m
//  CollegeComparison
//
//  Created by Anthony Forsythe on 11/18/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CCAnimationPageViewController.h"
#import "CCAnimationsScreenViewController.h"

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
}

@end

@implementation CCAnimationPageViewController

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
    
    //Set up all arrays with data and create view controllers based on those arrays
    [self setAllArrays];
    [self createViewControllers];
    [self configureNavigationBar];
    
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
    
}

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

//Data source methods

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
    return 4;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

//Delegate methods
-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    
    if ([pendingViewControllers firstObject]) {
        CCAnimationsScreenViewController *theView = [pendingViewControllers firstObject];
        
        [theView checkBeforeAnimation];
        theView.hasAnimated = YES;
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

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
    
    
    
    float floatValueOne;
    float floatValueTwo;
    float unitValue;
    float moneyValue;
    float heightMultiplier;
    int lines;
    float modifier;
    
    for (int i = 0; i < 4; i++) {
        switch (i) {
            case 0:
                [sectionTitles addObject:@"Overall"];
                floatValueOne = 3.0;
                floatValueTwo = 5.0;
                [lineLabelArray addObject:@""];
                unitValue = 40.0;
                moneyValue = 0.0;
                lines = 10;
                heightMultiplier = 40.0;
                break;
            case 1:
                [sectionTitles addObject:@"Tuition"];
                floatValueOne= 156000.0;
                floatValueTwo = 45000.0;
                [lineLabelArray addObject:@"%@k"];
                moneyValue = 10.0;
                modifier = 200;
                unitValue = [self determineBestForTuitionWithMoneyValue:(moneyValue) andMaxFloat:MAX(floatValueTwo, floatValueOne) andModifier:modifier];
                heightMultiplier = (unitValue / (moneyValue * 1000));
                lines = [self determineLineNumberFromUnitValue:unitValue andModifier:modifier];
                break;
            case 2:
                [sectionTitles addObject:@"Population"];
                floatValueOne = 80000;
                floatValueTwo = 30000.0;
                [lineLabelArray addObject:@"%@k"];
                
                moneyValue = 10.0;
                modifier = 250;
                unitValue = [self determineBestForPopulationWithMoneyValue:(moneyValue) andMaxFloat:MAX(floatValueOne, floatValueTwo) andModifier:modifier];
                heightMultiplier = (unitValue / (moneyValue * 1000));
                
                lines = [self determineLineNumberFromUnitValue:unitValue andModifier:modifier];
                
                break;
            case 3:
                [sectionTitles addObject:@"Aid"];
                floatValueOne = 20000.0;
                floatValueTwo = 15000.0;
                [lineLabelArray addObject:@"%@%%"];
                moneyValue = 10.0;
                lines = 11;
                unitValue = (self.view.bounds.size.height - 135.0) / moneyValue;
                heightMultiplier = (unitValue / (moneyValue * 1000));
                break;
            default:
                break;
        }
        
        NSNumber *numberValue = [NSNumber numberWithFloat:floatValueOne];
        [schoolOneValues addObject:numberValue];
        
        numberValue = [NSNumber numberWithFloat:floatValueTwo];
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
    
    
    for (int i = 0; i < capacity; i++) {
        
        NSNumber* schoolHeight = [schoolOneValues objectAtIndex:i];
        
        NSArray *settingKeysForSchool = [NSArray arrayWithObjects:@"Name", @"Height", nil];
        
        NSArray *schoolOneValue = [NSArray arrayWithObjects:@"Mizzou", schoolHeight, nil];
        NSDictionary *schoolOneSettings = [NSDictionary dictionaryWithObjects:schoolOneValue forKeys:settingKeysForSchool];
        
        schoolHeight = [schoolTwoValues objectAtIndex:i];
        NSArray *schoolTwoValue = [NSArray arrayWithObjects:@"NYU", schoolHeight, nil];
        NSDictionary *schoolTwoSettings = [NSDictionary dictionaryWithObjects:schoolTwoValue forKeys:settingKeysForSchool];
        
        NSArray *settingKeysForView = [NSArray arrayWithObjects:
                                                                @"Title",
                                                                @"LineSpacing",
                                                                @"LineLabel",
                                                                @"Index",
                                                                @"Lines",
                                                                @"MoneyValue",
                                                                @"Multiplier",
                                                                nil];
        
        NSArray *settingObjectsForView = [NSArray arrayWithObjects:
                                                                    [sectionTitles objectAtIndex:i],
                                                                    [labelModifier objectAtIndex:i],
                                                                    [lineLabelArray objectAtIndex:i],
                                                                    [NSNumber numberWithInt:i],
                                                                    [linesArray objectAtIndex:i],
                                                                    [moneyValueArray objectAtIndex:i],
                                                                    [heightMultiplierArray objectAtIndex:i],
                                                                    nil];
        
        
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

-(float)determineBestForTuitionWithMoneyValue:(float) moneyValue andMaxFloat:(float)max andModifier:(float)modifier
{
    moneyValue *= 1000;
    
    float viewHeight = self.view.bounds.size.height;
    
    viewHeight -= modifier;
    
    float user = max / moneyValue;
    
    return viewHeight/user;
}

-(float)determineBestForPopulationWithMoneyValue:(float) moneyValue andMaxFloat:(float)maxFloat andModifier:(float)modifier
{
    
    moneyValue *= 1000;
    
    float viewHeight = self.view.bounds.size.height;
    
    viewHeight -= modifier;
    
    float user = maxFloat / moneyValue;
    
    return viewHeight/user;
}

-(int)determineLineNumberFromUnitValue:(float) unitValue andModifier:(float) modifier
{
    float screenHeight = self.view.bounds.size.height;
    
    int lines = (int)(screenHeight / unitValue);
    
    return lines;
}


-(void)configureNavigationBar
{
    UIColor *coralColor = [UIColor colorWithRed:205.0/255.0 green:86.0/255.0 blue:72.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = coralColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = @"Comparison";
}

@end

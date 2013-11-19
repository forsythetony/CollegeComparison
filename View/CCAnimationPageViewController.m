//
//  CCAnimationPageViewController.m
//  CollegeComparison
//
//  Created by Anthony Forsythe on 11/18/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CCAnimationPageViewController.h"
#import "CCAnimationsScreenViewController.h"

@interface CCAnimationPageViewController ()

@end

@implementation CCAnimationPageViewController

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
    NSLog(@"Hello there tony");
    [self setAllArrays];
    [self createViewControllers];
    
    
    //Setting our chapter title array
    
    /*
     self.chapterTitles = [[NSMutableArray alloc] init];
     for (int i = 0; i < 10; i++) {
     [self.chapterTitles addObject:[NSString stringWithFormat:@"Chapter %d", i]];
     }
     
     //Setting our chapter texts array
     self.chapterTexts = [[NSMutableArray alloc] init];
     for (int i = 0; i < 10; i++) {
     [self.chapterTexts addObject:[NSString stringWithFormat:@"This is the text for chapter %d", i]];
     }
     
     */
    //NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
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
    if (index > self.sectionTitles.count - 1) {
        return nil;
    }
    
    return [self.viewControllersForMe objectAtIndex:index];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setAllArrays
{
    self.sectionTitles  = [[NSMutableArray alloc] init];
    self.schoolOneValues = [[NSMutableArray alloc] init];
    self.labelModifier = [[NSMutableArray alloc] init];
    self.schoolTwoValues = [[NSMutableArray alloc] init];
    self.lineLabelArray = [[NSMutableArray alloc] init];
    self.moneyValueArray = [[NSMutableArray alloc] init];
    self.linesArray = [[NSMutableArray alloc] init];
    self.heightMultiplier = [[NSMutableArray alloc] init];
    
    
    
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
                [self.sectionTitles addObject:@"Overall"];
                floatValueOne = 3.0;
                floatValueTwo = 5.0;
                [self.lineLabelArray addObject:@""];
                unitValue = 40.0;
                moneyValue = 0.0;
                lines = 10;
                heightMultiplier = 40.0;
                break;
            case 1:
                [self.sectionTitles addObject:@"Tuition"];
                floatValueOne= 156000.0;
                floatValueTwo = 45000.0;
                [self.lineLabelArray addObject:@"%@k"];
                moneyValue = 10.0;
                modifier = 200;
                unitValue = [self determineBestForTuitionWithMoneyValue:(moneyValue) andMaxFloat:MAX(floatValueTwo, floatValueOne) andModifier:modifier];
                heightMultiplier = (unitValue / (moneyValue * 1000));
                lines = [self determineLineNumberFromUnitValue:unitValue andModifier:modifier];
                break;
            case 2:
                [self.sectionTitles addObject:@"Population"];
                floatValueOne = 80000;
                floatValueTwo = 30000.0;
                [self.lineLabelArray addObject:@"%@k"];
                
                moneyValue = 10.0;
                modifier = 250;
                unitValue = [self determineBestForPopulationWithMoneyValue:(moneyValue) andMaxFloat:MAX(floatValueOne, floatValueTwo) andModifier:modifier];
                heightMultiplier = (unitValue / (moneyValue * 1000));
                
                lines = [self determineLineNumberFromUnitValue:unitValue andModifier:modifier];
                
                break;
            case 3:
                [self.sectionTitles addObject:@"Aid"];
                floatValueOne = 20000.0;
                floatValueTwo = 15000.0;
                [self.lineLabelArray addObject:@"%@%%"];
               
                moneyValue = 10.0;
                lines = 11;
                unitValue = (self.view.bounds.size.height - 140.0) / moneyValue;
                heightMultiplier = (unitValue / (moneyValue * 1000));
                break;
            default:
                break;
        }
        
        NSNumber *numberValue = [NSNumber numberWithFloat:floatValueOne];
        [self.schoolOneValues addObject:numberValue];
        
        numberValue = [NSNumber numberWithFloat:floatValueTwo];
        [self.schoolTwoValues addObject:numberValue];
        
        numberValue = [NSNumber numberWithFloat:unitValue];
        [self.labelModifier addObject:numberValue];

        numberValue = [NSNumber numberWithFloat:moneyValue];
        [self.moneyValueArray addObject:numberValue];
        
        numberValue = [NSNumber numberWithInt:lines];
        [self.linesArray addObject:numberValue];
        
        numberValue = [NSNumber numberWithFloat:heightMultiplier];
        [self.heightMultiplier addObject:numberValue];
        
    }
}

-(void)createViewControllers
{
    NSUInteger capacity = [self.sectionTitles count];
    
    self.viewControllersForMe = [[NSMutableArray alloc] init];
    
    
    
    
    for (int i = 0; i < capacity; i++) {
        
        
        NSNumber* schoolHeight = [self.schoolOneValues objectAtIndex:i];
        
        NSArray *settingKeysForSchool = [NSArray arrayWithObjects:@"Name", @"Height", nil];
        
        NSArray *schoolOneValues = [NSArray arrayWithObjects:@"Mizzou", schoolHeight, nil];
        NSDictionary *schoolOneSettings = [NSDictionary dictionaryWithObjects:schoolOneValues forKeys:settingKeysForSchool];
        
        schoolHeight = [self.schoolTwoValues objectAtIndex:i];
        NSArray*schoolTwoValues = [NSArray arrayWithObjects:@"NYU", schoolHeight, nil];
        NSDictionary *schoolTwoSettings = [NSDictionary dictionaryWithObjects:schoolTwoValues forKeys:settingKeysForSchool];
        
        NSArray *settingKeysForView = [NSArray arrayWithObjects:@"Title", @"LineSpacing", @"LineLabel",@"Index",@"Lines", @"MoneyValue",@"Multiplier",nil];
        
        NSArray *settingObjectsForView = [NSArray arrayWithObjects:
                                          [self.sectionTitles objectAtIndex:i],
                                          [self.labelModifier objectAtIndex:i],
                                          [self.lineLabelArray objectAtIndex:i],
                                          [NSNumber numberWithInt:i],
                                          [self.linesArray objectAtIndex:i],
                                          [self.moneyValueArray objectAtIndex:i],
                                          [self.heightMultiplier objectAtIndex:i],
                                          nil];
        
        
        NSDictionary *generalSettings = [NSDictionary dictionaryWithObjects:settingObjectsForView forKeys:settingKeysForView];
        
        NSDictionary *viewControllerInformation = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   schoolOneSettings, @"One",
                                                   schoolTwoSettings, @"Two",
                                                   generalSettings, @"All",
                                                   nil];
        
        
        CCAnimationsScreenViewController *cVC = [[CCAnimationsScreenViewController alloc] init];
        
        [cVC setModifierDictionary:viewControllerInformation];
        
        
        [self.viewControllersForMe addObject:cVC];
    }
    
    
}

-(float)determineBestForTuitionWithMoneyValue:(float) moneyValue andMaxFloat:(float)max andModifier:(float)modifier
{
    moneyValue *= 1000;
    
    float viewHeight = self.view.bounds.size.height;
    
    viewHeight -= modifier;
    
    
    float user = max / moneyValue;
    
    NSLog(@"RETURNING: %lf", user);
    return viewHeight/user;
    
    
}

-(float)determineBestForPopulationWithMoneyValue:(float) moneyValue andMaxFloat:(float)maxFloat andModifier:(float)modifier
{
    
    moneyValue *= 1000;
    
    float viewHeight = self.view.bounds.size.height;
    
    viewHeight -= modifier;
    
    
    float user = maxFloat / moneyValue;
    
    NSLog(@"RETURNING: %lf", user);
    return viewHeight/user;
}

-(int)determineLineNumberFromUnitValue:(float) unitValue andModifier:(float) modifier
{
    float screenHeight = self.view.bounds.size.height;
    
    
    
    int lines = (int)(screenHeight / unitValue);
    
    NSLog(@"LINENUMBER: %d", lines);
    return lines;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
//    if ([previousViewControllers lastObject])
//    {
//        CCAnimationsScreenViewController *theView = [previousViewControllers lastObject];
//        [theView setLabel];
//    }
    
}
-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    
    if ([pendingViewControllers firstObject]) {
        CCAnimationsScreenViewController *theView = [pendingViewControllers firstObject];
        
            [theView checkBeforeAnimation];
            theView.hasAnimated = YES;
        
               
    }
}
@end

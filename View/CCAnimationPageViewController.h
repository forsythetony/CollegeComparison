//
//  CCAnimationPageViewController.h
//  CollegeComparison
//
//  Created by Anthony Forsythe on 11/18/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUITCollegeDataProvider.h"

@interface CCAnimationPageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;

//Array that holds the two college objects handed to it by the previous view controller
@property (nonatomic, strong) NSArray *twoColleges;

@end

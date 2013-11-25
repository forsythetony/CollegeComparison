//
//  CCAnimationPageViewController.h
//  CollegeComparison
//
//  Created by Anthony Forsythe on 11/18/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCAnimationPageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSMutableArray *schoolOneValues;
@property (nonatomic, strong) NSMutableArray *schoolTwoValues;
@property (nonatomic, strong) NSMutableArray *labelModifier;
@property (nonatomic, strong) NSMutableArray *lineLabelArray;
@property (nonatomic, strong) NSMutableArray *linesArray;
@property (nonatomic, strong) NSMutableArray *moneyValueArray;
@property (nonatomic, strong) NSMutableArray *heightMultiplier;



@property (nonatomic, strong) NSString *schoolOneTitle;
@property (nonatomic, strong) NSString *schoolTwoTitle;

@property (nonatomic, strong) NSMutableArray *chapterTexts;

@property (nonatomic, strong) NSMutableArray *viewControllersForMe;


@property (nonatomic, strong) NSDictionary *modifierDictionary;

@end

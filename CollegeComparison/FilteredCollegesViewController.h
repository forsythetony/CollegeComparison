//
//  FilteredCollegesViewController.h
//  CollegeComparison
//
//  Created by Josh Valdivieso on 12/1/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilteredCollegesTableViewCell.h"
#import "CollegeDetailViewController.h"
#import "MUITCollege.h"
#import "MUITCollegeDataProvider.h"
#import "CollegeDetailTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CCAnimationPageViewController.h"

@interface FilteredCollegesViewController : UITableViewController

@property (nonatomic, strong) NSArray *universitiesPassed;
@property (nonatomic, strong) NSMutableArray *allCellsInTable;
@property (nonatomic, strong) NSMutableArray *collegesToCompare;

@property (nonatomic, strong) NSDictionary *navigationBarAttributes;
@property (nonatomic, strong) NSMutableDictionary *storedSchoolsDictionary;

@property (nonatomic, strong) UIBarButtonItem *selectButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *compareButton;

@property (strong, nonatomic) MUITCollege *representedCollege;

- (void)selectCollegesToCompare:(id)sender;

@end
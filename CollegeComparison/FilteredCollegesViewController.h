//
//  FilteredCollegesViewController.h
//  CollegeComparison
//
//  Created by Josh Valdivieso on 12/1/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilteredCollegesTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface FilteredCollegesViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *universityNames;
@property (nonatomic, strong) NSMutableArray *collegesToCompare;
//@property (nonatomic, strong) NSMutableArray *selectedRowsToCompare;

@property (nonatomic, strong) NSDictionary *navigationBarAttributes;
@property (nonatomic, strong) NSMutableDictionary *storedSchoolsDictionary;

@property (nonatomic, strong) UIBarButtonItem *selectButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *compareButton;

//@property (nonatomic, strong) IBOutlet UIBarButtonItem *selectCollegesToCompare;

- (void) CollegeCounter:(NSUInteger)selectedCollegeCell;
- (void)selectCollegesToCompare:(id)sender;

@end
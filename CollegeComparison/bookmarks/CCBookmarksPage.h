//
//  CCBookmarksPage.h
//  CollegeComparison
//
//  Created by Anthony Forsythe on 12/7/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUITCollege.h"
#import "CollegeDetailTableViewController.h"

@interface CCBookmarksPage : UIViewController < UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *favoritesOrRect;


@property (strong, nonatomic) NSMutableArray *favoritesArray, *recentArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *panelViewButton;


@end

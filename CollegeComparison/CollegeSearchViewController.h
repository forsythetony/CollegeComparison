//
//  CollegeSearchViewController.h
//  CollegeSearch
//
//  Created by borrower on 11/5/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollegeDetailTableViewController.h"

@interface CollegeSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

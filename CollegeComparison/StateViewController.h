//
//  StateViewController.h
//  CollegeComparison
//
//  Created by borrower on 11/25/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StateViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *statesTableView;

@end
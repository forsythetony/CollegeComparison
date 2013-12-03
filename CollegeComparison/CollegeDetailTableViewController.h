//
//  CollegeDetailTableViewController.h
//  CollegeComparison
//
//  Created by Fernando Colon on 12/2/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUITCollegeDataProvider.h"

@interface CollegeDetailTableViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UILabel *collegeLabel;
@property (nonatomic, strong) NSString *collegeName;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuitionLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentBTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *menEnrollLabel;
@property (weak, nonatomic) IBOutlet UILabel *womenEnrollLabel;
@property (weak, nonatomic) IBOutlet UILabel *finaidLabel;
@property (weak, nonatomic) IBOutlet UILabel *institLabel;
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accRateLabel;

@end

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
@property (nonatomic, strong) NSString *instituteType;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *inTuitionLabel;
@property (weak, nonatomic) IBOutlet UILabel *outTuitionLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentBTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *menEnrollLabel;
@property (weak, nonatomic) IBOutlet UILabel *womenEnrollLabel;
@property (weak, nonatomic) IBOutlet UILabel *finaidLabel;
@property (weak, nonatomic) IBOutlet UILabel *institLabel;
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accRateLabel;

@property (weak, nonatomic) IBOutlet UILabel *actRead;
@property (weak, nonatomic) IBOutlet UILabel *actMath;
@property (weak, nonatomic) IBOutlet UILabel *actWriting;
@property (weak, nonatomic) IBOutlet UILabel *actComposite;

@property (weak, nonatomic) IBOutlet UILabel *satRead;
@property (weak, nonatomic) IBOutlet UILabel *satMath;
@property (weak, nonatomic) IBOutlet UILabel *satWriting;

@property (strong, nonatomic) MUITCollege *representedCollege;

@end

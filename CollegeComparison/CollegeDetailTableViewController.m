//
//  CollegeDetailTableViewController.m
//  CollegeComparison
//
//  Created by Fernando Colon on 12/2/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CollegeDetailTableViewController.h"

@interface CollegeDetailTableViewController ()

@end


@implementation CollegeDetailTableViewController

@synthesize collegeLabel;
@synthesize collegeName;
@synthesize locationLabel;
@synthesize tuitionLabel;
@synthesize studentBTotalLabel;
@synthesize menEnrollLabel;
@synthesize womenEnrollLabel;
@synthesize finaidLabel;
@synthesize institLabel;
@synthesize degreeLabel;
@synthesize accRateLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Set the Label text with the selected recipe
    collegeLabel.text = self.collegeName;
    tuitionLabel.text = @"40,000";
    studentBTotalLabel.text = @"30,000";
    
    float menEnrollment = 12000, totalEnrollment = 30000, womenEnrollment = 18000;
    float menPerc = menEnrollment/totalEnrollment, womenPerc = womenEnrollment/totalEnrollment;
    
    menEnrollLabel.text = [NSString stringWithFormat:@"%.2f%%", (menPerc*100)];
    
    womenEnrollLabel.text = [NSString stringWithFormat:@"%.2f%%", (womenPerc*100)];
    
    //finaidLabel.text = college.percent_receive_financial_aid;
    institLabel.text = @"Public";
    degreeLabel.text = @"Associates";
    accRateLabel.text = @"60%";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 8;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

@end

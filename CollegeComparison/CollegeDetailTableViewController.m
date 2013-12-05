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
@synthesize inTuitionLabel;
@synthesize outTuitionLabel;
@synthesize studentBTotalLabel;
@synthesize menEnrollLabel;
@synthesize womenEnrollLabel;
@synthesize finaidLabel;
@synthesize institLabel;
@synthesize degreeLabel;
@synthesize accRateLabel;
@synthesize actComposite;
@synthesize actMath;
@synthesize actRead;
@synthesize actWriting;
@synthesize satMath;
@synthesize satRead;
@synthesize satWriting;

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
    
    NSMutableDictionary* options = [NSMutableDictionary new];
    [options setObject:@"University of Missouri-" forKey:@"name"];
    
//    MUITCollege *college = self.representedCollege;
    
    MUITCollegeDataProvider *collegeManager = [MUITCollegeDataProvider new];
    
    NSMutableArray *collegeArray = [collegeManager getColleges:options];
    for(MUITCollege *college in collegeArray)
    {
    collegeLabel.text = college.name;
    locationLabel.text = college.state;
    inTuitionLabel.text = [NSString stringWithFormat:@"$%d", college.tuition_in_state];
    outTuitionLabel.text = [NSString stringWithFormat:@"$%d", college.tuition_out_state];
    
    float menEnrollment = college.enrollment_men, totalEnrollment = college.enrollment_total, womenEnrollment = college.enrollment_women;
    float menPerc = menEnrollment/totalEnrollment, womenPerc = womenEnrollment/totalEnrollment;

    studentBTotalLabel.text = [NSString stringWithFormat:@"%d", college.enrollment_total];
    
    menEnrollLabel.text = [NSString stringWithFormat:@"%.2f%%", (menPerc*100)];

    womenEnrollLabel.text = [NSString stringWithFormat:@"%.2f%%", (womenPerc*100)];

    finaidLabel.text = [NSString stringWithFormat:@"%d%%", college.percent_receive_financial_aid];
    institLabel.text = @"Public";
    degreeLabel.text = @"Associates";
    accRateLabel.text = @"60%";
    
    actRead.text = [NSString stringWithFormat:@"%d - %d", college.act_english_25, college.act_english_75];
    actMath.text = [NSString stringWithFormat:@"%d - %d", college.act_math_25, college.act_math_75];
    actWriting.text = [NSString stringWithFormat:@"%d - %d", college.act_writing_25, college.act_writing_75];
    actComposite.text = [NSString stringWithFormat:@"%d - %d", college.act_25, college.act_75];
    
    satRead.text = [NSString stringWithFormat:@"%d - %d", college.sat_reading_25, college.sat_reading_75];
    satMath.text = [NSString stringWithFormat:@"%d - %d", college.sat_math_25, college.sat_math_75];
    satWriting.text = [NSString stringWithFormat:@"%d - %d", college.sat_writing_25, college.sat_writing_75];
    }
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

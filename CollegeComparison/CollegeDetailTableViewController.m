//
//  CollegeDetailTableViewController.m
//  CollegeComparison
//
//  Created by Fernando Colon on 12/2/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CollegeDetailTableViewController.h"
#import "CCAppDelegate.h"

@interface CollegeDetailTableViewController ()

@end


@implementation CollegeDetailTableViewController

@synthesize collegeLabel;
@synthesize instituteType;
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
    
    MUITCollege *college = self.representedCollege;
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"my_star_icon"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(addToFavorites:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
    
    
    
    [self addToRecents:college];
    
    collegeLabel.text = college.name;   //Displays the name of the university/college selected
    locationLabel.text = college.state; //Displays the state in 2 letter format
    
    if (college.tuition_in_state <= 0) inTuitionLabel.text = @"N/A"; //checks to make sure value exists
    else inTuitionLabel.text = [NSString stringWithFormat:@"$%d", college.tuition_in_state];
    
    if (college.tuition_out_state <= 0) outTuitionLabel.text = @"N/A";
    else outTuitionLabel.text = [NSString stringWithFormat:@"$%d", college.tuition_out_state];
    
    //logic for making the percentages of the enrollment of men and women
    float menEnrollment = college.enrollment_men, totalEnrollment = college.enrollment_total, womenEnrollment = college.enrollment_women;
    float menPerc = menEnrollment/totalEnrollment, womenPerc = womenEnrollment/totalEnrollment;

    //error checking then displays
    if (college.enrollment_total <= 0) studentBTotalLabel.text = @"N/A";
    else studentBTotalLabel.text = [NSString stringWithFormat:@"%d", college.enrollment_total];
    
    if (menEnrollment <= 0) menEnrollLabel.text = @"N/A";
    else menEnrollLabel.text = [NSString stringWithFormat:@"%.2f%%", (menPerc*100)];

    if (womenEnrollment <= 0) womenEnrollLabel.text = @"N/A";
    else womenEnrollLabel.text = [NSString stringWithFormat:@"%.2f%%", (womenPerc*100)];

    if (college.percent_receive_financial_aid <= 0) finaidLabel.text = @"N/A";
    else finaidLabel.text = [NSString stringWithFormat:@"%d%%", college.percent_receive_financial_aid];
    
    //logic to determine the institution type
    if (college.control == 1) instituteType = @"Public";
    else if (college.control == 2) instituteType = @"Private";
    else instituteType  = @"N/A";
    institLabel.text = instituteType;
    
    //awesome acceptance rates
    accRateLabel.text = @"007%";
    
    //the following if statements display N/A's if there is no score for each text section
    if (college.act_english_25 <= 0 && college.act_english_75 <= 0) actRead.text = @"N/A";
    else actRead.text = [NSString stringWithFormat:@"%d - %d", college.act_english_25, college.act_english_75];
    
    if (college.act_math_25 <= 0 && college.act_math_75 <= 0) actMath.text = @"N/A";
    else actMath.text = [NSString stringWithFormat:@"%d - %d", college.act_math_25, college.act_math_75];
    
    if (college.act_writing_25 <= 0 && college.act_writing_75 <= 0) actWriting.text = @"N/A";
    else actWriting.text = [NSString stringWithFormat:@"%d - %d", college.act_writing_25, college.act_writing_75];
    
    if (college.act_25 <= 0 && college.act_75 <= 0) actComposite.text = @"N/A";
    else actComposite.text = [NSString stringWithFormat:@"%d - %d", college.act_25, college.act_75];
    
    if (college.sat_reading_25 <= 0 && college.sat_reading_75 <= 0) satRead.text = @"N/A";
    else satRead.text = [NSString stringWithFormat:@"%d - %d", college.sat_reading_25, college.sat_reading_75];
    
    if (college.sat_math_25 <= 0 && college.sat_math_75 <= 0) satMath.text = @"N/A";
    else satMath.text = [NSString stringWithFormat:@"%d - %d", college.sat_math_25, college.sat_math_75];
    
    if (college.sat_writing_25 <= 0 && college.sat_writing_75 <= 0) satWriting.text = @"N/A";
    else satWriting.text = [NSString stringWithFormat:@"%d - %d", college.sat_writing_25, college.sat_writing_75];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 7;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    
//    // Configure the cell...
//    
//    return cell;
//}

-(void)addToRecents:(MUITCollege*) college
{
    CCAppDelegate *appDelegate = (CCAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSInteger maxSizeOfRecents = 30;
    
    BOOL wasEqual = NO;
    
    for (MUITCollege *dummyCollege in appDelegate.recentlyVisited) {
        if ([college.name isEqualToString:dummyCollege.name]) {
            [appDelegate.recentlyVisited removeObject:dummyCollege];
            [appDelegate.recentlyVisited insertObject:dummyCollege atIndex:0];
            wasEqual = YES;
        }
    }
    
    NSInteger counter = [appDelegate.recentlyVisited count];
    
    if (wasEqual == NO && counter < maxSizeOfRecents) {
            [appDelegate.recentlyVisited insertObject:college atIndex:0];
    }
    else if (wasEqual == NO && counter >= maxSizeOfRecents)
    {
        [appDelegate.recentlyVisited removeObject:[appDelegate.recentlyVisited lastObject]];
        [appDelegate.recentlyVisited insertObject:college atIndex:0];
    }

}

-(void)addToFavorites:(UIButton*) sender
{
    [UIView animateWithDuration:2.0 animations:^{
        [sender setFrame:CGRectMake(0.0, 0.0, 20.0, 40.0)];

    }];
    
    CCAppDelegate *appDelegate = (CCAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    BOOL wasEqual = NO;
    
    MUITCollege *theCollege = self.representedCollege;
    
    for (MUITCollege *college in appDelegate.bookmarked)
    {
        if ([college.name isEqualToString:theCollege.name]) {
            [appDelegate.bookmarked removeObject:college];
            [appDelegate.bookmarked insertObject:college atIndex:0];
            wasEqual = YES;
        }
    }
    
    if (wasEqual == NO) {
        [appDelegate.bookmarked insertObject:theCollege atIndex:0];
    }
    
    
    
    
}
@end

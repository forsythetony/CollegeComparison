//
//  CollegeDetailTableViewController.m
//  CollegeComparison
//
//  Created by Fernando Colon on 12/2/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CollegeDetailTableViewController.h"
#import "CCAppDelegate.h"

@interface CollegeDetailTableViewController () {
    NSMutableArray *favorites, *recents;
    BOOL favorited;
    
    UIImage *highlightedStarImage, *unhighlightedStarImage;
    
    UIButton *favoritesButton;
}

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
    
    [self configureGobalVariables];
    [self configureFavoritesButton];
    
    
    [self addToRecents:college];
    
    collegeLabel.text = college.name;   //Displays the name of the university/college selected
    locationLabel.text = college.state; //Displays the state in 2 letter format
    
    if (college.tuition_in_state <= 0) inTuitionLabel.text = @"N/A"; //checks to make sure value exists
    else inTuitionLabel.text = [NSString stringWithFormat:@"$%ld", (long)college.tuition_in_state];
    
    if (college.tuition_out_state <= 0) outTuitionLabel.text = @"N/A";
    else outTuitionLabel.text = [NSString stringWithFormat:@"$%ld", (long)college.tuition_out_state];
    
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
-(void)viewDidAppear:(BOOL)animated
{




    
    CCAppDelegate *appDelegate = (CCAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    favorites = appDelegate.bookmarked;
    
    recents = [[NSMutableArray alloc] initWithArray:appDelegate.recentlyVisited];
    
    NSString *thisCollegeString = self.representedCollege.name;
    
    favorited = NO;
    
    for (MUITCollege *dummyCollege in favorites)
    {
        if ([dummyCollege.name isEqualToString:thisCollegeString])
        {
            favorited = YES;
        }
    }

    if (favorited == YES) {
        [favoritesButton setImage:highlightedStarImage forState:UIControlStateNormal];
    }
    else
    {
        [favoritesButton setImage:unhighlightedStarImage forState:UIControlStateNormal];
    }

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
    
   
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
   [DateFormatter setDateFormat:@"EEE, d MMM yyyy hh:mm:ss"];
    NSString *currentDateAndTime = [DateFormatter stringFromDate:[NSDate date]];
    
    NSDictionary *recentsObject = [NSDictionary dictionaryWithObjectsAndKeys:college, @"College", currentDateAndTime, @"Time", nil];
    
    
    
    for (NSDictionary *dictionary in appDelegate.recentlyVisited)
    {
        MUITCollege *theCollege = [dictionary objectForKey:@"College"];
    
        if ([college.name isEqualToString:theCollege.name]) {
            [appDelegate.recentlyVisited removeObject:dictionary];
            [appDelegate.recentlyVisited insertObject:recentsObject atIndex:0];
            wasEqual = YES;
        }
    }
    
    NSInteger counter = [appDelegate.recentlyVisited count];
    
    if (wasEqual == NO && counter < maxSizeOfRecents) {
            [appDelegate.recentlyVisited insertObject:recentsObject atIndex:0];
    }
    else if (wasEqual == NO && counter >= maxSizeOfRecents)
    {
        [appDelegate.recentlyVisited removeObject:[appDelegate.recentlyVisited lastObject]];
        [appDelegate.recentlyVisited insertObject:recentsObject atIndex:0];
    }

}



-(void)configureFavoritesButton
{
    favoritesButton = [UIButton buttonWithType:UIButtonTypeCustom];

    if (favorited == YES)
    {
        [favoritesButton setImage:highlightedStarImage forState:UIControlStateNormal];
    }
    else if (favorited == NO)
    {
        [favoritesButton setImage:unhighlightedStarImage forState:UIControlStateNormal];
    }
    
    
    
    [favoritesButton addTarget:self action:@selector(addToFavorites:) forControlEvents:UIControlEventTouchUpInside];
    [favoritesButton setFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:favoritesButton];
    self.navigationItem.rightBarButtonItem = barButton;

}
-(void)addToFavorites:(UIButton*) sender
{
    if (favorited == YES) {
//        [sender setImage:unhighlightedStarImage forState:UIControlStateNormal];
//        
//        
//        
//        [favorites insertObject:self.representedCollege atIndex:0];

        [sender setImage:unhighlightedStarImage forState:UIControlStateNormal];
        
        [favorites removeObject:self.representedCollege];
    }
    else if (favorited == NO)
    {
        [sender setImage:highlightedStarImage forState:UIControlStateNormal];
        
        [favorites insertObject:self.representedCollege atIndex:0];
    }
 
}
-(void)configureGobalVariables
{
    CCAppDelegate *appDelegate = (CCAppDelegate*)[[UIApplication sharedApplication] delegate];

    favorites = appDelegate.bookmarked;
    
    recents = [[NSMutableArray alloc] initWithArray:appDelegate.recentlyVisited];
    
    highlightedStarImage = [UIImage imageNamed:@"highlighted_star.png"];
    unhighlightedStarImage = [UIImage imageNamed:@"unhighlighted_star.png"];

    
    NSString *thisCollegeString = self.representedCollege.name;
    
    
    for (MUITCollege *dummyCollege in favorites)
    {
        if ([dummyCollege.name isEqualToString:thisCollegeString])
        {
            favorited = YES;
        }
    }

}
@end

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
    
    [self aestheticsConfiguration];
    
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
    else studentBTotalLabel.text = [NSString stringWithFormat:@"%ld", (long)college.enrollment_total];
    
    if (menEnrollment <= 0) menEnrollLabel.text = @"N/A";
    else menEnrollLabel.text = [NSString stringWithFormat:@"%.2f%%", (menPerc*100)];

    if (womenEnrollment <= 0) womenEnrollLabel.text = @"N/A";
    else womenEnrollLabel.text = [NSString stringWithFormat:@"%.2f%%", (womenPerc*100)];

    if (college.percent_receive_financial_aid <= 0) finaidLabel.text = @"N/A";
    else finaidLabel.text = [NSString stringWithFormat:@"%ld%%", (long)college.percent_receive_financial_aid];
    
    //logic to determine the institution type
    if (college.control == 1) instituteType = @"Public";
    else if (college.control == 2) instituteType = @"Private";
    else instituteType  = @"N/A";
    institLabel.text = instituteType;
    
    //awesome acceptance rates
    accRateLabel.text = @"007%";
    
    //the following if statements display N/A's if there is no score for each text section
    if (college.act_english_25 <= 0 && college.act_english_75 <= 0) actRead.text = @"N/A";
    else actRead.text = [NSString stringWithFormat:@"%ld - %ld", (long)college.act_english_25, (long)college.act_english_75];
    
    if (college.act_math_25 <= 0 && college.act_math_75 <= 0) actMath.text = @"N/A";
    else actMath.text = [NSString stringWithFormat:@"%ld - %ld", (long)college.act_math_25, (long)college.act_math_75];
    
    if (college.act_writing_25 <= 0 && college.act_writing_75 <= 0) actWriting.text = @"N/A";
    else actWriting.text = [NSString stringWithFormat:@"%ld - %ld", (long)college.act_writing_25, (long)college.act_writing_75];
    
    if (college.act_25 <= 0 && college.act_75 <= 0) actComposite.text = @"N/A";
    else actComposite.text = [NSString stringWithFormat:@"%ld - %ld", (long)college.act_25, (long)college.act_75];
    
    if (college.sat_reading_25 <= 0 && college.sat_reading_75 <= 0) satRead.text = @"N/A";
    else satRead.text = [NSString stringWithFormat:@"%ld - %ld", (long)college.sat_reading_25, (long)college.sat_reading_75];
    
    if (college.sat_math_25 <= 0 && college.sat_math_75 <= 0) satMath.text = @"N/A";
    else satMath.text = [NSString stringWithFormat:@"%ld - %ld", (long)college.sat_math_25, (long)college.sat_math_75];
    
    if (college.sat_writing_25 <= 0 && college.sat_writing_75 <= 0) satWriting.text = @"N/A";
    else satWriting.text = [NSString stringWithFormat:@"%ld - %ld", (long)college.sat_writing_25, (long)college.sat_writing_75];
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

-(void)addToRecents:(MUITCollege*) college
{

        CCAppDelegate *appDelegate = (CCAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        NSInteger maxSizeOfRecents = 30;
        
        BOOL wasEqual = NO;
        
        
        
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"EEE, d MMM yyyy hh:mm:ss"];
        NSString *currentDateAndTime = [DateFormatter stringFromDate:[NSDate date]];
        
        
        self.representedCollege.dateAccessed = currentDateAndTime;
        
        
        NSInteger counter = [appDelegate.recentlyVisited count];
        
//        if (wasEqual == NO && counter < maxSizeOfRecents) {
//            [appDelegate.recentlyVisited insertObject:self.representedCollege atIndex:0];
//        }
//        else if (wasEqual == NO && counter >= maxSizeOfRecents)
//        {
//            [appDelegate.recentlyVisited removeObject:[appDelegate.recentlyVisited lastObject]];
//            [appDelegate.recentlyVisited insertObject:self.representedCollege atIndex:0];
//        }
    
    
    BOOL foundInArray = [self doesCollege:college ExistInArray:appDelegate.recentlyVisited];
    
    NSInteger arrayCount = [appDelegate.recentlyVisited count];
    
    
    if (foundInArray == YES) {
        
        if (arrayCount < maxSizeOfRecents) {
            [self removeCollege:college fromArray:appDelegate.recentlyVisited];
            [appDelegate.recentlyVisited insertObject:college atIndex:0];
        }
        else {
            [appDelegate.recentlyVisited removeObject:[appDelegate.recentlyVisited lastObject]];

            [appDelegate.recentlyVisited removeObject:college];
            [appDelegate.recentlyVisited insertObject:college atIndex:0];
        }
    
    }
    else if (foundInArray == NO){
        
        if (arrayCount <= 30) {
            [appDelegate.recentlyVisited insertObject:college atIndex:0];
        }
        else
        {
            [appDelegate.recentlyVisited removeLastObject];
            [appDelegate.recentlyVisited insertObject:college atIndex:0];
        }
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
    if (favorited == YES)
    {
        [sender setImage:unhighlightedStarImage forState:UIControlStateNormal];
        
        [favorites removeObject:self.representedCollege];
        
        favorited = NO;
    }
    else if (favorited == NO)
    {
        [sender setImage:highlightedStarImage forState:UIControlStateNormal];
        
        [favorites insertObject:self.representedCollege atIndex:0];
        
        favorited = YES;
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

-(MUITCollege*)doesCollegeExistInArray:(MUITCollege*) college
{    
    for (MUITCollege *myCollege in recents) {
        
        NSString *collegeName = myCollege.name;
        
        if ([collegeName isEqualToString:college.name]) {
            return myCollege;
        }
    }
    
    
    return nil;
}
-(BOOL)doesCollege:(MUITCollege*) theCollege ExistInArray:(NSMutableArray*) theArray
{
    NSInteger theID = theCollege.identifier;
    
    for (MUITCollege* college in theArray)
    {
        if (college.identifier == theID) {
            return YES;
        }
    }
    
    return NO;
}
-(void)removeCollege:(MUITCollege*) theCollege fromArray:(NSMutableArray*) theArray
{
    NSInteger collegeID = theCollege.identifier;
    
    MUITCollege *collegeToDelete;
    
    for (MUITCollege *college in theArray)
    {
        if (collegeID == college.identifier) {
            collegeToDelete = college;
        }
    }
    
    [theArray removeObject:collegeToDelete];
}
-(void)aestheticsConfiguration
{
    //  Main view
    
        //  Configure the title of the view controller which displays in the navigation bar
        //  If you don't want to override the default (which is the name of the college being displayed) then leave it set to nil
    
            NSString *viewControllerTitle               =   nil;
    
    
    //  Tableview
    
        //  Background color of the table view
        //  User will most likely not see this color unless they scroll down past the frame of the table view
        
            UIColor *tableViewBackgroundColor           =   [UIColor whiteColor];
    
    //  Labels configuration
    
        //  College label
    
            //  Font
    
                NSString *fontFamilyForCollegeLabel     =   @"Avenir-Book";
                float fontSizeForCollegeLabel           =   14.0;
    
            //  Text color
    
                UIColor *collegeLabelTextColor          =   [UIColor blackColor];
    
            //  Label background color
    
                UIColor *collegeLabelBackgroundColor    =   [UIColor yellowColor];
    
            //  Frame
    
                CGRect collegeLabelFrame                =   CGRectMake(0.0, 20.0, 320.0, 40.0);
    
            //  Other
    
                NSUInteger collegeLabelNumberOfLines    =   0.0; // Set the number of lines to 0 to unrestrict the number of lines the label will use.
    
        //  Other labels
    
            //  Font
    
                NSString *labelsFontFamily              =   @"Avenir-Book";
                float   labelsFontSize                  =   10.0;
    
            //  Text color
    
                UIColor *labelsTextColor                =   [UIColor blackColor];
    
/*------------DON'T MESS WITH ANYTHING BELOW THIS LINE UNLESS YOU'RE SURE YOU KNOW WHAT YOU'RE DOING----------------------*/
    
    
    
    self.tableView.backgroundColor = tableViewBackgroundColor;
    
    if (!viewControllerTitle) {
        if (self.representedCollege.name) {
            [self setTitle:self.representedCollege.name];
        }
        else
        {
            [self setTitle:@""];
        }
    }
    else
    {
        [self setTitle:viewControllerTitle];
    }
    
    //  College label configuration
    
    UIFont *collegeLabelFont = [UIFont fontWithName:fontFamilyForCollegeLabel size:fontSizeForCollegeLabel];
    [self.collegeLabel setFont:collegeLabelFont];
    [self.collegeLabel setTextColor:collegeLabelTextColor];
    [self.collegeLabel setBackgroundColor:collegeLabelBackgroundColor];
    [self.collegeLabel setFrame:collegeLabelFrame];
    [self.collegeLabel setNumberOfLines:collegeLabelNumberOfLines];
    
}
@end

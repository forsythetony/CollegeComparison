//
//  CCBookmarksPage.m
//  CollegeComparison
//
//  Created by Anthony Forsythe on 12/7/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CCBookmarksPage.h"
#import "CCAppDelegate.h"
#import "CCFavoriteSCell.h"
#import "SWRevealViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CCBookmarksPage () {
    NSMutableArray *tableViews;
    NSInteger currentTableView;
    NSMutableArray *recentItems, *favoriteItems;
    UIColor *coralColor, *blueColor;
    UIImage *starHighlighted, *starUnhighlighted;

}

@end

@implementation CCBookmarksPage

#pragma mark Initialization -
#pragma mark System

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
	[self slidingPanelSetup];
    // Do any additional setup after loading the view.
    [self getData];
    [self configureGlobalVariables];
    [self addTableViews];
    
    
    
    [tableViews[0] reloadData];

    [self configureNavigationBar];
    [self configureSegmentedControl];
    
    [self populateArrays];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self getData];
    [tableViews[0] reloadData];
    [tableViews[1] reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark Data Packaging
-(void)getData
{
    CCAppDelegate *appDelegate = (CCAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    recentItems = [NSMutableArray arrayWithArray:appDelegate.recentlyVisited] ;
    
    favoriteItems = [NSMutableArray arrayWithArray:appDelegate.bookmarked];
    
    
    
}
#pragma mark Custom Configuration
-(void)populateArrays
{
    self.favoritesArray = [NSMutableArray arrayWithObjects:@"University of Missouri", @"University of Mexico", @"University of Florida", nil];
    self.recentArray = [NSMutableArray arrayWithObjects:@"Recent 1", @"Recent Two", @"Recent Tres", nil];
}
-(void)configureNavigationBar
{

    self.title = @"Ucompare";
    
}
-(void)configureSegmentedControl
{
    [self.favoritesOrRect setTitle:@"Favorites" forSegmentAtIndex:0];
    [self.favoritesOrRect setTitle:@"Recent" forSegmentAtIndex:1];
    [self.favoritesOrRect setTintColor:coralColor];
    [self.favoritesOrRect setMomentary:NO];
    
    UIFont *fontForSegmentedControl = [UIFont fontWithName:@"Avenir-Book" size:13.0];
    
    NSDictionary *segmentedControlTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:fontForSegmentedControl, NSFontAttributeName, nil];
    
    [self.favoritesOrRect setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateNormal];

    
    [self.favoritesOrRect addTarget:self action:@selector(respondToSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)configureGlobalVariables
{
    //This is a coral color
    coralColor = [UIColor colorWithRed:205.0/255.0
                                 green:86.0/255.0
                                  blue:72.0/255.0
                                 alpha:1.0];
    //This is a blue color
    blueColor = [UIColor colorWithRed:113.0/255.0
                                green:173.0/255.0
                                 blue:237.0/255.0
                                alpha:1.0];
    starHighlighted = [UIImage imageNamed:@"highlighted_star.png"];
    starUnhighlighted = [UIImage imageNamed:@"unhighlighted_star.png"];
}

#pragma mark Tableview Configuration
-(void)addTableViews
{
    float heightOffset = 50.0;
    CGRect tableViewRect = CGRectMake(0.0, heightOffset, self.view.bounds.size.width, self.view.bounds.size.height - heightOffset);
    UITableView *tableViewFavorites = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    
    [tableViewFavorites setDataSource:self];
    [tableViewFavorites setDelegate:self];
    
    UITableView *recentTableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    [recentTableView setDataSource:self];
    [recentTableView setDelegate:self];
    
    [self.view addSubview:tableViewFavorites];
    [self.view addSubview:recentTableView];
    
    tableViews = [[NSMutableArray alloc] initWithObjects:tableViewFavorites, recentTableView, nil];
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (currentTableView == 0) {
        return [favoriteItems count];
    }
    else
    {
        return [recentItems count];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *favoritesIdentifier = @"favoritesCell";
    static NSString *recentsIdentifier = @"recentsCell";
    NSString *reuseIdentifier;
    
    if (currentTableView == 0) {
        reuseIdentifier = favoritesIdentifier;
    }
    else
    {
        reuseIdentifier = recentsIdentifier;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    cell = [self configureCell:cell andRow:indexPath.row];
    
    return cell;
}
-(CCFavoriteSCell*)ConfigurecellWithIndex:(NSInteger) indexOfCell
{
    
    CCFavoriteSCell *newCell = [CCFavoriteSCell new];
    
    [newCell.starButton setImage:starHighlighted forState:UIControlStateNormal];
    
    MUITCollege *college = [favoriteItems objectAtIndex:indexOfCell];
    
    newCell.collegeName.text = college.name;

        
    
    return newCell;
    // NSLog(@"Text label bounds: %@", NSStringFromCGRect(boundsForLabel));
    
}
#pragma mark Runtime -
-(void)respondToSegmentedControl:(UISegmentedControl*) sender
{
    NSInteger selectedItem = [sender selectedSegmentIndex];
    
    NSLog(@"\n\nSelected Segment is: %ld ", (long)selectedItem);
    
    UITableView *holderTableView = [tableViews objectAtIndex:selectedItem];
    
    [self.view bringSubviewToFront:holderTableView];
    
    currentTableView = selectedItem;
    
    for (UITableView *tableView in tableViews) {
        [tableView reloadData];
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger currentIndex = [self.favoritesOrRect selectedSegmentIndex];
    
    NSArray *ar1 = [NSArray new];
    
    MUITCollege *dummyCollege = [MUITCollege new];
    
    if (currentIndex == 0)
    {
        ar1 = favoriteItems;
        dummyCollege = [ar1 objectAtIndex:indexPath.row];
    }
    else
    {
        ar1 = recentItems;
        dummyCollege = [ar1 objectAtIndex:indexPath.row];
    }
    
    [self performSegueWithIdentifier:@"showCollegeDetailPageSegue" sender:dummyCollege];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CollegeDetailTableViewController *dest = (CollegeDetailTableViewController*)segue.destinationViewController;
    
    MUITCollege *theCollege = (MUITCollege*)sender;
    
    theCollege.pushedFromFavorites = YES;
    
    dest.representedCollege = theCollege;
    
    
}

-(void)handleStarClick:(UIBarButtonItem*) sender
{
    
    if ([tableViews[0] isEditing] == YES)
    {
        NSLog(@"Table view IS editing.");
    }
    else
    {
    NSLog(@"Tableview is NOT editing.");
    }
    
    if ([tableViews[0] isEditing] == NO) {
        [tableViews[0] setEditing:YES animated:YES];

    }
    
    
    if ([tableViews[0] isEditing] == YES)
    {
        NSLog(@"Table view SHOULD BE editing.");
    }
    else
    {
        NSLog(@"Tableview is NOT editing.");
    }

    
    
}
-(void)slidingPanelSetup
{
    //Set up panel view things
    
    
    _panelViewButton.target = self;
    _panelViewButton.action = @selector(panelPressed:);
    //Set the gesture
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
}
-(void)panelPressed:(id) sender
{
        
    [self.revealViewController rightRevealToggle:sender];
}
-(UITableViewCell*)configureCell:(UITableViewCell*) theCell andRow:(NSInteger) row
{
    MUITCollege *theCollege;
    
    [theCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [theCell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    if ([theCell.reuseIdentifier isEqualToString:@"favoritesCell"]) {
        
        //---Configure the font for the cell
        UIFont *cellTextFont = [UIFont fontWithName:@"Avenir-Book" size:15.0];
        [theCell.textLabel setFont:cellTextFont];
        
        UIFont *cellDetailTextFont = [UIFont fontWithName:@"Avenir-Book" size:11.0];
        [theCell.detailTextLabel setFont:cellDetailTextFont];
        
        theCollege = [favoriteItems objectAtIndex:row];
        [theCell.textLabel setText:theCollege.name];
        
    }
    else
    {
        
        //---Configure the font for the cell
        
        UIFont *recentsFont = [UIFont fontWithName:@"Avenir-Book" size:15.0];
        
        
        UIFont *recentsDetailFont = [UIFont fontWithName:@"Avenir-light" size:10.0];
        
        UIColor *detailsColor = UIColorFromRGB(0xF05746);
        
        [theCell.detailTextLabel setTextColor:detailsColor];
        [theCell.detailTextLabel setFont:recentsDetailFont];
        
        [theCell.textLabel setFont:recentsFont];
        
        
        
        
        theCollege = [recentItems objectAtIndex:row];
        [theCell.textLabel setText:theCollege.name];
        [theCell.detailTextLabel setText:theCollege.dateAccessed];
        
        
        
    }
    
    return theCell;
}

@end

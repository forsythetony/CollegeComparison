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
#define CORALCOLOR UIColorFromRGB(0xF05746)

@interface CCBookmarksPage () {
    NSMutableArray *tableViews;
    NSInteger currentTableView;
    NSMutableArray *recentItems, *favoriteItems;
    UIImage *starHighlighted, *starUnhighlighted;

    NSDictionary *theLook;
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
    
    [self getData];
    
    [self addTableViews];
    
    [self configureAesthetics];

    
    
    
    [tableViews[0] reloadData];

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
-(void)populateArrays
{
    self.favoritesArray = [NSMutableArray arrayWithObjects:@"University of Missouri", @"University of Mexico", @"University of Florida", nil];
    self.recentArray = [NSMutableArray arrayWithObjects:@"Recent 1", @"Recent Two", @"Recent Tres", nil];
}
-(void)configureSegmentedControl
{
    [self.favoritesOrRect setTitle:@"Favorites" forSegmentAtIndex:0];
    [self.favoritesOrRect setTitle:@"Recent" forSegmentAtIndex:1];
    [self.favoritesOrRect setTintColor:[theLook objectForKey:@"segColor"]];
    [self.favoritesOrRect setMomentary:NO];
    
    UIFont *fontForSegmentedControl = [theLook objectForKey:@"segFont"];
    
    NSDictionary *segmentedControlTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:fontForSegmentedControl, NSFontAttributeName, nil];
    
    [self.favoritesOrRect setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateNormal];

    
    [self.favoritesOrRect addTarget:self action:@selector(respondToSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
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
        
        [theCell setBackgroundColor:[theLook objectForKey:@"favBackground"]];
        
        //---Configure the font for the cell
        [theCell.textLabel setFont:[theLook objectForKey:@"favMainFont"]];
        [theCell.textLabel setTextColor:[theLook objectForKey:@"favMainColor"]];
        
        
        [theCell.detailTextLabel setFont:[theLook objectForKey:@"favDetailFont"]];
        [theCell.detailTextLabel setTextColor:[theLook objectForKey:@"favDetailColor"]];
        
        
        theCollege = [favoriteItems objectAtIndex:row];
        [theCell.textLabel setText:theCollege.name];
        
    }
    else
    {
        
        [theCell setBackgroundColor:[theLook objectForKey:@"recBackground"]];
        //---Configure the font for the cell
        
        [theCell.textLabel setFont:[theLook objectForKey:@"recMainFont"]];
        [theCell.textLabel setTextColor:[theLook objectForKey:@"recMainColor"]];
        
        [theCell.detailTextLabel setFont:[theLook objectForKey:@"recDetailFont"]];
        [theCell.detailTextLabel setTextColor:[theLook objectForKey:@"recDetailColor"]];
        
        
        theCollege = [recentItems objectAtIndex:row];
        [theCell.textLabel setText:theCollege.name];
        [theCell.detailTextLabel setText:theCollege.dateAccessed];
        
        
        
    }
    
    return theCell;
}
#pragma mark Custom Configuration
-(void)configureAesthetics
{
    //  Main view configuration
    
            UIColor *mainViewBackgroundColor        =   [UIColor whiteColor];
    
        //  Title of view controller that is displayed in the navigation bar. Set a value to override default.
    
            NSString *viewControllerTitle = @"Udecide";
    
    
    //  Segmented Control
    
        //  Tint
    
            UIColor *segmentedControlTint           =   CORALCOLOR;
    
        //  Font name and size
    
            NSString *segmentedControlFontName      =   @"Avenir-Book";
            float segmentedControlFontSize          =   13.0;
    
    
    //  Table view config
    
        UIColor *recentsTableViewBackgroundColor    =   [UIColor whiteColor];
    
        UIColor *favoritesTableViewBackgroundColor  =   [UIColor whiteColor];
    
    
        //  Recents cell config
    
            UIColor *recentsCellBackgroundColor     =   [UIColor clearColor];
    
    
            //  Main title label config
    
                NSString *recentsMainFontName       =   @"Avenir-Book";
                float recentsMainFontSize           =   15.0;
    
                UIColor *recentsCellMainTextColor   =   [UIColor blackColor];

            //  Detail label config
                NSString *recentsDetailFontName     =   @"Avenir-Book";
                float recentsDetailFontSize         =   10.0;
    
                UIColor *recentsCellDetailTextColor =   [UIColor blackColor];
    
        //  Favorites cell config
    
            UIColor *favoritesCellBackgroundColor   =   [UIColor clearColor];
    
    
            //  Main title label config
    
                NSString *favoritesMainFontName     =   @"Avenir-Book";
                float favoritesMainFontSize         =   15.0;
    
                UIColor *favoritesMainTextColor     =   [UIColor blackColor];
    
            //  Detail label config
    
                NSString *favoritesDetailFontName   =   @"Avenir-Book";
                float favoritesDetailFontSize       =   10.0;
                
                UIColor *favoritesDetailTextColor   =   [UIColor blackColor];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
/*------------DON'T MESS WITH ANYTHING BELOW THIS LINE UNLESS YOU'RE SURE YOU KNOW WHAT YOU'RE DOING----------------------*/

    UIFont *recentsMainFont = [UIFont fontWithName:recentsMainFontName size:recentsMainFontSize];
    UIFont *recentsDetailFont = [UIFont fontWithName:recentsDetailFontName size:recentsDetailFontSize];
    
    UIFont *favMainFont = [ UIFont fontWithName:favoritesMainFontName size:favoritesMainFontSize];
    UIFont *favDetailFont = [ UIFont fontWithName:favoritesDetailFontName size:favoritesDetailFontSize];
    
    UIFont *segContFont = [UIFont fontWithName:segmentedControlFontName size:segmentedControlFontSize];
    
    NSArray *theLookKeys = [NSArray arrayWithObjects:
                                                        @"segColor",
                                                        @"segFont",
                                                        @"recBackground",
                                                        @"recMainFont",
                                                        @"recMainColor",
                                                        @"recDetailFont",
                                                        @"recDetailColor",
                                                        @"favBackground",
                                                        @"favMainFont",
                                                        @"favMainColor",
                                                        @"favDetailFont",
                                                        @"favDetailColor", nil];
    
    NSArray *theLookObjects = [NSArray arrayWithObjects:
                                                           segmentedControlTint,
                                                           segContFont,
                                                           recentsCellBackgroundColor,
                                                           recentsMainFont,
                                                           recentsCellMainTextColor,
                                                           recentsDetailFont,
                                                           recentsCellDetailTextColor,
                                                           favoritesCellBackgroundColor,
                                                           favMainFont,
                                                           favoritesMainTextColor,
                                                           favDetailFont,
                                                           favoritesDetailTextColor, nil];
    
    theLook = [NSDictionary dictionaryWithObjects:theLookObjects forKeys:theLookKeys];
    
    
    [self.view setBackgroundColor:mainViewBackgroundColor];
    [tableViews[0] setBackgroundColor:favoritesTableViewBackgroundColor];
    [tableViews[1] setBackgroundColor:recentsTableViewBackgroundColor];
    [self setTitle:viewControllerTitle];
    
    
}

@end

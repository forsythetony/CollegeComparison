//
//  CCBookmarksPage.m
//  CollegeComparison
//
//  Created by Anthony Forsythe on 12/7/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CCBookmarksPage.h"
#import "CCAppDelegate.h"

@interface CCBookmarksPage () {
    NSMutableArray *tableViews;
    NSInteger currentTableView;
    NSMutableArray *recentItems;
    
}

@end

@implementation CCBookmarksPage

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
	// Do any additional setup after loading the view.
    
    
    
    [tableViews[0] reloadData];
    [self getData];

    [self configureNavigationBar];
    [self configureSegmentedControl];
    [self addTableViews];
    [self populateArrays];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)populateArrays
{
    self.favoritesArray = [NSMutableArray arrayWithObjects:@"University of Miissouri", @"University of Mexico", @"University of Florida", nil];
    self.recentArray = [NSMutableArray arrayWithObjects:@"Recent 1", @"Recent Two", @"Recent Tres", nil];
}
-(void)configureNavigationBar
{
    UIFont *navBarFont = [UIFont fontWithName:@"Avenir-Book" size:14.0];
    
    NSDictionary *textAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:navBarFont, @"UITextAttributeFont", nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    
    self.title = @"Udecide";
    
}
-(void)configureSegmentedControl
{
    [self.favoritesOrRect setTitle:@"Favorites" forSegmentAtIndex:0];
    [self.favoritesOrRect setTitle:@"Recent" forSegmentAtIndex:1];
    [self.favoritesOrRect setTintColor:[UIColor redColor]];
    [self.favoritesOrRect setMomentary:NO];
    
    UIFont *fontForSegmentedControl = [UIFont fontWithName:@"Avenir-Book" size:13.0];
    
    NSDictionary *segmentedControlTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:fontForSegmentedControl, NSFontAttributeName, nil];
    
    [self.favoritesOrRect setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateNormal];

    
    [self.favoritesOrRect addTarget:self action:@selector(respondToSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
}

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


-(void)addTableViews
{
    float heightOffset = 50.0;
    CGRect tableViewRect = CGRectMake(0.0, heightOffset, self.view.bounds.size.width, self.view.bounds.size.height - heightOffset);
    UITableView *tableViewFavorites = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    
    [tableViewFavorites setBackgroundColor:[UIColor redColor]];
    [tableViewFavorites setDataSource:self];
    
    UITableView *recentTableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    [recentTableView setDataSource:self];
    
    [recentTableView setBackgroundColor:[UIColor greenColor]];
    
    [self.view addSubview:tableViewFavorites];
    [self.view addSubview:recentTableView];
    
    tableViews = [[NSMutableArray alloc] initWithObjects:tableViewFavorites, recentTableView, nil];
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (currentTableView == 0) {
        return [self.favoritesArray count];
    }
    else
    {
        return [recentItems count];
    }
        
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     [self getData];
    
    static NSString *cellIdentifier = @"Cell";
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
       }
    
    NSString *collegeName = [NSString new];
    if (currentTableView == 0) {
        collegeName = [self.favoritesArray objectAtIndex:indexPath.row];
    }
    else
    {
        MUITCollege *theCollege = [recentItems objectAtIndex:indexPath.row];
        
        
        
        collegeName = theCollege.name;
    }
    
    [cell.textLabel setText:collegeName];
    [cell.detailTextLabel setText:@"by Tony"];
    return cell;
}

-(void)getData
{
    CCAppDelegate *appDelegate = (CCAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    recentItems = appDelegate.recentlyVisited;
}
@end

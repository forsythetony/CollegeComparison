//
//  CCPanelViewViewController.m
//  CollegeComparison
//
//  Created by Anthony Forsythe on 1/11/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import "CCPanelViewViewController.h"
#import "SWRevealViewController.h"

#define CORALCOLOR [UIColor colorWithRed:207.0/255.0 green:103.0/255.0 blue:65.0/255.0 alpha:1.0]
#define SECTIONHEADERHEIGHT 30.0
#define WIDTHOFPANEL 200.0

#define CORAL [UIColor colorWithRed:205.0/255.0 green:86.0/255.0 blue:72.0/255.0 alpha:1.0];

@interface CCPanelViewViewController () {
    UIImageView *syncImage;
    BOOL animating;
}

@property (nonatomic, strong) NSArray *menuItems;

@end

@implementation CCPanelViewViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pixel_weave.png"]];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    
    //self.revealViewController.rearViewRevealWidth = WIDTHOFPANEL;
    
    _menuItems = @[@"Home", @"Bookmarks", @"Settings", @"sync"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Table view data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems
                                objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    cell = [self configureCell:cell
                WithIdentifier:CellIdentifier];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return SECTIONHEADERHEIGHT;
            break;
            
        default:
            return 20.0;
            break;
    }
}
#pragma mark Configure Cell -
-(UITableViewCell*)configureCell:(UITableViewCell*) theCell WithIdentifier:(NSString*) name
{
    
    if ([name isEqualToString:@"sync"]) {
        return [self configureSyncCell:theCell];
    }
    
    //Configure 'global' variables
    UIFont *titleFont = [UIFont
                         fontWithName:@"Avenir-Book"
                         size:20.0];
    UIColor *backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    
    UIColor *textColor = CORALCOLOR;
    
    //Find cell properties
    float heightOfCell = theCell.contentView.bounds.size.height;
    
    //Create title
    float heightOfTitle = 30.0;
    float bottomPadding = 3.0;
    float leftPadding = 40.0;
    
    CGRect titleFrame;
    
    titleFrame.origin.x = leftPadding;
    titleFrame.origin.y = heightOfCell - heightOfTitle - bottomPadding;
    titleFrame.size.width = 200.0;
    titleFrame.size.height = heightOfTitle;
    
    //Create actual label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    
    //Configure label text
    [titleLabel setText:name];
    
    //Configure label properties
    [titleLabel setTextColor:textColor];
    [titleLabel setFont:titleFont];
    
    //Configure cell properties
    [theCell.contentView setBackgroundColor:backgroundColor];
    theCell.selectionStyle = UITableViewCellEditingStyleNone;
    
    //Add subviews
    [theCell.contentView addSubview:titleLabel];
    
    //RETURN IT NOW
    return theCell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    //Configure 'global' variables
    UIFont *titleFont = [UIFont
                         fontWithName:@"Avenir-Heavy"
                         size:20.0];
    
    UIColor *titleTextColor = CORALCOLOR;
    UIColor *headerBackgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    
    
    
    
    
    if (section == 0) {
        //Create rect for view
        CGRect headerFrame;
        headerFrame.origin.x = 0.0;
        headerFrame.origin.y = 0.0;
        headerFrame.size.width = tableView.bounds.size.width;
        headerFrame.size.height = SECTIONHEADERHEIGHT;
        
        //Create actual view
        
        UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
        
        [headerView setBackgroundColor:headerBackgroundColor];
        
        
        //Create label
        
        float leftPadding = 10.0;
        float bottomPadding = -3.0;
        float titleHeight = 30.0;
        
        
        CGRect labelFrame;
        
        labelFrame.origin.x = leftPadding;
        labelFrame.origin.y = SECTIONHEADERHEIGHT - titleHeight - bottomPadding;
        labelFrame.size.width = 200.0;
        labelFrame.size.height = titleHeight;
        
        //Instantiate title label
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:labelFrame];
        
        //Configure text of title label
        [titleLabel setText:@"Menu"];
        
        //Configure properties of title label
        [titleLabel setFont:titleFont];
        [titleLabel setTextColor:titleTextColor];
        
        
        
        [headerView addSubview:titleLabel];

        return headerView;
        
        
    }
    
    
    return nil;
}

#pragma mark Respond to User -
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    //Use proper segue based on what cell was clicked
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}
-(UITableViewCell*)configureSyncCell:(UITableViewCell*) cell
{
    
    [cell.contentView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:1.0]];
    //Create button frame
    float widthOfButton = 100.0;
    float topPadding = 5.0;
    
    CGRect buttonFrame;
    
    buttonFrame.origin.x = (WIDTHOFPANEL / 2) - (widthOfButton / 2);
    buttonFrame.origin.y = topPadding;
    buttonFrame.size.width = widthOfButton;
    buttonFrame.size.height = 20.0;
    
    //Instant button
    UIButton *syncButton = [[UIButton alloc] initWithFrame:buttonFrame];
    
    //Configure button
    syncButton.layer.cornerRadius = 8.0;
    [syncButton setTitle:@"update" forState:UIControlStateNormal];
    [syncButton setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:103.0/255.0 blue:65.0/255.0 alpha:0.8]];
    [syncButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:14.0]];
    [syncButton.titleLabel setTextColor:[UIColor whiteColor]];
    
    
    //Add as subview
    [cell.contentView addSubview:syncButton];
    
    //Configure sync image
   // float syncImageLeftPadding = 0.0;
    CGRect syncFrame;
    syncFrame.origin.x = 0.0;
    syncFrame.origin.y = topPadding;
    syncFrame.size.width = 20.0;
    syncFrame.size.width = 20.0;
    
    syncImage = [[ UIImageView alloc] initWithImage:[UIImage imageNamed:@"sync_image.png"]];
    
    [syncImage setFrame:CGRectMake(widthOfButton - 25.0, 3.0, 15.0, 15.0)];
    
    //Configure button target
    [syncButton addTarget:self action:@selector(startSpin) forControlEvents:UIControlEventTouchUpInside];
    [syncButton addSubview:syncImage];
    
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 30.0;
    }
    else
    {
        return 40.0;
    }
}

- (void) startSpin {
    if (!animating || animating == NO) {
        animating = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveLinear];
    }
    else {
        [self stopSpin];
    }
}
- (void) spinWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.5f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         syncImage.transform = CGAffineTransformRotate(syncImage.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}
- (void) stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    animating = NO;
}
@end

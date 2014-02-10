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
#define WIDTHOFPANEL 150.0
#define LEFTPADDINGFORTABLECELLS 43.0

#define CORAL [UIColor colorWithRed:205.0/255.0 green:86.0/255.0 blue:72.0/255.0 alpha:1.0];

typedef struct paddingInfo {
    float leftPadding;
    float bottomPadding;
    float width;
    float height;
} paddingInfo;

@interface CCPanelViewViewController () {
    UIImageView *syncImage;
    BOOL animating;
    
    UIColor *pViewBackground, *pViewHeaderBackground, *pCellBackground, *pCellText, *pViewHeaderText, *cLabelBackgroundColor, *hLabelBackgroundColor;
    
    UIFont *pViewHeader, *pViewCell;
    
    NSDictionary *theLook;
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
    [self aestheticsConfiguration];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pixel_weave.png"]];
//    self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    self.tableView.separatorColor = [UIColor yellowColor];
    
    _menuItems = @[@"Home", @"Bookmarks", @"Settings"];
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
    //Find cell properties
    float heightOfCell = theCell.contentView.bounds.size.height;
    
    CGRect cellPadding = [[padding objectForKey:@"cPadding"] CGRectValue];
    
    CGRect titleFrame;
    
    titleFrame.origin.x = cellPadding.origin.x + LEFTPADDINGFORTABLECELLS;
    titleFrame.origin.y = heightOfCell - cellPadding.size.height - cellPadding.origin.y;
    titleFrame.size.width = cellPadding.size.width;
    titleFrame.size.height = cellPadding.size.height;
    
    //Create actual label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    
    //Configure label text
    [titleLabel setText:name];
    
    //Configure label properties
    [titleLabel setTextColor:pCellText];
    [titleLabel setFont:pViewCell];
    
    //Configure cell properties
    [theCell.contentView setBackgroundColor:pCellBackground];
    //theCell.selectionStyle = UITableViewCellEditingStyleNone;
    
    //Add subviews
    [theCell.contentView addSubview:titleLabel];
    
    //RETURN IT NOW
    return theCell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        //Create rect for view
        CGRect headerFrame;
        headerFrame.origin.x = LEFTPADDINGFORTABLECELLS;
        headerFrame.origin.y = 0.0;
        headerFrame.size.width = tableView.bounds.size.width;
        headerFrame.size.height = SECTIONHEADERHEIGHT;
        
        //Create actual view
        
        UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
        
        [headerView setBackgroundColor:pViewHeaderBackground];
        
        CGRect headerPadding = [[padding objectForKey:@"hPadding"] CGRectValue];
        
        //Create label
        CGRect labelFrame;
        
        labelFrame.origin.x = LEFTPADDINGFORTABLECELLS + ((WIDTHOFPANEL / 2) - (headerPadding.size.width/2));
        labelFrame.origin.y = SECTIONHEADERHEIGHT - headerPadding.size.height - headerPadding.origin.y;
        labelFrame.size.width = headerPadding.size.width;
        labelFrame.size.height = headerPadding.size.height;
        
        
        //Instantiate title label
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:labelFrame];

        //Configure text of title label
        [titleLabel setText:@"Menu"];
        
        //Configure properties of title label
        [titleLabel setFont:pViewHeader];
        [titleLabel setTextColor:pViewHeaderText];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        
        
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
            [self.revealViewController setFrontViewPosition: FrontViewPositionRightMost animated: NO];
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
    
    buttonFrame.origin.x = (WIDTHOFPANEL / 2) - (widthOfButton / 2) + LEFTPADDINGFORTABLECELLS;
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
-(void)aestheticsConfiguration
{
    //Panel view background configuration.

        UIColor *panelViewBackgroundColor   =   [UIColor colorWithPatternImage:[UIImage imageNamed:@"pixel_weave.png"]];
    
    //The color for the seperator lines between cells
    
        UIColor *seperatorLineColor         =   [UIColor black50PercentColor];
    
    //Panel View Header Configuration
    
        UIColor *headerViewBackgroundColor  =   [UIColor colorWithWhite:0.15 alpha:1.0];
    
        UIColor *headerLabelBackgroundColor =   [UIColor yellowColor];
    
        UIColor *colorForHeaderText         =   CORALCOLOR;
    
        NSString *fontNameForHeaderText     =   @"Avenir-Heavy";
        float fontSizeForHeaderText         =   20.0;
    
        //Configure padding for header label
    
    
    //Panel view cell configuration
    
        UIColor *cellBackgroundColor        =   [UIColor colorWithWhite:0.2 alpha:1.0];
    
        UIColor *cellLabelBackgroundColor   =   [UIColor yellowColor];
    
        UIColor *colorForCellText           =   CORALCOLOR;
    
        NSString *fontNameForCellText       =   @"Avenir-Heavy";
        float fontSizeForCellText           =   20.0;
    
        //Configure padding for header and cell
    
        float headerLeftPadding             =   5.0;
        float headerBottomPadding           =   -3.0;
        float headerWidth                   =   200.0;
        float headerHeight                  =   30.0;
        
        float cellLeftPadding               =   7.0;
        float cellBottomPadding             =   7.0;
        float cellWidth                     =   200.0;
        float cellHeight                    =   30.0;
    
    //Panel view configuration
    
        //Set the width of the panel
    
        float panelWidth                    =   150.0;
    
        //Set the Displacement
    
        float panelDisplacement             =   0.0;
    
        //Set the overdraw
    
        float panelOverdraw                 =   40.0;
    
        //Set the time duration (in seconds) for the toggle close animation
    
        float toggleCloseAnimationDuration  =   0.18;
    
        //Should the panel bounce back on left overdraw?
    
        BOOL bounceBackOnLeftOverdraw = NO;
    
    

    
    
    
    NSArray *colorsKeys = [NSArray arrayWithObjects:
                                                   @"pViewBackground",
                                                   @"pViewLines",
                                                   @"hBackground",
                                                   @"hText",
                                                   @"hFont",
                                                   @"hLabelBackground",
                                                   @"cBackground",
                                                   @"cText",
                                                   @"cFont",
                                                   @"cLabelBackground", nil];

    NSArray *colorsObjects = [NSArray arrayWithObjects:
                                                      panelViewBackgroundColor,
                                                      seperatorLineColor,
                                                      headerViewBackgroundColor,
                                                      colorForHeaderText,
                                                      [UIFont fontWithName:fontNameForHeaderText size:fontSizeForHeaderText],
                                                      headerLabelBackgroundColor,
                                                      cellBackgroundColor,
                                                      colorForCellText,
                                                      [UIFont fontWithName:fontNameForCellText size:fontSizeForCellText],
                                                      cellLabelBackgroundColor, nil];
    
    
    CGRect cPad = CGRectMake(cellLeftPadding, cellBottomPadding, cellWidth, cellHeight);
    
    CGRect hPad = CGRectMake(headerLeftPadding, headerBottomPadding, headerWidth, headerHeight);

    NSDictionary *colorsDictionary = [NSDictionary dictionaryWithObjects:colorsObjects forKeys:colorsKeys];
    
    NSDictionary *paddingDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                   [NSValue valueWithCGRect:cPad],
                                                                                   @"cPadding",
                                                                                   [NSValue valueWithCGRect:hPad],
                                                                                   @"hPadding", nil];
    
    theLook = [NSDictionary dictionaryWithObjectsAndKeys:
                                                           colorsDictionary,
                                                           @"colors",
                                                           paddingDictionary,
                                                           @"padding", nil];
    
    [self.revealViewController setRightViewController:self];
    self.revealViewController.rightViewRevealWidth = panelWidth;
    
    self.revealViewController.rightViewRevealDisplacement = panelDisplacement;
    self.revealViewController.rightViewRevealOverdraw = panelOverdraw;
    self.revealViewController.bounceBackOnLeftOverdraw = bounceBackOnLeftOverdraw;
    self.revealViewController.toggleCloseAnimationDuration = toggleCloseAnimationDuration;
    
    
}
@end

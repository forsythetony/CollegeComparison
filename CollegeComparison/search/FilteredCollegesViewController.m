//
//  FilteredCollegesViewController.m
//  CollegeComparison
//
//  Created by Josh Valdivieso on 12/1/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "FilteredCollegesViewController.h"
#import "CCAppDelegate.h"

#define MAXNUMBEROFCOLLEGESTOCOMPARE 3
#define MINNUMBEROFCOLLEGESTOCOMPARE 2

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define MY_DELEGATE (CCAppDelegate*)[[UIApplication sharedApplication] delegate]


@interface FilteredCollegesViewController (){
    NSMutableArray *collegesImGoingToCompare;
    NSMutableArray *selectedColleges;
    
    UIFont *cellNameFont, *cellLocationFont, *headerViewFont;
    UIColor *cellNameTextColor, *cellLocationTextColor, *headerViewBackgroundColor, *headerViewTextColor, *colorForBookmarkButton, *colorForCompareButton, *headerViewLabelBackgroundColor, *tableViewCellBackgroundColor, *tableViewCellSelectedColor;
    
    NSTextAlignment alignmentForHeaderLabelText;
}

@end

@implementation FilteredCollegesViewController

NSArray *searchResults;

- (void)viewDidLoad
{
    //Configure visual properties
    [self aestheticsConfiguration];
    
    selectedColleges = [NSMutableArray new];
    
    collegesImGoingToCompare = [NSMutableArray new];
    NSMutableDictionary *options = [NSMutableDictionary new];
    MUITCollegeDataProvider *collegeManager = [MUITCollegeDataProvider new];
    
    self.collegesToCompare = [[NSMutableArray alloc] init];
    self.storedSchoolsDictionary = [[NSMutableDictionary alloc] init];
    
    //Data from college data provider object. If database is not working properly 3 dummy colleges will be returned
    NSArray *collegesPassed = [collegeManager getColleges:options];
    
    if ([collegesPassed count] == 0) {
        collegesPassed = [collegeManager getDummyColleges];
    }
    
    self.universitiesPassed = collegesPassed;
    
    
    
    // Set custom attributes for navigation bar
    [self setCustomAttributesForNavigationBar];
    
    self.compareButton = [[UIBarButtonItem alloc] initWithTitle:@"Compare"
                                                          style:UIBarButtonItemStyleBordered
                                                         target:self
                                                         action:@selector(selectCollegesToCompare:)];

    self.compareButton.tintColor = [UIColor whiteColor];
    
    self.compareButton.enabled = NO;
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                         style:UIBarButtonItemStyleBordered
                                                        target:self
                                                        action:@selector(cancelButton:)];
 
    self.cancelButton.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setRightBarButtonItem:self.compareButton];

    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self resetTableView];
}

#pragma  mark - UINavigationBar attributes

-(void)setCustomAttributesForNavigationBar
{
    self.navigationItem.title = @"Results";
}

// Select two universites to compare
- (void)selectButton:(id)sender
{
    [self.navigationItem setRightBarButtonItem:self.cancelButton animated:YES];
    
    [self.navigationItem setLeftBarButtonItem:self.compareButton animated:YES];
    
    self.compareButton.title = @"Compare";
    
    [self.tableView setEditing:YES animated:YES];
}
// Go back to main table view
- (void) cancelButton:(id)sender
{
    [self.tableView setEditing:NO animated:YES];
    
    [self.navigationItem setRightBarButtonItem:self.selectButton];
    
    // Make all visible cells interactable
    for (int row = 0; row < [self.tableView numberOfRowsInSection:0]; row++)
    {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row
                                                   inSection:0];
        
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:cellPath];
        
        cell.alpha = 1.0;
        
        cell.userInteractionEnabled = YES;
    }
    
    [self.collegesToCompare removeAllObjects];
    
    // Retrieve the back button
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Table view header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Get the number of colleges returned
    NSUInteger collegesReturned = self.universitiesPassed.count;
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
    
    [tableHeaderView setBackgroundColor:headerViewBackgroundColor];
    
    
    // Label properties for custon UIView
    UILabel *labelInHeaderView = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 320.0f, 40.0f)];
    
    labelInHeaderView.textAlignment = alignmentForHeaderLabelText;
    
    [labelInHeaderView setBackgroundColor:headerViewLabelBackgroundColor];
    
    [labelInHeaderView setTextColor:headerViewTextColor];
    
    labelInHeaderView.font = headerViewFont;
    
    labelInHeaderView.text = [[NSString stringWithFormat:@"%lu", (unsigned long)collegesReturned] stringByAppendingString:@" COLLEGES RETURNED"];
    
    // Add label to the view
    [tableHeaderView addSubview:labelInHeaderView];
    
    return tableHeaderView;
}

// Table view header height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return self.universitiesPassed.count;
        
    }
}

// Tableview cell creation
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"MyCustomCell";
    
    CollegeSearchCell *cell = (CollegeSearchCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                           forIndexPath:indexPath];
    __weak CollegeSearchCell *weakCell = cell;
    
    //Do any fixed setup here (will be executed once unless force is set to YES)
    [cell setAppearanceWithBlock:^{
        cell.containingTableView = tableView;
        
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:colorForBookmarkButton title:@"Bookmark"];
        [rightUtilityButtons sw_addUtilityButtonWithColor:colorForCompareButton title:@"Compare"];
        
        cell.rightUtilityButtons = rightUtilityButtons;
        
        
        cell.delegate = self;
    } force:NO];
    
    
    //Configure the cell with college information
    
    MUITCollege *college = [self.universitiesPassed objectAtIndex:indexPath.row];
    
    NSString *collegeName = [NSString stringWithString:college.name];
    NSString *collegeLocation = [NSString stringWithFormat:@"%@, %@", @"SomeCity", college.state];
    
    //Set the cells labels
    [cell.name setText:collegeName];
    [cell.location setText:collegeLocation];
    
    //Configure colors
    cell.backgroundColor = tableViewCellBackgroundColor;
    [cell.selectedBackgroundView setBackgroundColor:tableViewCellSelectedColor];
    
    //Configure fonts for labels
    [cell.name setFont:cellNameFont];
    [cell.location setFont:cellLocationFont];
    
    [cell.name setTextColor:cellNameTextColor];
    [cell.location setTextColor:cellLocationTextColor];
    
    cell.tag = indexPath.row;
    
    [cell setCellHeight:cell.frame.size.height];
    
    return cell;
}

#pragma mark - Table View Delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    
    if(selectedRows.count == MAXNUMBEROFCOLLEGESTOCOMPARE)
    {
        return nil;
    } else {
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showCollegeDetailSegue" sender:self];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing && tableView.indexPathsForSelectedRows.count == MAXNUMBEROFCOLLEGESTOCOMPARE)
        ((FilteredCollegesTableViewCell *)cell).enabled = [[tableView indexPathsForSelectedRows] containsObject:indexPath];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"collegeDetailsSegue"]) {
        CollegeDetailTableViewController *destViewController = segue.destinationViewController;

        // instead of passing a college name, pass an MUITCollege object.
        NSIndexPath *tappedPath =  [self.tableView indexPathForSelectedRow]; //get the index path of the row the user tapped
        MUITCollege *tappedCollege = [self.universitiesPassed objectAtIndex:tappedPath.row];  //get the college at the row the user tapped
        destViewController.representedCollege = tappedCollege;
    }

    else if ([segue.identifier isEqualToString:@"showCollegeDetailSegue"]) {
        CollegeDetailTableViewController *destViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = nil;
        
        
        if ([self.searchDisplayController isActive]) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            //            instead of passing a college name, pass an MUITCollege object.
            NSIndexPath *tappedPath =  [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow]; //get the index path of the row the user tapped
            MUITCollege *tappedCollege = [searchResults objectAtIndex:tappedPath.row];  //get the college at the row the user tapped
            destViewController.representedCollege = tappedCollege;
        } else {
            //            instead of passing a college name, pass an MUITCollege object.
            NSIndexPath *tappedPath =  [self.tableView indexPathForSelectedRow]; //get the index path of the row the user tapped
            MUITCollege *tappedCollege = [self.universitiesPassed objectAtIndex:tappedPath.row];  //get the college at the row the user tapped
            destViewController.representedCollege = tappedCollege;
        }

    }
    else if ([segue.identifier isEqualToString:@"comparisonSegue"])
    {
        CCAnimationPageViewController *destViewController = (CCAnimationPageViewController*)segue.destinationViewController;
        
        destViewController.twoColleges = [NSArray arrayWithArray:collegesImGoingToCompare];


    }
    
    else if ([segue.identifier isEqualToString:@"comparisonSegueOne"])
    {
        CCAnimationPageViewController *destViewController = (CCAnimationPageViewController*)segue.destinationViewController;
        
        destViewController.twoColleges = [NSArray arrayWithArray:collegesImGoingToCompare];
    }
}

- (void)selectCollegesToCompare:(id)sender
 {

     if([self.title isEqual:@"filteredSchools"])
     {
         [self performSegueWithIdentifier:@"comparisonSegue" sender:self];
     }
     else if ([self.title isEqual:@"schools"])
     {
         [self performSegueWithIdentifier:@"comparisonSegueOne" sender:self];
     }
 }

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"name contains[cd] %@",
                                    searchText];
    
    searchResults = [self.universitiesPassed filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
-(void)resetTableView
{
    [self.tableView setEditing:NO animated:NO];
    [self.collegesToCompare removeAllObjects];
    [collegesImGoingToCompare removeAllObjects];
    [self.navigationItem setRightBarButtonItem:self.compareButton];
    [self.compareButton setEnabled:NO];
    [self.navigationItem setLeftBarButtonItem:nil];
    [self resetColleges];
}
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    cell = (CollegeSearchCell*)cell;
    
    
    if (index == 0) {
        if (cell.selected == NO) {
            [cell setSelected:YES];
            [collegesImGoingToCompare addObject:[self.universitiesPassed objectAtIndex:cell.tag]];
            [selectedColleges addObject:cell];
            
        }
        else
        {
            [cell setSelected:NO];
            [collegesImGoingToCompare removeObject:[self.universitiesPassed objectAtIndex:cell.tag]];
            
        }
        
        
        [cell hideUtilityButtonsAnimated:YES];
    
        NSInteger count = [collegesImGoingToCompare count];
        
        if (count >= MINNUMBEROFCOLLEGESTOCOMPARE) {
            [self.compareButton setEnabled:YES];
        }
        else
        {
            [self.compareButton setEnabled:NO];
        }
    }
}
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    cell = (CollegeSearchCell*)cell;
    
    if (index == 1) {
        if (cell.selected == NO) {
            [cell setSelected:YES];
            [collegesImGoingToCompare addObject:[self.universitiesPassed objectAtIndex:cell.tag]];
            [selectedColleges addObject:cell];
            
        }
        else
        {
            [cell setSelected:NO];
            [collegesImGoingToCompare removeObject:[self.universitiesPassed objectAtIndex:cell.tag]];
            
        }
        
        
        [cell hideUtilityButtonsAnimated:YES];
        
        NSInteger count = [collegesImGoingToCompare count];
        
        if (count >= MINNUMBEROFCOLLEGESTOCOMPARE) {
            [self.compareButton setEnabled:YES];
        }
        else
        {
            [self.compareButton setEnabled:NO];
        }
    }
    else if (index == 0)
    {
        NSUInteger indexOfCollege = cell.tag;
        
        MUITCollege *collegeToBookmark = [self.universitiesPassed objectAtIndex:indexOfCollege];
        
        BOOL wasThere = [self bookmarkCollege:collegeToBookmark];
        
        [self createBookmarkAlertViewWithCollege:collegeToBookmark andPresent:wasThere];
        
        [cell hideUtilityButtonsAnimated:YES];
    }
}
-(void)resetColleges
{
    for (CollegeSearchCell* cell in selectedColleges) {
        [cell setSelected:NO];
    }
}
-(void)hideOtherUtilityBarsWithCell:(SWTableViewCell*) theCell
{
    
}
-(void)aestheticsConfiguration
{
/*
    Use the functions below to configure the fonts for this view controller
    You can find the list of iOS supported fonts at iosfonts.com
    Always enter names as NSStrings meaning that it should be in the format @"NAMEOFFONT" with the @ sign and quotations
    You can also modify the text color
*/
    //Table cell configuration
    
        //Configure background properties for cell
        UIColor *cellBackgroundColor            =   [UIColor antiqueWhiteColor];
        UIColor *cellSelectedBackgroundColor    =   [UIColor grayColor];
    
        //Font for college name label for cells in table view
    
        NSString *fontNameForNameLabel          =   @"Avenir-Book";
        float sizeOfNameFont                    =   14.0;
    
        UIColor *colorForNameLabelText          =   [UIColor black25PercentColor];
    
    
        //Font for college location label for cells in table view
    
        NSString *fontNameForLocationLabel      =   @"Avenir-Book";
        float sizeOfLocationFont                =   14.0;
    
        UIColor *colorForLocationLabelText      =   [UIColor black25PercentColor];
    
    
    //Font for the header view that display number of colleges returned
    
        NSString *fontnameForHeaderView         =   @"Avenir-Book";
        float sizeOfHeaderFont                  =   14.0;
    
        UIColor *colorForHeaderViewText         =   [UIColor black25PercentColor];
        UIColor *colorForHeaderViewBackground   =   [UIColor antiqueWhiteColor];
        UIColor *colorForHeaderLabelBackground  =   [UIColor antiqueWhiteColor];
    
        //Here you can set the alignment for the header label
    
        alignmentForHeaderLabelText             =   NSTextAlignmentLeft;
    
    //Colors for right utility buttons (compare and bookmark)
    
        UIColor *colorForBookmarkUtilityButton  =   [UIColor denimColor];
        UIColor *colorForCompareUtilityButton   =   UIColorFromRGB(0xF05746); //This is a coral color
    
    
    
    //These functions down here are used to take the values set above and apply them
    tableViewCellBackgroundColor = cellBackgroundColor;
    tableViewCellSelectedColor = cellSelectedBackgroundColor;
    
    cellNameFont = [UIFont fontWithName:fontNameForNameLabel size:sizeOfNameFont];
    cellNameTextColor = colorForNameLabelText;
    
    
    cellLocationFont = [UIFont fontWithName:fontNameForLocationLabel size:sizeOfLocationFont];
    cellLocationTextColor = colorForLocationLabelText;
    
    headerViewFont = [UIFont fontWithName:fontnameForHeaderView size:sizeOfHeaderFont];
    headerViewTextColor = colorForHeaderViewText;
    headerViewBackgroundColor = colorForHeaderViewBackground;
    headerViewLabelBackgroundColor = colorForHeaderLabelBackground;
    
    colorForBookmarkButton = colorForBookmarkUtilityButton;
    colorForCompareButton = colorForCompareUtilityButton;
    
}
-(BOOL)bookmarkCollege:(MUITCollege*) college
{
    NSMutableArray *bookmarked = (NSMutableArray*)[MY_DELEGATE bookmarked];

    //Check if college already exists in array
    
    
    for (MUITCollege *theCollege in bookmarked) {
        if (theCollege.identifier == college.identifier) {
            [bookmarked removeObject:theCollege];
            [bookmarked insertObject:college atIndex:0];
            
            return YES;
        }
    }
    
    [bookmarked insertObject:college atIndex:0];
    
    return NO;
}
-(void)createBookmarkAlertViewWithCollege:(MUITCollege*) college andPresent:(BOOL) wasThere
{
    NSString *message = [NSString new];
    NSString *title = [NSString new];
    
    if (wasThere) {
        title = @"Ya Dope";
        message = [NSString stringWithFormat:@"%@ is already bookmarked!", college.name];
    }
    else
    {
        title = @"Bookmarked!";
        message = [NSString stringWithFormat:@"%@ has been bookmarked!", college.name];
    }
    
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:message];
    
    [alertView addButtonWithTitle:@"Ok"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              NSLog(@"Button1 Clicked");
                          }];

    [alertView addButtonWithTitle:@"Remove"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              [self unBookmarkCollege:college];
                          }];
    
    alertView.willShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willShowHandler", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didShowHandler", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didDismissHandler", alertView);
    };
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [alertView show];
}
-(void)unBookmarkCollege:(MUITCollege*) college
{
    
    NSMutableArray *bookmarkedColleges = [MY_DELEGATE bookmarked];
    
    [bookmarkedColleges removeObject:college];
    
    [self createUnbookmarkedAlertViewWithCollege:college];
    
}
-(void)createUnbookmarkedAlertViewWithCollege:(MUITCollege*) college
{
    NSString *title = @"Removed";
    NSString *message = [NSString stringWithFormat:@"%@ has been removed from bookmarks.", college.name];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:message];
    
    [alertView addButtonWithTitle:@"Ok"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              NSLog(@"Button1 Clicked");
                          }];
    
    [alertView addButtonWithTitle:@"Undo"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              [self bookmarkCollege:college];
                              [self createBookmarkAlertViewWithCollege:college andPresent:NO];
                          }];
    
    alertView.willShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willShowHandler", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didShowHandler", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didDismissHandler", alertView);
    };
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [alertView show];
}

@end
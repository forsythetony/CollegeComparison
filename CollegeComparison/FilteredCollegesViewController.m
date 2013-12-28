//
//  FilteredCollegesViewController.m
//  CollegeComparison
//
//  Created by Josh Valdivieso on 12/1/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "FilteredCollegesViewController.h"

@interface FilteredCollegesViewController (){
    NSMutableArray *collegesImGoingToCompare;
}

@end

@implementation FilteredCollegesViewController

NSArray *searchResults;

- (void)viewDidLoad
{
    collegesImGoingToCompare = [NSMutableArray new];
    NSMutableDictionary *options = [NSMutableDictionary new];
    MUITCollegeDataProvider *collegeManager = [MUITCollegeDataProvider new];
    
    self.collegesToCompare = [[NSMutableArray alloc] init];
    self.storedSchoolsDictionary = [[NSMutableDictionary alloc] init];
    
    // Passed data
    self.universitiesPassed = [collegeManager getColleges:options];
    
    // Set custom attributes for navigation bar
    [self setCustomAttributesForNavigationBar];
    
    // Navigation bar buttons
    self.selectButton = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(selectButton:)];
    self.selectButton.tintColor = [UIColor whiteColor];
    
    self.compareButton = [[UIBarButtonItem alloc] initWithTitle:@"Compare" style:UIBarButtonItemStyleBordered target:self action:@selector(selectCollegesToCompare:)];
    self.compareButton.tintColor = [UIColor whiteColor];
    self.compareButton.enabled = NO;
    
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButton:)];
    self.cancelButton.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setRightBarButtonItem:self.selectButton];
    
    // Changing the checkmark color while selecting universities
    [self.tableView setTintColor:[UIColor colorWithRed:240.0/255.0 green:87.0/255.0 blue:70.0/255.0 alpha:1.0]];
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
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
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:0];
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
    
    [tableHeaderView setBackgroundColor:[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0]];
    
    // Label properties for custon UIView
    UILabel *labelInHeaderView = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 320.0f, 40.0f)];
    labelInHeaderView.textAlignment = NSTextAlignmentLeft;
    [labelInHeaderView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
    [labelInHeaderView setTextColor:[UIColor grayColor]];
    labelInHeaderView.font = [UIFont fontWithName:@"Avenir-Book" size:13.0];
    labelInHeaderView.text = [[NSString stringWithFormat:@"%d", collegesReturned] stringByAppendingString:@" COLLEGES RETURNED"];
    
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
    //MUITCollege *college = self.representedCollege;
    
    // Local variables
    static NSString *cellIdentifier = @"CollegeCell";
    
    FilteredCollegesTableViewCell *cell = (FilteredCollegesTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[FilteredCollegesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Cell label customization
    [cell.universityNameLabel setTextColor:[UIColor colorWithRed:0.0/255 green:174.0/255 blue:239.0/255 alpha:1.0]];
    [cell.universityNameLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:17.0]];
    
    [cell.universityLocationLabel setTextColor:[UIColor colorWithRed:147.0/255.0 green:149.0/255 blue:152.0/255 alpha:1.0]];
    [cell.universityLocationLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17.0]];
    
    [cell.universityTuitionLabel setTextColor:[UIColor colorWithRed:147.0/255.0 green:149.0/255 blue:152.0/255 alpha:1.0]];
    [cell.universityTuitionLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17.0]];
    
    NSNumberFormatter *tuition = [[NSNumberFormatter alloc] init];
    [tuition setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [tuition setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumber *amount = [NSNumber numberWithInt:[(MUITCollege *)[self.universitiesPassed objectAtIndex:indexPath.row] tuition_out_state]];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.universityNameLabel.text = [(MUITCollege *)[searchResults objectAtIndex:indexPath.row] name];
        cell.universityLocationLabel.text = [(MUITCollege *)[self.universitiesPassed objectAtIndex:indexPath.row] state];
        cell.universityTuitionLabel.text = [tuition stringFromNumber:amount];
    }
    else {
        cell.universityNameLabel.text = [(MUITCollege *)[self.universitiesPassed objectAtIndex:indexPath.row] name];
        cell.universityLocationLabel.text = [(MUITCollege *)[self.universitiesPassed objectAtIndex:indexPath.row] state];
        cell.universityTuitionLabel.text = [tuition stringFromNumber:amount];
    }
    
    cell.tag = indexPath.row;
    
    [self.allCellsInTable addObject:cell];
    
    return cell;
}

#pragma mark - Table View Delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    
    if(selectedRows.count == 2)
    {
        return nil;
    } else {
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If user is selecting colleges to compare
    if (self.tableView.isEditing)
    {
        NSLog(@"%lu", (unsigned long)self.collegesToCompare.count);
        FilteredCollegesTableViewCell *cellToCompare = (FilteredCollegesTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        MUITCollege *dummyCollege = [self.universitiesPassed objectAtIndex:indexPath.row];
        
        
        [self.collegesToCompare removeObject:cellToCompare];
        [collegesImGoingToCompare removeObject:dummyCollege];
        if(self.collegesToCompare.count < 2)
        {
            self.compareButton.enabled = NO;
            
            // Enable all cells
            for (int row = 0; row < [tableView numberOfRowsInSection:0]; row++)
            {
                NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:0];
                FilteredCollegesTableViewCell* cell = (FilteredCollegesTableViewCell *)[self.tableView cellForRowAtIndexPath:cellPath];
                if(!cell.selected)
                {
                    cell.enabled = YES;
                    cell.userInteractionEnabled = YES;
                }
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilteredCollegesTableViewCell *detailCell = (FilteredCollegesTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (self.tableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier: @"showCollegeDetailSegue" sender: self];
    }
    
    if([detailCell.reuseIdentifier isEqualToString:@"CollegeCell"])
    {
        if(!self.tableView.isEditing)
        { 
            if([self.title  isEqual:@"schools"])
            {
                [self performSegueWithIdentifier:@"showCollegeDetailSegue" sender:detailCell];
            }
            else if([self.title isEqual:@"filteredSchools"])
            {
                [self performSegueWithIdentifier:@"collegeDetailsSegue" sender:detailCell];
            }
        }
    }
    
    /*if (self.tableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier: @"showCollegeDetailSegue" sender: self];
    }*/
    
    // If user is selecting colleges to compare
    if (self.tableView.isEditing)
    {
        FilteredCollegesTableViewCell *cellToCompare = (FilteredCollegesTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        //[(MUITCollege *)[self.universitiesPassed objectAtIndex:indexPath.row]
        
        MUITCollege *collegeObject = [self.universitiesPassed objectAtIndex:indexPath.row];
        
        
        
        // If the user has less than two colleges to selected
        if(self.collegesToCompare.count < 2)
        {
            [self.collegesToCompare addObject:cellToCompare];
            [collegesImGoingToCompare addObject:collegeObject];
            
            self.compareButton.enabled = NO;
        }
        
        // If the user has reached their max limit for selecting colleges
        if (self.collegesToCompare.count == 2)
        {
            self.compareButton.enabled = YES;
            
            // Disable all unselected cells
            for (int row = 0; row < [self.tableView numberOfRowsInSection:0]; row++)
            {
                NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:0];
                FilteredCollegesTableViewCell* cell = (FilteredCollegesTableViewCell *)[self.tableView cellForRowAtIndexPath:cellPath];
                if (!cell.selected) {
                    cell.enabled = NO;
                    cell.userInteractionEnabled = NO;
                }
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing && tableView.indexPathsForSelectedRows.count == 2)
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

     

     
//     
//     
//     if ([segue.identifier isEqualToString:@"comparisonSegue"]) {
//         CCAnimationPageViewController *destViewController = (CCAnimationPageViewController*)segue.destinationViewController;
//         
//         destViewController.twoColleges = [NSArray arrayWithArray:collegesImGoingToCompare];
//         
//         NSIndexPath *indexPath = nil;
//         
//         //            instead of passing a college name, pass an MUITCollege object.
//         NSIndexPath *tappedPath =  [self.tableView indexPathForSelectedRow]; //get the index path of the row the user tapped
//         MUITCollege *tappedCollege = [colleges objectAtIndex:tappedPath.row];  //get the college at the row the user tapped
//         destViewController.representedCollege = tappedCollege;
//     }
// }

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

@end
//
//  FilteredCollegesViewController.m
//  CollegeComparison
//
//  Created by Josh Valdivieso on 12/1/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "FilteredCollegesViewController.h"

@interface FilteredCollegesViewController ()

@end

@implementation FilteredCollegesViewController

- (void)viewDidLoad
{
    self.collegesToCompare = [[NSMutableArray alloc] init];
    self.storedSchoolsDictionary = [[NSMutableDictionary alloc] init];
    //self.selectedRowsToCompare = [[NSMutableArray alloc] init];
    
    // Passed data
    self.universitiesPassed = [[NSMutableArray alloc] initWithObjects:@"University 1", @"University 2", @"University 3", @"University 4", @"University 5", @"University 6", @"University 7", @"University 8", nil];
    
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
    if(section == 0)
    {
        return self.universitiesPassed.count;
    }
    
    return 0;
}

// Tableview cell creation
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Local variables
    NSString *cellIdentifier = @"CollegeCell";
    
    FilteredCollegesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Cell label customization
    [cell.universityNameLabel setTextColor:[UIColor colorWithRed:0.0/255 green:174.0/255 blue:239.0/255 alpha:1.0]];
    [cell.universityNameLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:17.0]];
    
    [cell.universityLocationLabel setTextColor:[UIColor colorWithRed:147.0/255.0 green:149.0/255 blue:152.0/255 alpha:1.0]];
    [cell.universityLocationLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17.0]];
    
    [cell.universityTuitionLabel setTextColor:[UIColor colorWithRed:147.0/255.0 green:149.0/255 blue:152.0/255 alpha:1.0]];
    [cell.universityTuitionLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17.0]];
    
    // Configure cell
    cell.universityNameLabel.text = self.universitiesPassed[indexPath.row];
    cell.universityLocationLabel.text = @"Location (City, State)";
    cell.universityTuitionLabel.text = @"Tuition";
    cell.tag = indexPath.row;
    
    [self.storedSchoolsDictionary setObject:cell forKey:[NSString stringWithFormat:@"%i", indexPath.row]];
    [self.allCellsInTable addObject:cell];
    
    FilteredCollegesTableViewCell *theCell = [self.storedSchoolsDictionary objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]];

    NSLog(@"%@", theCell.universityNameLabel.text);
    
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
        NSLog(@"%i", self.collegesToCompare.count);
        FilteredCollegesTableViewCell *cellToCompare = (FilteredCollegesTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        [self.collegesToCompare removeObject:cellToCompare];
        
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
    FilteredCollegesTableViewCell *detailCell = (FilteredCollegesTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%i", self.collegesToCompare.count);
    if([detailCell.reuseIdentifier isEqualToString:@"CollegeCell"])
    {
        if(!self.tableView.isEditing)
        {
            [self performSegueWithIdentifier:@"collegeDetailsSegue" sender:detailCell];
        }
    }
    // If user is selecting colleges to compare
    if (self.tableView.isEditing)
    {
        FilteredCollegesTableViewCell *cellToCompare = (FilteredCollegesTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        // If the user has less than two colleges to selected
        if(self.collegesToCompare.count < 2)
        {
            [self.collegesToCompare addObject:cellToCompare];
            self.compareButton.enabled = NO;
        }
        
        // If the user has reached their max limit for selecting colleges
        if (self.collegesToCompare.count == 2)
        {
            self.compareButton.enabled = YES;
            
            // Disable all unselected cells
            for (int row = 0; row < [tableView numberOfRowsInSection:0]; row++)
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

- (void)selectCollegesToCompare:(id)sender
 {
    [self performSegueWithIdentifier:@"comparisonSegue" sender:sender];
 }
@end
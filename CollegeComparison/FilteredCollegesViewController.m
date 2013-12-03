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
    self.universityNames = [[NSMutableArray alloc] initWithObjects:@"University 1", @"University 2", @"University 3", @"University 4", @"University 5", @"University 6", @"University 7", @"University 8", nil];
    
    // Set custom attributes for navigation bar
    [self setCustomAttributesForNavigationBar];
    
    // Navigation bar buttons
    self.selectButton = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(selectButton:)];
    self.selectButton.tintColor = [UIColor whiteColor];
    
    self.compareButton = [[UIBarButtonItem alloc] initWithTitle:@"Compare" style:UIBarButtonItemStyleBordered target:self action:@selector(compareButton)];
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
    // Navigation attributes
    /*self.navigationBarAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor], NSForegroundColorAttributeName,
                                    [UIFont fontWithName:@"Avenir-Book" size:22.0], NSFontAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = self.navigationBarAttributes;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:240.0/255.0 green:87.0/255.0 blue:70.0/255.0 alpha:1.0];*/
    self.navigationItem.title = @"Results";
}

// Select two universites to compare
- (void)selectButton:(id)sender
{
    self.navigationItem.rightBarButtonItem = self.cancelButton;
    self.navigationItem.leftBarButtonItem = self.compareButton;
    self.compareButton.title = @"Compare";
    [self.tableView setEditing:YES animated:YES];
}

// Go back to main table view
- (void) cancelButton:(id)sender
{
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = self.selectButton;
    self.compareButton.enabled = NO;
    self.compareButton.style = UIBarButtonItemStylePlain;
    self.compareButton.title = nil;
    
    // Make all visible cells interactable
    for (int row = 0; row < [self.tableView numberOfRowsInSection:0]; row++)
    {
        NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:cellPath];
        cell.alpha = 1.0;
        cell.userInteractionEnabled = YES;
    }
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Grab the row number to pass
    NSInteger selectedRowToPass = self.tableView.indexPathForSelectedRow.row;
    
    // Grab the data from row that was selected
    NSString *selectedUniversity = self.universityNames[selectedRowToPass];
    
    // Segue identifiers
    NSString *comparisonSegueIdentifier = @"ComparisonSegue";
    NSString *schoolDetailSegueIdentifier = @"SchoolDetailsSegue";
    
    /*if([segue.identifier isEqualToString:comparisonSegueIdentifier] && self.collegesToCompare.count == 2)
    {
        // Set up the destination view controller
        FilteredCollegesViewController *comparisonViewController = segue.destinationViewController;
        [comparisonViewController setReceivedCollegeInformation:selectedUniversity];
        
        //[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }*/
    
    /*if([segue.identifier isEqualToString:schoolDetailSegueIdentifier])
    {
        // Implement the segue to a new view controller to display the details page
        FilteredCollegesViewController *detailsViewController = segue.destinationViewController;
        detailsViewController.university = selectedUniversity;
        detailsViewController.location = selectedUniversity;
        detailsViewController.tuition = selectedUniversity;
    }*/
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
    NSUInteger collegesReturned = self.universityNames.count;
    
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
        return self.universityNames.count;
    }
    
    return 0;
}

// Tableview cell creation
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Local variables
    NSString *cellIdentifier = @"CollegeCell";
    NSString *uncheckedButtonImage = @"Unchecked.png";
    
    FilteredCollegesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Get the size of the cell
    /*float cellHeight = cell.frame.size.height;
     float cellWidth = cell.frame.size.width;
     
     // Create custom view to hold button
     UIView *buttonHolder = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
     buttonHolder.center = CGPointMake(cellWidth - 20, cellHeight/2);
     
     // Get the size of the buttonHolder view
     float buttonHolderHeight = buttonHolder.frame.size.height;
     float buttonHolderWidth = buttonHolder.frame.size.width;
     
     // Create a custom button
     cell.compareCheckmark = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     cell.compareCheckmark.frame = CGRectMake(cellWidth - 50, cellHeight/3, 70.0f, 70.0f);
     
     // Set the background image and place it
     [cell.compareCheckmark setBackgroundImage:[UIImage imageNamed:uncheckedButtonImage] forState:UIControlStateNormal];
     [cell.compareCheckmark setFrame:CGRectMake(0, 0, 22.0, 22.0)];
     cell.compareCheckmark.center = CGPointMake(buttonHolderWidth/2, buttonHolderHeight/2);
     [buttonHolder addSubview:cell.compareCheckmark];*/
    
    // Cell label customization
    [cell.universityNameLabel setTextColor:[UIColor colorWithRed:0.0/255 green:174.0/255 blue:239.0/255 alpha:1.0]];
    [cell.universityNameLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:17.0]];
    
    [cell.universityLocationLabel setTextColor:[UIColor colorWithRed:147.0/255.0 green:149.0/255 blue:152.0/255 alpha:1.0]];
    [cell.universityLocationLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17.0]];
    
    [cell.universityTuitionLabel setTextColor:[UIColor colorWithRed:147.0/255.0 green:149.0/255 blue:152.0/255 alpha:1.0]];
    [cell.universityTuitionLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:17.0]];
    
    // Configure cell
   
    cell.universityNameLabel.text = self.universityNames[indexPath.row];
    cell.universityLocationLabel.text = @"Location (City, State)";
    cell.universityTuitionLabel.text = @"Tuition";
    cell.tag = indexPath.row;
    [self.storedSchoolsDictionary setObject:cell forKey:[NSString stringWithFormat:@"%i", indexPath.row]];
    
    FilteredCollegesTableViewCell *theCell = [self.storedSchoolsDictionary objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]];

    NSLog(@"%@", theCell.universityNameLabel.text);
    /*cell.tag = indexPath.row;
     [cell addSubview:buttonHolder];
     [cell.compareCheckmark setTag:indexPath.row];
     NSLog(@"%d", cell.compareCheckmark.tag);
     [cell.compareCheckmark addTarget:self
     action:@selector(selectCollegesToCompare:)
     forControlEvents:UIControlEventTouchUpInside];
     cell.compareCheckmark.hidden = NO;*/
    
    return cell;
}

#pragma mark - Table View Delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    
    if (selectedRows.count == 2) {
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
        if([self.tableView indexPathForSelectedRow] == self.collegesToCompare.firstObject)
        {
            [self.collegesToCompare removeObject:[self.tableView indexPathForSelectedRow]];
        }
        else if([self.tableView indexPathForSelectedRow] == self.collegesToCompare.lastObject)
        {
            [self.collegesToCompare removeLastObject];
        }
        
        if(self.collegesToCompare.count < 2)
        {
            self.compareButton.enabled = NO;
        }
        
        // Allow all visible cells to be interactable (THIS NEEDS TO BE FIXED)
        /*for (int row = 0; row < [tableView numberOfRowsInSection:0]; row++)
         {
         NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:0];
         UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:cellPath];
         cell.alpha = 1.0;
         cell.userInteractionEnabled = YES;
         }*/
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If user is selecting colleges to compare
    if (self.tableView.isEditing)
    {
        FilteredCollegesTableViewCell *cellToCompare = [self.storedSchoolsDictionary objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]];
        
        // If the user has less than two colleges to selected
        if(self.collegesToCompare.count < 2)
        {
            [self.collegesToCompare addObject:cellToCompare];
            NSLog(@"%i", self.collegesToCompare.count);

            self.compareButton.enabled = YES;
        }
        
        // If the user has reached their max limit for selecting colleges
        if (self.collegesToCompare.count == 2)
        {
            self.compareButton.enabled = YES;
            
            // Disable all other visible cells (THIS NEEDS TO BE FIXED)
            /*for (int row = 0; row < [tableView numberOfRowsInSection:0]; row++)
             {
             NSIndexPath *cellPath = [NSIndexPath indexPathForRow:row inSection:0];
             UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellPath];
             
             if(cell.tag == firstCollegeSelected.tag || cell.tag == secondCollegeSelected.tag)
             {
             continue;
             } else {
             cell.alpha = 0.5;
             cell.userInteractionEnabled = NO;
             }
             }*/
        }
    }
}

/*- (void)selectCollegesToCompare:(id)sender
 {
 //self.compareCheckmark.hidden = YES;
 for(NSInteger i = 0; i < self.collegeDataSet.count; i++)
 {
 //CCAPPTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
 CCAPPTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
 cell.compareCheckmark.hidden = YES;
 NSLog(@"%d", i);
 } //NSString *checkedButtonImage = @"CheckedBox.png";
 //[sender setBackgroundImage:[UIImage imageNamed:checkedButtonImage] forState:UIControlStateNormal];
 
 //cell.compareCheckmark.hidden = NO;
 //[button setBackgroundImage:[UIImage imageNamed:checkedButtonImage] forState:UIControlStateNormal];
 }*/

@end
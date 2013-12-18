//
//  FilterViewController.m
//  CollegeSearch
//
//  Created by borrower on 11/19/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

@synthesize statesForPicker;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// THIS NEEDS TO BE CREATED IN A FOR LOOP FROM THE DATA IN THE DATABASE (NOT HARD CODED LIKE SHOWN)
- (NSArray *)statesForPicker
{
    if(!statesForPicker)
    {
        statesForPicker = [[NSArray alloc] initWithObjects:@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming", nil];
    }
    
    return  statesForPicker;
}

#pragma mark - Picker Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.statesForPicker.count;
}

#pragma mark - Picker Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.statesForPicker objectAtIndex:row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Grab the row number to pass
    //NSInteger selectedRowToPass = self.tableView.indexPathForSelectedRow.row;
    
    // Grab the data from row that was selected
    //NSString *selectedUniversity = self.universityNames[selectedRowToPass];
    
    // Segue identifiers
    NSString *comparisonSegueIdentifier = @"ComparisonSegue";
    NSString *filteredSchoolsSegueIdentifier = @"FilteredSchoolsSegue";
    
    /*if([segue.identifier isEqualToString:comparisonSegueIdentifier] && self.collegesToCompare.count == 2)
     {
     // Set up the destination view controller
     FilteredCollegesViewController *comparisonViewController = segue.destinationViewController;
     [comparisonViewController setReceivedCollegeInformation:selectedUniversity];
     
     //[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
     }*/
    
    if([segue.identifier isEqualToString:filteredSchoolsSegueIdentifier])
     {
     // Implement the segue to a new view controller to display the details page
     FilteredCollegesViewController *detailsViewController = segue.destinationViewController;
     //detailsViewController.university = selectedUniversity;
     //detailsViewController.location = selectedUniversity;
     //detailsViewController.tuition = selectedUniversity;
     }
}

@end

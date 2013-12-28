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

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

/*- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}*/

// THIS NEEDS TO BE CREATED IN A FOR LOOP FROM THE DATA IN THE DATABASE (NOT HARD CODED LIKE SHOWN)
- (NSArray *)statesForPicker
{
    if(!statesForPicker)
    {
        statesForPicker = [[NSArray alloc] initWithObjects:@"None", @"All", @"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming", nil];
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

#pragma mark - UISegmentControl Datasource

- (IBAction)segmentAction
{
    // Local variables for querying the database
    NSUInteger tuitionCostLowerEnd;
    NSUInteger tuitionCostHigherEnd;
    NSUInteger enrollmentCostLowerEnd;
    NSUInteger enrollmentCostHigherEnd;
    NSUInteger schoolType;
    
    // Easier access to segmented controls
    UISegmentedControl *tuitionSegment = self.tuitionSegmentedControl;
    UISegmentedControl *enrollmentSegment = self.enrollmentSegmentedControl;
    UISegmentedControl *schoolTypeSegment = self.schoolTypeSegmentedControl;
    
    // Set tuitionCost based upon tuition filter
    switch (tuitionSegment.selectedSegmentIndex) {
        case 0:
            tuitionCostLowerEnd = 0;
            tuitionCostHigherEnd = 10000;
            break;
        case 1:
            tuitionCostLowerEnd = 10000;
            tuitionCostHigherEnd = 20000;
            break;
        case 2:
            tuitionCostLowerEnd = 20000;
            tuitionCostHigherEnd = 30000;
            break;
        case 3:
            tuitionCostLowerEnd = 30000;
            break;
        default:
            tuitionCostLowerEnd = -1;
            tuitionCostHigherEnd = -1;
            break;
    }
    
    // Set enrollmentCost based upon enrollment filter
    switch (enrollmentSegment.selectedSegmentIndex) {
        case 0:
            enrollmentCostLowerEnd = 0;
            enrollmentCostHigherEnd = 5000;
            break;
        case 1:
            enrollmentCostLowerEnd = 5000;
            enrollmentCostHigherEnd = 15000;
            break;
        case 2:
            enrollmentCostLowerEnd = 15000;
            enrollmentCostHigherEnd = 30000;
            break;
        case 3:
            enrollmentCostLowerEnd = 30000;
            break;
        default:
            enrollmentCostLowerEnd = -1;
            enrollmentCostLowerEnd = -1;
            break;
    }
    
    // Set schoolType based upon school type filter
    switch (schoolTypeSegment.selectedSegmentIndex) {
        case 0:
            schoolType = 0;
            break;
        case 1:
            schoolType = 1;
            break;
        default:
            schoolType = 2;
            break;
    }
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

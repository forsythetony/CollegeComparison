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

//
//  CollegeSearchViewController.m
//  CollegeSearch
//
//  Created by borrower on 11/5/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CollegeSearchViewController.h"
#import "CollegeDetailViewController.h"


@interface CollegeSearchViewController ()

@end

@implementation CollegeSearchViewController
{
    NSArray *colleges;
    NSArray *searchResults;
}

@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSMutableDictionary *options = [NSMutableDictionary new];
//    [options setObject:@"University of Missouri-" forKey:@"name"];
    
    MUITCollegeDataProvider *collegeManager = [MUITCollegeDataProvider new];
    colleges = [collegeManager getColleges:options];
    
//    colleges = [NSArray arrayWithObjects:@"Mizzou", @"KU", @"Missouri S&T", @"Alabama", @"Colorado University", @"Blue Ridge Community", @"Edgar College", @"Delaware University", @"University of Kentucky", @"Wyoming University", @"Layola College", @"Columbia College", @"Syracuse", @"University of Wisconsin", @"Ole Miss", @"Baltimore College", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)collegeTableView numberOfRowsInSection:(NSInteger)section
{
    if (collegeTableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [colleges count];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)collegeTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CollegeCell";
    
    UITableViewCell *cell = [collegeTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (collegeTableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [(MUITCollege *)[searchResults objectAtIndex:indexPath.row] name];
    } else {
        cell.textLabel.text = [(MUITCollege *)[colleges objectAtIndex:indexPath.row] name];
    }
    
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCollegeDetailSegue"]) {
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
            MUITCollege *tappedCollege = [colleges objectAtIndex:tappedPath.row];  //get the college at the row the user tapped
            destViewController.representedCollege = tappedCollege;
        }
    }


}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"name contains[cd] %@",
                                    searchText];
    
    searchResults = [colleges filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)tableView:(UITableView *)collegeTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (collegeTableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier: @"showCollegeDetailSegue" sender: self];
    }
}

@end

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
    colleges = [NSArray arrayWithObjects:@"Mizzou", @"KU", @"Missouri S&T", @"Alabama", @"Colorado University", @"Blue Ridge Community", @"Edgar College", @"Delaware University", @"University of Kentucky", @"Wyoming University", @"Layola College", @"Columbia College", @"Syracuse", @"University of Wisconsin", @"Ole Miss", @"Baltimore College", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [colleges count];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CollegeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [colleges objectAtIndex:indexPath.row];
    }
    
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCollegeDetailSegue"]) {
        CollegeDetailViewController *destViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = nil;
        
        if ([self.searchDisplayController isActive]) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            destViewController.collegeName = [searchResults objectAtIndex:indexPath.row];
            
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            destViewController.collegeName = [colleges objectAtIndex:indexPath.row];
        }
    }
    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier: @"showCollegeDetailSegue" sender: self];
    }
}

@end

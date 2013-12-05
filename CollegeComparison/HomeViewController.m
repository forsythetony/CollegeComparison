//
//  HomeViewController.m
//  CollegeSearch
//
//  Created by borrower on 11/17/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@""]]];
	// Do any additional setup after loading the view.
    
    //Example for retrieving schools from the database
    NSMutableDictionary* options = [NSMutableDictionary new];
    [options setObject:@"University of Missouri" forKey:@"name"];
    [options setObject:@"30000" forKey:@"out_state_tuition_max"];
    [options setObject:@"20000" forKey:@"out_state_tuition_min"];
    
    [options setObject:@"500" forKey:@"enrollment_total_min"];
    [options setObject:@"1200" forKey:@"enrollment_total_max"];
    
    [options setObject:@"public" forKey:@"school_type"];
    
    MUITCollegeDataProvider *collegeManager = [MUITCollegeDataProvider new];
    
    NSMutableArray *collegeArray = [collegeManager getColleges:options];
    for(MUITCollege *college in collegeArray)
    {
        NSLog(@"%@ out state tution: %ld", college.name, (long)college.tuition_out_state);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  MUITViewController.m
//  CollegeComparison
//
//  Created by CompSci on 11/5/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CCViewController.h"
#import "MUITCollegeDb.h"

@interface CCViewController ()

@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MUITCollegeDb *collegeManager = [MUITCollegeDb new];
    NSArray *myArray = [collegeManager findSchool:@"Mizzou"];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    if (!myArray) {
        NSLog(@"Hi");
    }
    int theCount = [myArray count];
    
    for (int i = 0; i < theCount; i++) {
        NSLog(@"%@", [myArray objectAtIndex:i]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

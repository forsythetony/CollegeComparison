//
//  MUITViewController.m
//  CollegeComparison
//
//  Created by CompSci on 11/5/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "MUITViewController.h"
#import "MUITCollegeDb.h"

@interface MUITViewController ()

@end

@implementation MUITViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MUITCollegeDb *collegeManager = [MUITCollegeDb new];
    [collegeManager findSchool:@"Mizzou"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

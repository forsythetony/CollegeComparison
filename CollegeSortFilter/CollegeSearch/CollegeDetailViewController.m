//
//  CollegeDetailViewController.m
//  CollegeSearch
//
//  Created by borrower on 11/7/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CollegeDetailViewController.h"

@interface CollegeDetailViewController ()

@end

@implementation CollegeDetailViewController

@synthesize collegeLabel;
@synthesize collegeName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialize
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Set the Label text with the selected recipe
    collegeLabel.text = collegeName;
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

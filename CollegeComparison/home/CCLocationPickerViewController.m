//
//  CCLocationPickerViewController.m
//  CollegeComparison
//
//  Created by Chapman, Andrew J. (MU-Student) on 2/16/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import "CCLocationPickerViewController.h"

@interface CCLocationPickerViewController ()

@end

@implementation CCLocationPickerViewController

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
    
    [self aestheticsConfiguration];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor redColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedDismiss:(id)sender {
    
    [self.delegate dismissAndPresentCCLocationPicker];
}
-(void)aestheticsConfiguration
{
    //  Set background color
    
        UIColor *mainViewBackgroundColor        =   [UIColor black75PercentColor];
    
    
    
    
    
    
    
    
    
    
    self.view.backgroundColor = mainViewBackgroundColor;
}
@end

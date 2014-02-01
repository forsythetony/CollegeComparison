//
//  CCSettingsViewController.m
//  CollegeComparison
//
//  Created by Anthony Forsythe on 1/11/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import "CCSettingsViewController.h"
#import "SWRevealViewController.h"

@interface CCSettingsViewController () {
//    UIButton *toggleButton;
}

@end

@implementation CCSettingsViewController

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
    [self slidingPanelSetup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)slidingPanelSetup
{
    //Set up panel view things
    
    _panelViewButton.target = self;
    _panelViewButton.action = @selector(panelPressed:);
    //Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
}
-(void)panelPressed:(id) sender
{
    
        [self.revealViewController rightRevealToggle:sender];
}

@end

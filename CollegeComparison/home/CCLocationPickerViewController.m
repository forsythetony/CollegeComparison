//
//  CCLocationPickerViewController.m
//  CollegeComparison
//
//  Created by Chapman, Andrew J. (MU-Student) on 2/16/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import "CCLocationPickerViewController.h"

@interface CCLocationPickerViewController () {
    NSArray *regions;
    CCLocation *theLocation;
}

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
    
    theLocation = [CCLocation new];
    
    [self.regionPickerView setDataSource:self];
    [self.regionPickerView setDelegate:self];
    
    [self.stateTextField setDelegate:self];
    [self.cityTextField setDelegate:self];
    [self.zipTextField setDelegate:self];
    [self aestheticsConfiguration];
    [self dataSetup];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedDismiss:(id)sender {
    
    [self.delegate dismissAndPresentCCLocationPicker];
}
-(void)dataSetup
{
    NSMutableArray *regionsArrray = [NSMutableArray arrayWithObjects:@"Northeast", @"Northwest", @"Southeast", @"Southwest", @"Midwest", nil];
    
    [regionsArrray insertObject:@"None" atIndex:0];
    
    regions = [NSArray arrayWithArray:regionsArrray];
    
}
-(void)aestheticsConfiguration
{
    //  Set background color
    
        UIColor *mainViewBackgroundColor        =   [UIColor black75PercentColor];
    
    self.view.backgroundColor = mainViewBackgroundColor;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == self.regionPickerView) {
        return 1;
    }
    else
    {
        return 1;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [regions count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [regions objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"\n\nSelected component %d row %d", component, row);
    
    theLocation.region = [regions objectAtIndex:row];
    
    NSLog(@"\n\nLocation object's region value is: %@\n\n,", theLocation.region);
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.stateTextField) {
        NSLog(@"\n\n\nFUCK THIS SHITZ\n\n\n");
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end

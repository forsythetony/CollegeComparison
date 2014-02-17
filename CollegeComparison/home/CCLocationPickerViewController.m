//
//  CCLocationPickerViewController.m
//  CollegeComparison
//
//  Created by Chapman, Andrew J. (MU-Student) on 2/16/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import "CCLocationPickerViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define CORALCOLOR UIColorFromRGB(0xF05746)

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

- (IBAction)clickedSave:(id)sender {

    
    [self updateLocationObject];
    
    [self.delegate dismissAndAddLocation:theLocation];
}

- (IBAction)clickedCancel:(id)sender {
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
    
        UIColor *mainViewBackgroundColor        =   [UIColor whiteColor];
    
    //  Toolbar configuration
    
        UIColor *toolbarTintColor               =   [UIColor charcoalColor];
    
        //  Toolbar button configuration
    
        UIColor *toolbarButtonTextColor         =   [UIColor whiteColor];
    
    
    //  Configure picker view
    
        UIColor *pickerViewTintColor            =   CORALCOLOR;
    
    
    
    
    
    [self.theToolbar setTranslucent:YES];
    [self.theToolbar setBackgroundColor:toolbarTintColor];
    [self.theToolbar setTintColor:toolbarTintColor];
    [self.theToolbar setBarTintColor:toolbarTintColor];

    [self.regionPickerView setTintColor:pickerViewTintColor];
    self.regionPickerView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    
    [self.saveButton setTintColor:toolbarButtonTextColor];
    [self.cancelButton setTintColor:toolbarButtonTextColor];
    
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
-(void)updateLocationObject
{
    NSString *city = self.cityTextField.text;
    NSString *state = self.stateTextField.text;
    NSString *zip = self.zipTextField.text;
    
    if (!city) {
        city = @"";
    }
    if (!state) {
        state = @"";
    }
    if (!zip) {
        zip = @"";
    }
    
    
    //  Create location object
    if (!theLocation) {
        theLocation = [CCLocation new];
    }
    
    theLocation.stringAddress = [NSString stringWithFormat:@"%@, %@ : %@", city, state, zip];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    theLocation = nil;
}
-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [regions objectAtIndex:row];
    
    
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName: CORALCOLOR}];
    
    return attributedString;
    
    
}
@end

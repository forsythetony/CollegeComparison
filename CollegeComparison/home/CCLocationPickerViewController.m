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
    
    NSDictionary *theLook;
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
    [self aestheticsConfiguration];

    theLocation = [CCLocation new];
    
    [self.regionPickerView setDataSource:self];
    [self.regionPickerView setDelegate:self];
    
    [self.stateTextField setDelegate:self];
    [self.cityTextField setDelegate:self];
    [self.zipTextField setDelegate:self];
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
    //  Main view
    
        UIColor *mainViewBackgroundColor        =   [UIColor whiteColor];

    
    //  Toolbar
    
        UIColor *toolbarTintColor               =   [UIColor charcoalColor];
    
        //  Toolbar button configuration
    
        UIColor *toolbarButtonTextColor         =   [UIColor whiteColor];
    
    
    //  Picker view
    
        UIColor *pickerViewBackgroundColor      =   [UIColor clearColor];
        
        UIColor *pickerViewTextColor            =   CORALCOLOR;
        
        NSString *pickerViewFontFamily          =   @"Avenir-Book";
        float pickerViewFontSize                =   20.0;
    
        NSTextAlignment pickerViewLabelTextAlignment   =   NSTextAlignmentCenter;
    
    
    //  Style for text views
    
    UITextBorderStyle textFieldsBorderStyle = UITextBorderStyleRoundedRect;
    
        //  City text field
        NSString *cityTextPlaceholderText       =   @"City";
    
        //  State text field
        NSString *statePlaceholderText          =   @"State";
    
        //  Zip code text field
        NSString *zipPlaceholderText            =   @"Zip Code";
    
    
    [self.theToolbar setTranslucent:YES];
    [self.theToolbar setBackgroundColor:toolbarTintColor];
    [self.theToolbar setTintColor:toolbarTintColor];
    [self.theToolbar setBarTintColor:toolbarTintColor];
    
    [self.saveButton setTintColor:toolbarButtonTextColor];
    
    //Picker View
    
    UIFont *pickerViewFont = [UIFont fontWithName:pickerViewFontFamily size:pickerViewFontSize];
    
    
    NSDictionary *pickerView = [NSDictionary dictionaryWithObjectsAndKeys:pickerViewFont, @"font", pickerViewTextColor, @"textColor", pickerViewBackgroundColor, @"backgroundColor", [NSNumber numberWithInt:pickerViewLabelTextAlignment], @"textAlignment", nil];

    
    
    [self.cancelButton setTintColor:toolbarButtonTextColor];
    
    self.view.backgroundColor = mainViewBackgroundColor;
    
    //  Text fields
    self.stateTextField.borderStyle =textFieldsBorderStyle;
    self.stateTextField.placeholder = statePlaceholderText;
    
    self.cityTextField.borderStyle = textFieldsBorderStyle;
    self.cityTextField.placeholder = cityTextPlaceholderText;
    
    self.zipTextField.borderStyle = textFieldsBorderStyle;
    self.zipTextField.placeholder = zipPlaceholderText;
    
    
    
    //Create the dictionary
    
    theLook = [NSDictionary dictionaryWithObjectsAndKeys:pickerView, @"pickerView", nil];
    
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
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *newView = (UILabel*)view;
    
    if (!newView) {
        newView = [[UILabel alloc] init];
        
        //  Set font of label
        newView.font = [[theLook objectForKey:@"pickerView"] objectForKey:@"font"];
        
        //  Set text color
        newView.textColor = [[theLook objectForKey:@"pickerView"] objectForKey:@"textColor"];
        
        //  Set background color
        newView.backgroundColor = [[theLook objectForKey:@"pickerView"] objectForKey:@"backgroundColor"];
        
        //  Set text alignment
        newView.textAlignment = [[[theLook objectForKey:@"pickerView"] objectForKey:@"textAlignment"] integerValue];
    }
    
    //  Set text of label
    newView.text = [regions objectAtIndex:row];
    
    return newView;
}

@end

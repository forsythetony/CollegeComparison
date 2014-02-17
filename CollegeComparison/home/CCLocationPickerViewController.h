//
//  CCLocationPickerViewController.h
//  CollegeComparison
//
//  Created by Chapman, Andrew J. (MU-Student) on 2/16/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Colours.h>
#import "CCLocation.h"

@protocol CCLocationPickerViewControllerProtocol <NSObject>

    - (void)dismissAndPresentCCLocationPicker;
-(void)dismissAndAddLocation:(CCLocation*) location;

@end

@interface CCLocationPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic, weak) id <CCLocationPickerViewControllerProtocol> delegate;

@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *regionPickerView;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;

@property (weak, nonatomic) IBOutlet UILabel *zipLabel;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;

@property (weak, nonatomic) IBOutlet UIToolbar *theToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)clickedDismiss:(id)sender;

- (IBAction)clickedSave:(id)sender;
- (IBAction)clickedCancel:(id)sender;


@end

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

@end

@interface CCLocationPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic, weak) id <ccloca> delegate;

@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *regionPickerView;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;

@property (weak, nonatomic) IBOutlet UILabel *zipLabel;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;

- (IBAction)clickedDismiss:(id)sender;

@end

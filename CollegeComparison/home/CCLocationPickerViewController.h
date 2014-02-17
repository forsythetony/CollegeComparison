//
//  CCLocationPickerViewController.h
//  CollegeComparison
//
//  Created by Chapman, Andrew J. (MU-Student) on 2/16/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Colours.h>

@protocol CCLocationPickerProtocol <NSObject>

- (void)dismissAndPresentCCLocationPicker;

@end

@interface CCLocationPickerViewController : UIViewController

@property (nonatomic, weak) id <CCLocationPickerProtocol> delegate;

- (IBAction)clickedDismiss:(id)sender;

@end

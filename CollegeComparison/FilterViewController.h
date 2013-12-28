//
//  FilterViewController.h
//  CollegeSearch
//
//  Created by borrower on 11/19/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FilteredCollegesViewController.h"

@interface FilterViewController : UIViewController <UIPickerViewDelegate ,UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *statesForPicker;
@property (nonatomic, weak) IBOutlet UISegmentedControl *tuitionSegmentedControl;
/*@property (nonatomic, weak) IBOutlet UIView *tuitionOne;
@property (nonatomic, weak) IBOutlet UIView *tuitionTwo;
@property (nonatomic, weak) IBOutlet UIView *tuitionThree;
@property (nonatomic, weak) IBOutlet UIView *tuitionFour;*/

@property (nonatomic, weak) IBOutlet UISegmentedControl *enrollmentSegmentedControl;
/*@property (nonatomic, weak) IBOutlet UIView *enrollmentOne;
@property (nonatomic, weak) IBOutlet UIView *enrollmentTwo;
@property (nonatomic, weak) IBOutlet UIView *enrollmentThree;
@property (nonatomic, weak) IBOutlet UIView *enrollmentFour;*/

@property (nonatomic, weak) IBOutlet UISegmentedControl *schoolTypeSegmentedControl;
/*@property (nonatomic, weak) IBOutlet UIView *schoolTypeOne;
@property (nonatomic, weak) IBOutlet UIView *schoolTypeTwo;*/

- (IBAction)segmentAction;
@end

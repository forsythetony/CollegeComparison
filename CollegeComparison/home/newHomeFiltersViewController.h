//
//  newHomeFiltersViewController.h
//  CollegeComparison
//
//  Created by Chapman, Andrew J. (MU-Student) on 2/6/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit.h>
#import <Colours.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <PNCircleChart.h>
#import "MUITCollegeDataProvider.h"
#import "CCLocationPickerViewController.h"
#import "NMRangeSlider.h"
#import <IQKeyboardManager.h>
#import "CCLocation.h"

@interface newHomeFiltersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CCLocationPickerViewControllerProtocol>

//Header view
@property (weak, nonatomic) IBOutlet UIView *collegeCountContainerView;

//Locations picker
@property (weak, nonatomic) IBOutlet UIView *locationsContainerView;
@property (weak, nonatomic) IBOutlet UILabel *locationsTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;

//Tuition Slider
@property (weak, nonatomic) IBOutlet UIView *tuitionContainerView;
@property (weak, nonatomic) IBOutlet UILabel *tuitionLabel;

//Enrollment Slider
@property (weak, nonatomic) IBOutlet UIView *enrollmentContainerView;
@property (weak, nonatomic) IBOutlet UILabel *enrollmentLabel;

//School Type
@property (weak, nonatomic) IBOutlet UIView *schoolTypeContainerView;
@property (weak, nonatomic) IBOutlet UILabel *schoolTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *publicSchoolButton;
@property (weak, nonatomic) IBOutlet UIButton *privateSchoolButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *panelViewButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *goButton;

- (IBAction)goPress:(id)sender;


@end

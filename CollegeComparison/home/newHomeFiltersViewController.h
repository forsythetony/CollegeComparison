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

@interface newHomeFiltersViewController : UIViewController

//Header view
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *collegeCountContainerView;

//Locations picker
@property (weak, nonatomic) IBOutlet UIView *locationsContainerView;
@property (weak, nonatomic) IBOutlet UILabel *locationsTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;

//Tuition Slider
@property (weak, nonatomic) IBOutlet UIView *tuitionContainerView;
@property (weak, nonatomic) IBOutlet UILabel *tuitionLabel;
@property (weak, nonatomic) IBOutlet UISlider *tuitionSlider;

//Enrollment Slider
@property (weak, nonatomic) IBOutlet UIView *enrollmentContainerView;
@property (weak, nonatomic) IBOutlet UILabel *enrollmentLabel;
@property (weak, nonatomic) IBOutlet UISlider *enrollmentSlider;

//School Type
@property (weak, nonatomic) IBOutlet UIView *schoolTypeContainerView;
@property (weak, nonatomic) IBOutlet UILabel *schoolTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *publicSchoolButton;
@property (weak, nonatomic) IBOutlet UIButton *privateSchoolButton;


@end

//
//  FilteredCollegesTableViewCell.h
//  CollegeComparison
//
//  Created by Josh Valdivieso on 12/1/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilteredCollegesTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *universityNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *universityLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *universityTuitionLabel;

@end

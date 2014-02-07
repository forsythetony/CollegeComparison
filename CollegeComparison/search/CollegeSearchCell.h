//
//  CollegeSearchCell.h
//  CollegeComparison
//
//  Created by Anthony Forsythe on 2/4/14.
//  Copyright (c) 2014 MUIT. All rights reserved.
//

#import "SWTableViewCell.h"
#import <Colours.h>
#import "MUITCollege.h"

@interface CollegeSearchCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) MUITCollege *college;

@end

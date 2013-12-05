//
//  FilteredCollegesTableViewCell.m
//  CollegeComparison
//
//  Created by Josh Valdivieso on 12/1/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "FilteredCollegesTableViewCell.h"

@implementation FilteredCollegesTableViewCell

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    self.alpha = (enabled? 1.0f : 0.5f);
}

@end

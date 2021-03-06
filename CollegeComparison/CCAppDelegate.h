//
//  MUITAppDelegate.h
//  CollegeComparison
//
//  Created by CompSci on 11/5/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) UIWindow *background;
@property (strong, nonatomic) NSMutableArray *recentlyVisited, *bookmarked;

@end

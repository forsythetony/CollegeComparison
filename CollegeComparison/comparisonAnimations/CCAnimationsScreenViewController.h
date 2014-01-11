//
//  CCAnimationsScreenViewController.h
//  CollegeComparison
//
//  Created by Anthony Forsythe on 11/18/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUITCollege.h"

@interface CCAnimationsScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleString;


@property (strong, nonatomic) NSString *mainLabel;
@property (strong, nonatomic) NSNumber *unitModifier;
@property (strong, nonatomic) NSDictionary *modifierDictionary;


@property (strong, nonatomic) NSString *schoolOneName;
@property (strong, nonatomic) NSString *schoolTwoName;


@property (strong, nonatomic) NSNumber *barOneHeight;
@property (strong, nonatomic) NSNumber *barTwoHeight;
@property (assign, nonatomic) BOOL hasAnimated;

@property (assign, nonatomic) CGRect mainFrame;
@property (assign, nonatomic) float schoolOneHeight;
@property (assign, nonatomic) float schoolTwoHeight;

@property (strong, nonatomic) NSMutableArray *labelPlaces;


@property (nonatomic, assign) BOOL populationButtonsArePresent;

-(void)setLabel;
-(void)animateAll;
-(void)checkBeforeAnimation;
-(void)removeDuringTransition;
-(void)createHandle;
-(void)replaceHandle;
-(void)buttonsForMenAndWomen;
-(void)buttonsForInStateAndOutWithOptionFirst:(BOOL) first;
-(void)removeUnderliners;

@end

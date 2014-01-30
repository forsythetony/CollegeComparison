//
//  HomeViewController.m
//  CollegeSearch
//
//  Created by borrower on 11/17/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"

@interface HomeViewController () {
    
}
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self slidingPanelSetup];   
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@""]]];
	// Do any additional setup after loading the view.
    
    //Example for retrieving schools from the database
    NSMutableDictionary* options = [NSMutableDictionary new];
    [options setObject:@"University of Missouri" forKey:@"name"];
    [options setObject:@"30000" forKey:@"out_state_tuition_max"];
    [options setObject:@"20000" forKey:@"out_state_tuition_min"];
    
    [options setObject:@"500" forKey:@"enrollment_total_min"];
    [options setObject:@"1200" forKey:@"enrollment_total_max"];
    
    [options setObject:@"public" forKey:@"school_type"];
    
    MUITCollegeDataProvider *collegeManager = [MUITCollegeDataProvider new];
    
    NSMutableArray *collegeArray = [collegeManager getColleges:options];
    for(MUITCollege *college in collegeArray)
    {
        NSLog(@"Enrollment_total for %@: %ld", college.name, (long)college.enrollment_total);
    }
    
    [self callToApi];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)callToApi
{
    NSString *UrlString = @"http://54.201.179.180/api/api.php?method=getAll";
    
    NSURL *Url = [NSURL URLWithString:UrlString];
    
    NSURLRequest *theRequest = [[NSURLRequest alloc] initWithURL:Url];
    NSOperationQueue *theQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:theQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        
        if (httpResponse.statusCode == 200 && data) {
            [self parseData:data];
            
            
        }
    }];
 
}

    
    -(void)parseData:(NSData*)data
    {
        NSError *error;
        
        NSDictionary *theDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSArray *colleges = theDictionary[@"colleges"];
        
        NSLog(@"\n\n\nCall to Api\n\n");
        for (NSDictionary* dictionary in colleges) {
            NSLog(@"\nCollege Name: %@\nTuition: %@", [dictionary objectForKey:@"name"], [dictionary objectForKey:@"tuition"]);
        }
        
    }

-(void)slidingPanelSetup
{

    //Set up panel view things
    _panelViewButton.target = self;
    _panelViewButton.action = @selector(panelPressed:);
    //Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeftSide animated:YES];

}
-(void)panelPressed:(id) sender
{
    
    [self.revealViewController revealToggle:sender];
}
@end

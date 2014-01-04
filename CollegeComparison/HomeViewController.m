//
//  HomeViewController.m
//  CollegeSearch
//
//  Created by borrower on 11/17/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "HomeViewController.h"
#import "CCSharedData.h"

@interface HomeViewController () {
    UIProgressView *progressViewIndicator;
    UIActivityIndicatorView *actView;
    CCSharedData *dataObject;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collegesDidFinishLoading:) name:@"didFinishDownloadingColleges" object:nil];
    dataObject = [CCSharedData sharedInstance];
    [self testing];

    [self configureView];
    
    
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

-(void)createActivityIndicator
{
    
//    progressViewIndicator = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//    
//    [self.view addSubview:progressViewIndicator];
//    
//    [progressViewIndicator setTrackTintColor:[UIColor whiteColor]];
//    [progressViewIndicator setTintColor:[UIColor redColor]];
//    
//    [progressViewIndicator setFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 5.0)];
//    [progressViewIndicator setProgress:0.5 animated:YES];
//    
    
 //   dataObject = [CCSharedData sharedDataObject];

}

-(void)collegesDidFinishLoading:(NSNotification*) notify
{
    [self removeLoadView];
    
}
-(void)configureView
{
    [self.loadingView setBackgroundColor:[UIColor grayColor]];
    [self.loadingView setAlpha:0.75f];
    
    actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    [self.loadingView addSubview:actView];
    [actView setFrame:CGRectMake((self.view.bounds.size.width / 2) - 20.0, 160.0, 40.0, 40.0)];
    [actView startAnimating];
}
-(void)removeLoadView
{
    
    [actView stopAnimating];
    [actView removeFromSuperview];
    
    [self.loadingView removeFromSuperview];

    
}

-(void)testing
{
    
    NSArray *sortedColleges = [dataObject getCollegesSortedByValue:@"out_state_tuition" AndAscending:NO];
    
    for (NSDictionary *dict in sortedColleges)
    {
        NSLog(@"\n\nCOLLEGE NAME: %@\nTuition: %@\n ID: %@\n\n", [dict objectForKey:@"name"], [dict objectForKey:@"enrollment_total"], [dict objectForKey:@"id"]);
    }
    
    
    
}
    
@end

//
//  MUITAppDelegate.m
//  CollegeComparison
//
//  Created by CompSci on 11/5/13.
//  Copyright (c) 2013 MUIT. All rights reserved.
//

#import "CCAppDelegate.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation CCAppDelegate

@synthesize background;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [[UINavigationBar appearance] setBarTintColor:[UIColor charcoalColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          [UIFont fontWithName:@"Avenir-Book" size:24.0], NSFontAttributeName,
                                                          nil]];
   
    
    
    
    [[UITabBar appearance] setBarTintColor:UIColorFromRGB(0xF05746)];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Avenir-Book" size:12.0], NSFontAttributeName,
                                                       nil] forState:UIControlStateNormal];
    
    //  Keyboard settings
    
    IQKeyboardManager *mgr = [IQKeyboardManager sharedManager];
    
    [mgr setEnable:YES];
    [mgr setShouldResignOnTouchOutside:YES];
    [mgr setEnableAutoToolbar:YES];
    [mgr setToolbarManageBehaviour:IQAutoToolbarByTag];
    
    // Override point for customization after application launch.

    NSError *error;
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  // Get the path to the database file
    NSString *documentPath = [searchPaths objectAtIndex:0];
    NSString *databasePath = [documentPath stringByAppendingPathComponent:@"schools.db"];
    
    NSLog(@"%@", databasePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
        
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"schools" ofType:@"db"];
    [fileManager copyItemAtPath:resourcePath toPath:databasePath error:&error];
    
    self.recentlyVisited = [self reloadRecentlyVisited];
    
    self.bookmarked = [self reloadFavorited];
    
    //[application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [application setStatusBarStyle:UIStatusBarStyleDefault];
        self.window.clipsToBounds =YES;
        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
        
        //Added on 19th Sep 2013
        self.window.bounds = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height);
        background = [[UIWindow alloc] initWithFrame: CGRectMake(0, 0, self.window.frame.size.width, 20)];
        background.backgroundColor =UIColorFromRGB(0xF05746);
        [background setHidden:NO];
    }
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveBookmarked];

    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    [self saveBookmarked];
}


-(void)saveBookmarked
{
    NSData *recentlyVisitedData = [NSKeyedArchiver archivedDataWithRootObject:self.recentlyVisited];
    NSData *favoritedData = [NSKeyedArchiver archivedDataWithRootObject:self.bookmarked];
    
    [[NSUserDefaults standardUserDefaults] setObject:recentlyVisitedData forKey:@"recentlyVisited"];
    [[NSUserDefaults standardUserDefaults] setObject:favoritedData forKey:@"favoritedData"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];


}

-(NSMutableArray*)reloadRecentlyVisited
{
    NSData *bookmarksData = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentlyVisited"];
    
    if (bookmarksData == nil) {
        return [NSMutableArray new];
    }
    
    NSMutableArray *bookmarks = [NSKeyedUnarchiver unarchiveObjectWithData:bookmarksData];
    
    return bookmarks;
}
-(NSMutableArray*)reloadFavorited
{
    NSData *favoritedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoritedData"];
    
    if (favoritedData == nil) {
        return [NSMutableArray new];
    }
    
    NSMutableArray *favorited = [NSKeyedUnarchiver unarchiveObjectWithData:favoritedData];
    
    return favorited;
    
}


@end

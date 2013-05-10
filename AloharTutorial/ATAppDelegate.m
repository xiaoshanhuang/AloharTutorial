//
//  ATAppDelegate.m
//  AloharTutorial
//
//  Created by Xiaoshan Huang on 5/3/13.
//  Copyright (c) 2013 Xiaoshan Huang. All rights reserved.
//

#import "ATAppDelegate.h"

@implementation ATAppDelegate
@synthesize events;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *appID = @"333";
    NSString *apiKey = @"393f764979844e9c863185f38adf9d45d268dead";
    self.userID = @"hxs";
    [ALLog setDelegate:self];
    [Alohar customizeApp:appID withApiKey:apiKey];
    if ([Alohar isLoggedIn]) {
        [Alohar startMonitoringUser];
        [self loadHistoryEvents];
        [Alohar setUserStayDelegate:self];
    } else {
        NSString *userToken = [[NSUserDefaults standardUserDefaults] stringForKey:self.userID];
        if (userToken == nil || userToken.length == 0){
            [Alohar registerWithAppID:appID andAPIKey:apiKey withDelegate:self];
        }else{
            [Alohar authenticateWithAppID:appID andAPIKey:apiKey andUserID:userToken withDelegate:self];
        }
    }
    [[AVAudioSession sharedInstance] setDelegate: self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

    return YES;
}

- (void)aloharDidLogin:(NSString *)userToken
{
    [[NSUserDefaults standardUserDefaults] setObject:userToken
                                              forKey:self.userID];
    [Alohar startMonitoringUser];
    [self loadHistoryEvents];
    [Alohar setUserStayDelegate:self];
}

- (void)aloharDidFailWithError:(NSError *)error
{    
    NSLog(@"Sorry, there was an error with alohar: %@", error);
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to login, please re-try" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    });
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
}

#pragma mark -
#pragma mark ALLogDelegate
- (void)onLog:(NSString *)log
{
    NSLog(@"++++ %@", log);
}

- (void)loadHistoryEvents
{
    if (self.events == nil) {
        NSArray *history = [Alohar userStayLocationHistory];
        self.events = [NSMutableArray arrayWithArray:history];
    }
}

#pragma mark -
#pragma mark ALUserStayDelegate
- (void)currentUserStayIdentified:(ALUserStay *)newStay
{
    NSLog(@"%s, userStay: %@", __FUNCTION__, [newStay description]);
    NSArray *keys = [NSArray arrayWithObjects:@"type", @"stay", @"timestamp", nil];
    NSString *time = [self formatTimeStamp:[NSDate date]];
    NSArray *objects = [NSArray arrayWithObjects:@"Userstay", newStay, time, nil];
    NSDictionary *event = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    [self.events addObject:event];
}


- (void)userArrivedAtPlace:(ALPlace *)personalPlace withLocation:(CLLocation *)location;
{
    NSLog(@"%s, %@", __FUNCTION__, @"arrival");
    if (personalPlace != nil) {
        NSArray *keys = [NSArray arrayWithObjects:@"type", @"location", @"timestamp", @"place", nil];
        NSString *time = [self formatTimeStamp:[NSDate date]];
        NSArray *objects = [NSArray arrayWithObjects:@"Arrival", [Alohar currentLocation], time, personalPlace,  nil];
        NSDictionary *event = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        [self.events addObject:event];
    } else {
        NSArray *keys = [NSArray arrayWithObjects:@"type", @"location", @"timestamp", nil];
        NSString *time = [self formatTimeStamp:[NSDate date]];
        NSArray *objects = [NSArray arrayWithObjects:@"Arrival", [Alohar currentLocation], time, nil];
        NSDictionary *event = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        [self.events addObject:event];
    }
    
}

- (void)userDepartedPlaceWithLocation:(CLLocation *)location
{
    NSLog(@"%s, %@", __FUNCTION__, @"departure");
    NSArray *keys = [NSArray arrayWithObjects:@"type", @"location", @"timestamp", nil];
    NSString *time = [self formatTimeStamp:[NSDate date]];
    NSArray *objects = [NSArray arrayWithObjects:@"Departure", location, time ,nil];
    NSDictionary *event = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    [self.events addObject:event];
}

- (NSString *)formatTimeStamp:(NSDate *)date
{
    static NSDateFormatter *formatter;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM dd hh:mma"];
        
    }
}


@end

//
//  AppDelegate.m
//  OrderMan
//
//  Created by System Administrator on 11/1/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    _currentItems = [NSMutableArray array];
    _curShip = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"", @"shipdate", @"", @"comment",  nil];
    
    _listItemvc = nil;
    _curOrderId = @"0";     // current order is new order. else is in database order_id
    
    _isOrderEmpty = true;
    
    [self createCopyOfDatabaseIfNeeded];
    
    return YES;
}

- (void)createCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Database filename can have extension db/sqlite.
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appDBPath = [documentsDirectory stringByAppendingPathComponent:@"ezorderdb.sqlite"];
    
    success = [fileManager fileExistsAtPath:appDBPath];
    if (success) {
        return;
    }
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ezorderdb"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:appDBPath error:&error];
    NSAssert(success, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
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

@end

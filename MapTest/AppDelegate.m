//
//  AppDelegate.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/2/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "LeaderboardViewController.h"
#import "ProfileviewControllerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    MapViewController *mapView = [MapViewController new];
    mapView.tabBarItem.title = @"Select Target";
    mapView.tabBarItem.image = [UIImage imageNamed:@"Mortar Filled-50"];
    
    UINavigationController *navBarMapView = [[UINavigationController alloc]initWithRootViewController:mapView];
    navBarMapView.navigationBarHidden = YES;
    
    LeaderboardViewController *leaderboardVC = [LeaderboardViewController new];
    leaderboardVC.tabBarItem.title = @"Leaderboards";
    leaderboardVC.tabBarItem.image = [UIImage imageNamed:@"Medal-50"];
    
    UINavigationController *navBarLeaderboard = [[UINavigationController alloc]initWithRootViewController:leaderboardVC];
    
    ProfileviewControllerViewController *profileVC = [ProfileviewControllerViewController new];
    profileVC.tabBarItem.title = @"Profile";
    profileVC.tabBarItem.image = [UIImage imageNamed:@"Military Backpack Radio Filled-50"];
    
    UINavigationController *navBarProfileVC = [[UINavigationController alloc]initWithRootViewController:profileVC];
    
    UITabBarController *tabBarController = [UITabBarController new];
    tabBarController.viewControllers = @[navBarLeaderboard, navBarMapView, navBarProfileVC];
    tabBarController.selectedIndex = 1;
    
    self.window.rootViewController = tabBarController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

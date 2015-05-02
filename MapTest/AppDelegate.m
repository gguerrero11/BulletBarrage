//
//  AppDelegate.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/2/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

/* APP NAMES IDEAS
 Shell Storm
 Shell Scatter
 Shell Strike
 Bullet Barrage
 Bullet Blast
 Bullet Bombardment
 Bullet Blitz
 Bomb Blitz
 Ammo _____
 */

#import "AppDelegate.h"
#import "MapViewController.h"
#import "LeaderboardViewController.h"
#import "ProfileviewControllerViewController.h"
#import "UserController.h"
#import <Parse/Parse.h>
#import <GoogleMaps/GoogleMaps.h>
#import "CustomTabBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarAnimationSlide;
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    // Google Maps API
    [GMSServices provideAPIKey:@"AIzaSyCS6OjomXIt4W-tlts-J7tG55sPJTK_sA4"];
    
    // Parse API
    //[Parse enableLocalDatastore];
    [Parse setApplicationId:@"7ueGpbdEj9VRrPEEjiE81T98AZ7WMDiI3xEwVpnx"
                  clientKey:@"OJgDQPnkJz6i2bsZWYomMLeuKAUzh2n5SOcn0Ciu"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    MapViewController *mapViewController = [MapViewController new];
    mapViewController.tabBarItem.title = @"Select Target";
    
    UINavigationController *navBarMapView = [[UINavigationController alloc]initWithRootViewController:mapViewController];
    navBarMapView.navigationBarHidden = YES;
    
    LeaderboardViewController *leaderboardVC = [LeaderboardViewController new];

    
    UINavigationController *navBarLeaderboard = [[UINavigationController alloc]initWithRootViewController:leaderboardVC];
        navBarLeaderboard.navigationBarHidden = YES;
    
    ProfileviewControllerViewController *profileVC = [ProfileviewControllerViewController new];
    
    UINavigationController *navBarProfileVC = [[UINavigationController alloc]initWithRootViewController:profileVC];
        navBarProfileVC.navigationBarHidden = YES;
    
    CustomTabBarViewController *tabBarController = [CustomTabBarViewController new];
    tabBarController.viewControllers = @[navBarLeaderboard, navBarMapView, navBarProfileVC];
    tabBarController.selectedIndex = 1;
    tabBarController.tabBar.clipsToBounds = YES;

    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setTintColor:[UIColor clearColor]];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    
    self.window.rootViewController = tabBarController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // Calculate accuracy before saving.
    double shotsFiredDouble = [[PFUser currentUser][shotsFiredKey] doubleValue];
    double shotsHitDouble = [[PFUser currentUser][shotsHitKey] doubleValue];
    double result = shotsHitDouble / shotsFiredDouble;
    NSNumber *accuracyObject = [NSNumber numberWithDouble:result * 100];
    [PFUser currentUser][accuracyKey] = accuracyObject;
    
    [UserController saveUserToParse:[PFUser currentUser]];
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

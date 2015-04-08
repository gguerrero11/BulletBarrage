//
//  UserController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/5/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "UserController.h"
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "WeaponController.h"

static NSString *userLocationkey = @"userLocation";
static NSString * const weaponNameKey = @"weaponSelected";

@implementation UserController

+ (UserController *) sharedInstance {
    static UserController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [UserController new];
    });
    return sharedInstance;
}

+ (void) queryUsersNearCurrentUser:(CLLocationCoordinate2D)coordinates
                  withinMileRadius:(double)radiusFromLocationInMiles{

    // Parse query calls.
    PFQuery *queryForUsers = [PFUser query];
    
//    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinates.latitude
//                                                  longitude:coordinates.longitude];
    
    [queryForUsers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else {

            [UserController sharedInstance].arrayOfUsers = objects;
            
            //NSLog(@"Videos Near Location: %@",[UserController sharedInstance].arrayOfUsers);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTable" object:nil];
        }
    }];
    
}

+ (Weapon *) setWeaponForUser:(NSString *)weaponString {
    [PFUser currentUser][weaponNameKey] = weaponString;
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"User Saved");
        } else {
            NSLog(@"%@", error);
        }
    }];
    
    Weapon *weapon = [WeaponController setWeapon:weaponString];
    return weapon;
}




@end

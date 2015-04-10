//
//  UserController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/5/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "UserController.h"
#import <MapKit/MapKit.h>
#import "WeaponController.h"

#import <GoogleMaps/GoogleMaps.h>
#import "GMSMarkerWithUser.h"

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
    
    [queryForUsers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else {
            
            [UserController sharedInstance].arrayOfUsers = objects;
            
            NSLog(@"Users Near Location: %lu",[UserController sharedInstance].arrayOfUsers.count);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"queryDone" object:nil];
        }
    }];
    
}

- (NSArray *)arrayOfMarkers {
    NSMutableArray *mArray = [NSMutableArray new];
    
    for (PFUser *user in [UserController sharedInstance].arrayOfUsers) {
        
        // will exclude the currentUser in the array
        if (user != [PFUser currentUser]) {
            
            GMSMarkerWithUser *marker = [[GMSMarkerWithUser alloc]initWithUser:user];
            marker.position = [UserController convertPFGeoPointToLocationCoordinate2D:user[userLocationkey]];
            [mArray addObject:marker];
        }
    }
    
    return mArray;
}

+ (CLLocationCoordinate2D)convertPFGeoPointToLocationCoordinate2D:(PFGeoPoint *)geoPoint {
    
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = geoPoint.latitude;
    coordinates.longitude = geoPoint.longitude;
    
    return coordinates;
}

+ (Weapon *) setWeaponForUser:(NSString *)weaponString {
    [PFUser currentUser][weaponSelectedKey] = weaponString;
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

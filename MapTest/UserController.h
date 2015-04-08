//
//  UserController.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/5/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Weapon.h"



@interface UserController : NSObject

+ (UserController *) sharedInstance;

@property (nonatomic,strong) NSArray *arrayOfUsers;

+ (void) queryUsersNearCurrentUser:(CLLocationCoordinate2D)coordinates
                  withinMileRadius:(double)radiusFromLocationInMiles;

+ (void) setWeapon:(Weapon *)weapon {
    
}


@end

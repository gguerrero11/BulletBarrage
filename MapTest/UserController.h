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

@property (nonatomic,strong) NSArray *arrayOfUsers;

+ (UserController *) sharedInstance;

+ (void) queryUsersNearCurrentUser:(CLLocationCoordinate2D)coordinates
                  withinMileRadius:(double)radiusFromLocationInMiles;

+ (Weapon *) setWeaponForUser:(NSString *)weaponString;



@end

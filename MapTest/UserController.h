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
#import <Parse/Parse.h>
#import "LeaderboardDataSource.h"

static NSString * const userLocationkey = @"userLocation";
static NSString * const weaponSelectedKey = @"weaponSelected";
static NSString * const shotsHitKey = @"shotsHit";
static NSString * const shotsFiredKey = @"shotsFired";
static NSString * const accuracyKey = @"accuracy";
static NSString * const longestDistanceKey = @"longestDistance";
static NSString * const healthKey = @"health";



@interface UserController : NSObject

@property (nonatomic,strong) NSArray *arrayOfUsers;
@property (nonatomic,strong) NSArray *arrayOfMarkers;

+ (UserController *) sharedInstance;

+ (void) queryUsersNearCurrentUser:(CLLocationCoordinate2D)coordinates
                  withinMileRadius:(double)radiusFromLocationInMiles;

+ (Weapon *) setWeaponForUser:(NSString *)weaponString;

+ (CLLocationCoordinate2D)convertPFGeoPointToLocationCoordinate2D:(PFGeoPoint *)geoPoint;

+ (void) saveUserToParse:(PFUser *)user;



@end

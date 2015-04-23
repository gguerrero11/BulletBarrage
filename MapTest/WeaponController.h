//
//  WeaponController.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/8/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weapon.h"
#import "Projectile.h"


static NSString * const grenade = @"grenade";
static NSString * const cannon = @"cannon";
static NSString * const nuke = @"nuke";


static NSString * const fromUserKey = @"fromUser";
static NSString * const weaponTypeKey = @"weaponTypeKey";
static NSString * const timeFiredKey = @"timeFired";
static NSString * const timeOfArrival = @"timeOfArrial";
static NSString * const hitLocationGeoPoint = @"hitLocationGeoPoint";


@interface WeaponController : NSObject

@property (nonatomic, strong) NSMutableArray *arrayOfProjectilesInArea;
@property (nonatomic, strong) NSMutableArray *arrayOfProjectilesToBeDeleted;

+ (WeaponController *) sharedInstance;

- (Weapon *) getWeapon:(NSString *)weaponString;

- (Projectile *) projectileWithHitLocation:(CLLocation *)hitLocation flightTime:(double)flightTime withWeapon:(NSString *)weaponString;

+ (void) saveProjectileToParse:(Projectile *)projectile;

- (void)queryForAllProjectilesNearLocation:(CLLocationCoordinate2D)coordinates;

@end

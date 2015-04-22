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

@interface WeaponController : NSObject

+ (WeaponController *) sharedInstance;

- (Weapon *) getWeapon:(NSString *)weaponString;

- (Projectile *) projectileWithHitLocation:(CLLocation *)hitLocation flightTime:(double)flightTime withWeapon:(NSString *)weaponString;

+ (void) saveProjectileToParse:(Projectile *)projectile;

@end

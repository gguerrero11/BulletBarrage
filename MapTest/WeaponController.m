//
//  WeaponController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/8/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "WeaponController.h"
#import "UserController.h"
#import <Parse/Parse.h>



@implementation WeaponController

+ (WeaponController *) sharedInstance {
    static WeaponController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [WeaponController new];
    });
    return sharedInstance;
}

+ (void) saveProjectileToParse:(Projectile *)projectile {
    
    [projectile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Projectile Data Saved");

        } else {
            NSLog(@"%@", error);
            [projectile saveEventually];
        }
    }];
}

- (Projectile *) projectileWithHitLocation:(CLLocation *)hitLocation flightTime:(double)flightTime withWeapon:(NSString *)weaponString {
    Projectile *projectile = [Projectile object];
    
    // attach geopoint
    PFGeoPoint *hitLocationGeoPoint = [PFGeoPoint geoPointWithLocation:hitLocation];
    projectile.hitLocationGeoPoint = hitLocationGeoPoint;

    // the date/time the shot was fired
    projectile.timeFired = [NSDate date];
    
    // set weaponType
    projectile.weaponType = weaponString;
    
    // set current user to projectile
    projectile.fromUser = [PFUser currentUser];
    
    // set date/time the shot will arrive at the target
    NSDate *arrivalDate = [[NSDate alloc]initWithTimeIntervalSinceNow:flightTime];
    NSLog(@"Flight Time: %f", flightTime);
    NSLog(@"Departure Time: %@", projectile.timeFired);
    NSLog(@"Arrival Time: %@", arrivalDate);
    projectile.timeOfArrival = arrivalDate;
    
    return projectile;
}

- (void) queryProjectilesWithinMeterRadius:(double)radius {
    
    
    
}

- (Weapon *) getWeapon:(NSString *)weaponString {
    
    Weapon *weapon = [Weapon new];
    weapon.weaponString = weaponString;
    
    if ([weaponString isEqualToString:grenade]) {
        weapon.velocity = 26.8224;  // measured in m/s (meters per second)
        weapon.damage = 30;
        weapon.radiusOfDamage = 10;
        weapon.sizeOfCrater = 8;
    }
    
    if ([weaponString isEqualToString:cannon]) {
        weapon.velocity = 820;
        weapon.damage = 50;
        weapon.radiusOfDamage = 100;
        weapon.sizeOfCrater = 150;
    }
    
    if ([weaponString isEqualToString:nuke]) {
        weapon.velocity = 500;
        weapon.damage = 500;
        weapon.radiusOfDamage = 2000;
        weapon.sizeOfCrater = 2000;
    }
    return  weapon;
}

@end

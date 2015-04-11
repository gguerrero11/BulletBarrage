//
//  WeaponController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/8/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "WeaponController.h"

@implementation WeaponController

+ (WeaponController *) sharedInstance {
    static WeaponController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [WeaponController new];
    });
    return sharedInstance;
}



+ (Weapon *) setWeapon:(NSString *)weaponString {
    Weapon *weapon = [Weapon new];
    if ([weaponString isEqualToString:cannon]) {
        [WeaponController sharedInstance].velocity = weapon.velocity;
        [WeaponController sharedInstance].damage = weapon.damage;
        [WeaponController sharedInstance].radiusOfDamage = weapon.radiusOfDamage;
    }
    return  weapon;
}

@end

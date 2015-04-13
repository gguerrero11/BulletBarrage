//
//  WeaponController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/8/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "WeaponController.h"
#import "UserController.h"

@implementation WeaponController

+ (WeaponController *) sharedInstance {
    static WeaponController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [WeaponController new];
    });
    return sharedInstance;
}



- (Weapon *) getWeapon:(NSString *)weaponString {
    
    Weapon *weapon = [Weapon new];
    
    if ([weaponString isEqualToString:cannon]) {
        weapon.velocity = 100;
        weapon.damage = 30;
        weapon.radiusOfDamage = 100;
        weapon.sizeOfCrater = 100;
    }
    
    if ([weaponString isEqualToString:missle]) {
        weapon.velocity = 250;
        weapon.damage = 80;
        weapon.radiusOfDamage = 50;
        weapon.sizeOfCrater = 50;
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

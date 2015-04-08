//
//  WeaponController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/8/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "WeaponController.h"

@implementation WeaponController

+ (Weapon *) setWeapon:(NSString *)weaponString {
    Weapon *weapon = [Weapon new];
    if ([weaponString isEqualToString:cannon]) {
        weapon.velocity = @30;
    }
    return weapon;
}

@end

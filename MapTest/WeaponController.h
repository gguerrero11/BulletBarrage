//
//  WeaponController.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/8/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weapon.h"

static NSString * const cannon = @"cannon";

@interface WeaponController : NSObject

+ (WeaponController *) sharedInstance;

+ (Weapon *) setWeapon:(NSString *)weapon;

@property (nonatomic,strong) NSNumber *velocity;
@property (nonatomic,assign) NSInteger damage;
@property (nonatomic,assign) NSInteger radiusOfDamage;

@end

//
//  Projectile.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/8/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <math.h>

static NSString * const velocityKey = @"velocity";


@interface Weapon : NSObject

@property (nonatomic) NSInteger velocity;
@property (nonatomic) NSInteger damage;
@property (nonatomic) NSInteger radiusOfDamage;
@property (nonatomic) NSInteger sizeOfCrater;
@property (nonatomic) UIImage *weaponImage;
@property (nonatomic) UIImage *weaponIcon;
@property (nonatomic) UIImage *projectileIcon;

@property (nonatomic, strong) NSString *weaponString;
@property (nonatomic, strong) NSString *weaponName;
@property (nonatomic, strong) NSString *weaponType;
@property (nonatomic, strong) NSString *weapondescription;
@property (nonatomic, strong) NSString *soundEffect;

@end

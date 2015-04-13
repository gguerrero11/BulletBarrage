//
//  Projectile.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/8/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <math.h>

static NSString * const velocityKey = @"velocity";


@interface Weapon : NSObject

@property (nonatomic) NSInteger velocity;
@property (nonatomic) NSInteger damage;
@property (nonatomic) NSInteger radiusOfDamage;
@property (nonatomic) NSInteger sizeOfCrater;


@end

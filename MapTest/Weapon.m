//
//  Projectile.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/8/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "Weapon.h"

@implementation Weapon

- (NSNumber *) velocity {
    return @100;
}

- (NSInteger) damage {
    return 30;
}

- (NSInteger) radiusOfDamage {
    return 100;
}

@end

//
//  Projectile.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/22/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "Projectile.h"

@implementation Projectile

@dynamic fromUser;
@dynamic weaponType;
@dynamic timeFired;
@dynamic timeOfArrival;
@dynamic hitLocationGeoPoint;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Projectile";
}

@end

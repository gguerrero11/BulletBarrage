//
//  HealthData.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/14/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "HealthData.h"

@implementation HealthData

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"HealthData";
}

@dynamic objectId;
@dynamic health;

@end



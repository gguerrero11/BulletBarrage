//
//  HealthData.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/14/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

static NSString * const killedByKey = @"killedBy";
static NSString * const userKey = @"user";
static NSString * const healthKey = @"health";

@interface HealthData : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSNumber *health;

@end

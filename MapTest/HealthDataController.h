//
//  HealthDataController.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/14/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "HealthData.h"

@interface HealthDataController : NSObject

@property (nonatomic,strong) NSArray *arrayOfHealthData;
@property (nonatomic,strong) NSNumber *healthNumber;


+ (HealthDataController *) sharedInstance;

+ (void) saveHealthData:(HealthData *)healthData ;

+ (void) retrieveHealthForUsers;





@end

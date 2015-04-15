//
//  HealthDataController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/14/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "HealthDataController.h"

@implementation HealthDataController

+ (HealthDataController *) sharedInstance {
    static HealthDataController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [HealthDataController new];
    });
    return sharedInstance;
}

+ (void) saveHealthData:(HealthData *)healthData {
    [healthData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"User Saved");
        } else {
            NSLog(@"%@", error);
            [healthData saveEventually];
        }
    }];
}

+ (void) retrieveHealthForUsers {
    
    PFQuery *healthQuery = [HealthData query];

    [healthQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) return;
        [HealthDataController sharedInstance].arrayOfHealthData = objects;
    }];
    
    NSLog(@"%@", [HealthDataController sharedInstance].arrayOfHealthData);
}



@end

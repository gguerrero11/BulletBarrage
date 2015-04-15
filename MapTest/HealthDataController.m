//
//  HealthDataController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/14/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "HealthDataController.h"
#import <Parse/Parse.h>

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
            NSLog(@"Health Data Saved");
        } else {
            NSLog(@"%@", error);
            [healthData saveEventually];
        }
    }];
}

+ (void) retrieveArrayOfHealthForUsers {
    
    PFQuery *healthQuery = [HealthData query];

    [healthQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) return;
        [HealthDataController sharedInstance].arrayOfHealthData = objects;
        NSLog(@"%@", [HealthDataController sharedInstance].arrayOfHealthData);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"healthQueryDone" object:nil];
        
    }];
}

- (HealthData *)currentUserHealthData {
    HealthData *dataToReturn = [HealthData new];
    for (HealthData *data in [HealthDataController sharedInstance].arrayOfHealthData) {
        PFUser *userAtData = data[userKey];
        if ([userAtData.objectId isEqualToString:[PFUser currentUser].objectId]) {
            dataToReturn = data;
        }
    }
    return dataToReturn;
}

- (HealthData *)retrieveHealthDataFromUser:(PFUser *)user {
    HealthData *dataToReturn = [HealthData new];
    for (HealthData *data in [HealthDataController sharedInstance].arrayOfHealthData) {
        PFUser *userAtData = data[userKey];
        if ([userAtData.objectId isEqualToString:user.objectId]) {
            dataToReturn = data;
        }
    }
    return dataToReturn;
}


@end

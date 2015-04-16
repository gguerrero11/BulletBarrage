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

//- (id) init {
//    self = [super init];
//    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrieveArrayOfHealthForUsers) name:@"queryDone" object:nil];
//    }
//    return self;
//}

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
            [HealthDataController retrieveArrayOfHealthForUsers];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"healthQueryDone" object:nil];
    }];
}

- (HealthData *)retrieveHealthDataFromUser:(PFUser *)user {
    HealthData *dataToReturn = [HealthData new];
    for (HealthData *data in [HealthDataController sharedInstance].arrayOfHealthData) {
        PFUser *userAtData = data[userKey];
        
        // matches the healthData to the user at marker by objectId
        if ([userAtData.objectId isEqualToString:user.objectId]) {
            dataToReturn = data;
        }
    }
    return dataToReturn;
}


@end

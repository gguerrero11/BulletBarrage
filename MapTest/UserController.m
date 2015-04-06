//
//  UserController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/5/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "UserController.h"
#import <Parse/Parse.h>

@implementation UserController

+ (UserController *) sharedInstance {
    static UserController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [UserController new];
    });
    return sharedInstance;
}

- (void) queryUsers {
    // Parse query calls.
    
    PFQuery *queryForVideos = [PFQuery queryWithClassName:@"Video"];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinates.latitude
                                                  longitude:coordinates.longitude];
    [queryForVideos whereKey:locationKeyOfVideo
                nearGeoPoint:geoPoint
                 withinMiles:radiusFromLocationInMiles];
    [queryForVideos findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else {
            NSArray *arrayOfVideos = [[NSMutableArray alloc] initWithArray:objects];
            
            NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:self.arrayOfAllVideoPins];
            for (Video *video in arrayOfVideos) {
                VideoPin *videoPin = [[VideoPin alloc]initWithVideo:video];
                [mutableArray addObject:videoPin];
            }
            self.arrayOfAllVideoPins = mutableArray;
            
            [VideoController sharedInstance].arrayOfVideosNearLocation = arrayOfVideos;
            [self.allAnnotationsMapView addAnnotations:mutableArray];
            [self updateVisibleAnnotations];
            
            NSLog(@"Videos Near Location: %ld",[VideoController sharedInstance].arrayOfVideosNearLocation.count);
        }
    }];

}




@end

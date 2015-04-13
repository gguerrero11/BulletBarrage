//
//  GMSMarker+addUser.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/13/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "GMSMarker+addUser.h"
#import "UserController.h"
#import <objc/runtime.h>

static char soundsInChainKey;

@implementation GMSMarker (addUser)

@dynamic distance;

//+ (GMSMarker *)addUser:(PFUser *)user {
//    GMSMarker *marker = [GMSMarker new];
//    marker.user = user;
//    return marker;
//}


- (PFUser *)user {
    return objc_getAssociatedObject(self, &soundsInChainKey);
}

- (void)setUser:(PFUser *)user {
    objc_setAssociatedObject(self, &soundsInChainKey, user, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (double)distance {
    
    double distanceOutput = 0;
    // convert position of marker into a CLLocation
    CLLocation *otherUserLocation = [[CLLocation alloc]initWithCoordinate:self.position altitude:0 horizontalAccuracy:10 verticalAccuracy:10 timestamp:[NSDate date]];
    
    // convert position of user into a CLLocation
    CLLocationCoordinate2D coordinateOfCurrentUser = [UserController convertPFGeoPointToLocationCoordinate2D:[PFUser currentUser][userLocationkey]];
    CLLocation *currentUserLocation = [[CLLocation alloc]initWithCoordinate:coordinateOfCurrentUser altitude:0 horizontalAccuracy:10 verticalAccuracy:10 timestamp:[NSDate date]];
    
    distanceOutput = [otherUserLocation distanceFromLocation:currentUserLocation];
    
    return distanceOutput;
}

@end

//
//  GMSMarkerWithUser.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/10/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "GMSMarkerWithUser.h"
#import "UserController.h"

@implementation GMSMarkerWithUser

// synthesizes the properties from its superclass so we can use it in the subclass
@synthesize title = _title;
@synthesize snippet = _snippet;


- (id)initWithUser:(PFUser *) user {
    self = [super init];
    if (self) {
        _user = user;
        _title = user[usernameKey];
        _snippet = _distanceString;
        
        self.position = [UserController convertPFGeoPointToLocationCoordinate2D:user[userLocationkey]];
        
    }
    return self;
}

- (NSString *)distanceString {
    
    // convert position of marker into a CLLocation
    CLLocation *otherUserLocation = [[CLLocation alloc]initWithCoordinate:self.position altitude:0 horizontalAccuracy:10 verticalAccuracy:10 timestamp:[NSDate date]];
    
    // convert position of user into a CLLocation
    CLLocationCoordinate2D coordinateOfCurrentUser = [UserController convertPFGeoPointToLocationCoordinate2D:[PFUser currentUser][userLocationkey]];
    CLLocation *currentUserLocation = [[CLLocation alloc]initWithCoordinate:coordinateOfCurrentUser altitude:0 horizontalAccuracy:10 verticalAccuracy:10 timestamp:[NSDate date]];
    
    _distance = [otherUserLocation distanceFromLocation:currentUserLocation];
    NSString *distanceString = [NSString stringWithFormat:@"%.0fm", _distance];
    return distanceString;
}

@end

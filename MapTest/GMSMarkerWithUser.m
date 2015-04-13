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
//@synthesize map = _newmap;
@synthesize wooh;



- (id)initWithUser:(PFUser *) user {
    self = [super init];
    if (self) {
        self.position = [UserController convertPFGeoPointToLocationCoordinate2D:user[userLocationkey]];

        _user = user;
        _title = user[usernameKey];
        _snippet = [NSString stringWithFormat:@"%.0fm",[self calculateDistanceString]];
    
        
    }
    return self;
}

- (double)calculateDistanceString {
    
    // convert position of marker into a CLLocation
    CLLocation *otherUserLocation = [[CLLocation alloc]initWithCoordinate:self.position altitude:0 horizontalAccuracy:10 verticalAccuracy:10 timestamp:[NSDate date]];
    
    // convert position of user into a CLLocation
    CLLocationCoordinate2D coordinateOfCurrentUser = [UserController convertPFGeoPointToLocationCoordinate2D:[PFUser currentUser][userLocationkey]];
    CLLocation *currentUserLocation = [[CLLocation alloc]initWithCoordinate:coordinateOfCurrentUser altitude:0 horizontalAccuracy:10 verticalAccuracy:10 timestamp:[NSDate date]];
    
    self.distance = [otherUserLocation distanceFromLocation:currentUserLocation];
    
    return self.distance;
}

@end

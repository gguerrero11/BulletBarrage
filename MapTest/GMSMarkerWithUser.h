//
//  GMSMarkerWithUser.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/10/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@interface GMSMarkerWithUser : GMSMarker

@property (nonatomic, strong) PFUser *user;

@property (nonatomic) CLLocation *targetLocation;
@property (nonatomic) CLLocation *userLocation;
@property (nonatomic) double distance;
@property (nonatomic, assign) CLLocationCoordinate2D position;
@property (nonatomic, strong) NSString *string;

- (id)initWithUser:(PFUser *) user;


@end

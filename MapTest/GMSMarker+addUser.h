//
//  GMSMarker+addUser.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/13/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>

@interface GMSMarker (addUser)

@property (nonatomic, retain) PFUser *user;
@property (nonatomic) double distance;
@property (nonatomic, strong) NSString *distanceString;


@end

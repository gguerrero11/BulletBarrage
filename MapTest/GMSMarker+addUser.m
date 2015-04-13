//
//  GMSMarker+addUser.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/13/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "GMSMarker+addUser.h"



@implementation GMSMarker (addUser)

@dynamic user;

+ (GMSMarker *)addUser:(PFUser *)user {
    GMSMarker *marker = [GMSMarker new];
    marker.user = user;
    return marker;
}

@end

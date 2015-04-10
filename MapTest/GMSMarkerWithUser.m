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
        
    }
    return self;
}


@end

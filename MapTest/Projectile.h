//
//  Projectile.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/22/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <Parse/Parse.h>

@interface Projectile : PFObject <PFSubclassing>

@property (nonatomic,strong) PFUser *fromUser;
@property (nonatomic,strong) NSString *weaponType;
@property (nonatomic,strong) NSDate *timeFired;
@property (nonatomic,strong) NSDate *timeOfArrival;
@property (nonatomic,strong) PFGeoPoint *hitLocationGeoPoint;

@end

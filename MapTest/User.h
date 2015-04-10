//
//  User.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/10/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//




#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface User : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D position;
@property (nonatomic, strong) NSString *weaponSelected;
@property (nonatomic, assign) NSInteger shotsFired;


@end

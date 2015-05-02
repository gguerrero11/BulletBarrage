//
//  DrawProjectile.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/18/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface DrawProjectile : NSObject

- (void)drawProjectileOnView:(GMSMapView *)passedView atCoordinate:(CLLocationCoordinate2D)toCoordinate fromCoordinate:(CLLocationCoordinate2D)fromCoordinate animationDuration:(double)animationDuration withIcon:(UIImage *)icon;

@end

//
//  DrawProjectile.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/18/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "DrawProjectile.h"
#import <UIKit/UIKit.h>

@interface CoordsList : NSObject
@property(nonatomic, readonly, copy) GMSPath *path;
@property(nonatomic, readonly) NSUInteger target;

- (id)initWithPath:(GMSPath *)path;

- (CLLocationCoordinate2D)next;

@end

@implementation CoordsList

- (id)initWithPath:(GMSPath *)path {
    if ((self = [super init])) {
        _path = [path copy];
        _target = 0;
    }
    return self;
}

- (CLLocationCoordinate2D)next {
    ++_target;
    if (_target == [_path count]) {
        //_target = 0;
    }
    return [_path coordinateAtIndex:_target];
}

@end


@interface DrawProjectile ()
@property (nonatomic) GMSMapView *view;
@property (nonatomic) GMSMutablePath *coords;

@property (nonatomic, assign) CLLocationDirection heading;
@property (nonatomic, assign) CLLocationCoordinate2D toCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D fromCoordinate;
@property (nonatomic, assign) double animationDuration;

@end


@implementation DrawProjectile

// set up background image
- (void)drawProjectileOnView:(GMSMapView *)passedView atCoordinate:(CLLocationCoordinate2D)toCoordinate fromCoordinate:(CLLocationCoordinate2D)fromCoordinate animationDuration:(double)animationDuration {
    
    self.view = passedView;
    self.animationDuration = animationDuration;
    self.toCoordinate = toCoordinate;
    self.fromCoordinate = fromCoordinate;
    
    GMSMarker *marker;
    
    // Create a missle
    self.coords = [GMSMutablePath path];
    
    //current location
    [self.coords addLatitude:fromCoordinate.latitude longitude:fromCoordinate.longitude];
    
    // to destination
    [self.coords addLatitude:toCoordinate.latitude longitude:toCoordinate.longitude];
    
    self.heading = GMSGeometryHeading(self.fromCoordinate, self.toCoordinate);

    marker = [GMSMarker markerWithPosition:[self.coords coordinateAtIndex:0]];
    marker.icon = [UIImage imageNamed:@"bullet2x"];
    marker.map = self.view;
    marker.flat = YES;
    marker.rotation = self.heading;
    [self animateToNextCoord:marker];
    
}


- (void)animateToNextCoord:(GMSMarker *)marker {
    
//    CLLocationDistance distance = GMSGeometryDistance(self.fromCoordinate , self.toCoordinate);
    
    // Use CATransaction to set a custom duration for this animation. By default, changes to the
    // position are already animated, but with a very short default duration. When the animation is
    // complete, trigger another animation step.
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:self.animationDuration];  // custom duration, 50km/sec
    [CATransaction setCompletionBlock:^{
        marker.map = nil;

    }];
    
    marker.position = self.toCoordinate;
    
    [CATransaction commit];
    
    // If this marker is flat, implicitly trigger a change in rotation, which will finish quickly.
    if (marker.flat) {
        marker.rotation = self.heading;
    }
        
\
}


@end

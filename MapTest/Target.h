//
//  Target.h
//  Snipey
//
//  Created by Gabriel Guerrero on 3/30/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface Target : NSObject <MKAnnotation>

// Required properties when using MKAnnotation
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSString *distanceString;
@property (nonatomic) CLLocation *targetLocation;
@property (nonatomic) CLLocation *userLocation;
@property (nonatomic) double distance;


- (id) initWithTargetNumber:(NSString *)target
                   location:(CLLocation *) targetLocation
           fromUserLocation:(CLLocation *) userLocation;


@end

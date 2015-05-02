//
//  ViewController.h
//  Snipey
//
//  Created by Gabriel Guerrero on 3/23/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Projectile.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

+ (double) convertToDegrees:(double)pitch;



@end


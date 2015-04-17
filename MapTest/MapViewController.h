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

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate>

//@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *locationManager;

+ (double) convertToDegrees:(double)pitch;

@end


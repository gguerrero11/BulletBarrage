//
//  HitChecker.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/10/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "HitChecker.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "UserController.h"

@implementation HitChecker

//+ (void) hitCheckerAtLocation:(CLLocation *)hitLocation {
//    
//    // Create crater coordinates
//    // Sets coordinates for the opposite side corners for the overlay (crater)
//    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(hitLocation.coordinate.latitude + 100.0/111111.0, hitLocation.coordinate.longitude + 100.0/111111.0);
//    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(hitLocation.coordinate.latitude - 100.0/111111.0, hitLocation.coordinate.longitude - 100.0/111111.0);
//    
//    GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest
//                                                                              coordinate:northEast];
//    GMSGroundOverlay *groundOverlay = [GMSGroundOverlay groundOverlayWithBounds:overlayBounds
//                                                                           icon:[UIImage imageNamed:@"craterBigSquare"]];
//    groundOverlay.map = gmMapView;
//    [self performSelector:@selector(removeGMOverlay:) withObject:groundOverlay afterDelay:3];
//    
//    // Goes through each marker in the array and checks if that marker's position is within 100 (hardcoded) meters of the hitlocation
//    for (GMSMarkerWithUser *marker in [UserController sharedInstance].arrayOfMarkers) {
//        CLLocationCoordinate2D positionOfMarker = marker.position;
//        CLLocation *locationOfMarker = [[CLLocation alloc]initWithCoordinate:positionOfMarker altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]];
//        if ([locationOfMarker distanceFromLocation:hitLocation] < 100) {
//            
//            // Adds +1 to the "shotsHit" on Parse
//            NSNumber *shotsHit = [PFUser currentUser][shotsHitKey];
//            double doubleShotsHit = [shotsHit integerValue] + 1;
//            //NSLog(@"%f", doubleShotsHit);
//            [PFUser currentUser][shotsHitKey] = [NSNumber numberWithDouble:doubleShotsHit];
//            
//            // Create HIT label with animation
//            UILabel *hitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 100)];
//            [self.view addSubview:hitLabel];
//            hitLabel.text = @"HIT!";
//            hitLabel.textAlignment = NSTextAlignmentCenter;
//            hitLabel.textColor = [UIColor redColor];
//            hitLabel.font = [UIFont boldSystemFontOfSize:50];
//            
//            // animates the HIT label
//            CGAffineTransform scaleTransformHIT = CGAffineTransformMakeScale(.94, .94);
//            [UIView animateWithDuration:0.5 animations:^{
//                hitLabel.alpha = 0.0;
//                hitLabel.center = CGPointMake(hitLabel.center.x, hitLabel.center.y - 14);
//                hitLabel.transform = scaleTransformHIT;
//                
//            } completion:^(BOOL finished) {
//                [hitLabel removeFromSuperview];
//            }];
//            
//            // checks if its the longest distance hit, if it is, saves to Parse
//            NSNumber *currentLongestDistance = [PFUser currentUser][longestDistanceKey];
//            NSLog(@"dist from Parse: %@", currentLongestDistance);
//            if (marker.distance > [currentLongestDistance doubleValue]) {
//                NSNumber *newDistance = [NSNumber numberWithDouble:marker.distance];
//                [PFUser currentUser][longestDistanceKey] = newDistance;
//                NSLog(@"new distance: %@", newDistance);
//                
//                // Create New Record label with animation
//                UILabel *newRecordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 100)];
//                [self.view addSubview:newRecordLabel];
//                newRecordLabel.text = @"NEW DISTANCE RECORD!";
//                newRecordLabel.textAlignment = NSTextAlignmentCenter;
//                newRecordLabel.textColor = [UIColor redColor];
//                newRecordLabel.font = [UIFont boldSystemFontOfSize:25];
//                
//                // animates the new record label
//                CGAffineTransform scaleTransformNEWRECORD = CGAffineTransformMakeScale(.94, .94);
//                [UIView animateWithDuration:2.0 animations:^{
//                    newRecordLabel.alpha = 0.0;
//                    newRecordLabel.center = CGPointMake(newRecordLabel.center.x, newRecordLabel.center.y - 14);
//                    newRecordLabel.transform = scaleTransformNEWRECORD;
//                    
//                } completion:^(BOOL finished) {
//                    [newRecordLabel removeFromSuperview];
//                }];
//                
//                
//            }
//            
//        }
//        
//    }
//}


@end

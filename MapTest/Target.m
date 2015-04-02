//
//  Target.m
//  Snipey
//
//  Created by Gabriel Guerrero on 3/30/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "Target.h"

@implementation Target

- (id) initWithTargetNumber:(NSString *)target
                   location:(CLLocation *)targetLocation
           fromUserLocation:(CLLocation *)userLocation

{
    self = [super init];
    if (self) {
        _targetLocation = targetLocation;
        _userLocation = userLocation;

        _coordinate = targetLocation.coordinate;
        _title = [NSString stringWithFormat:@"Target %@", target];
        _subtitle = [NSString stringWithFormat:@"Distance: %@m", [self determineDistance]];
        
            }
    return self;
}

- (NSString *)determineDistance {
    _distance = [self.targetLocation distanceFromLocation:self.userLocation];
    NSString *returnString = [NSString stringWithFormat:@"%.0f", _distance];
    return returnString;
}


//- (void)setDistanceString:(NSString *)distanceString {
//    self.distance = [self.targetLocation distanceFromLocation:self.userLocation];
//    NSString *returnString = [NSString stringWithFormat:@"%@", self.distanceString];
//    _distanceString = returnString;
//
//}

@end

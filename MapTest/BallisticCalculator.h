//
//  BallisticCalculator.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/21/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BallisticCalculator : NSObject

- (double) getFlightTimeFromVelocity:(double)vel radians:(double)rad;
- (double) getRangeFromVelocity:(double)vel radians:(double)rad;

@end
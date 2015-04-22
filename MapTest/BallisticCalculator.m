//
//  BallisticCalculator.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/21/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//
// Uses calculations based on methods by Copyright © 2004, Stephen R. Schmitt
// http://www.convertalot.com/ballistic_trajectory_calculator.html


#import "BallisticCalculator.h"
#import "MapViewController.h"

static double gravity = 9.8;

@interface BallisticCalculator ()

@property (nonatomic, assign) double range;
@property (nonatomic, assign) double velocity;
@property (nonatomic, assign) double radians;
@property (nonatomic) double tFlight;

@property (nonatomic, assign) double x;
@property (nonatomic, assign) double xO;
@property (nonatomic, assign) double Vxo;

@property (nonatomic, assign) double y;
@property (nonatomic, assign) double heightFromGround;
@property (nonatomic, assign) double Vyo;

@property (nonatomic, assign) double tRise;

@property (nonatomic, assign) double maxHeight;

@property (nonatomic, assign) double tFall;

@end



@implementation BallisticCalculator

// internal properties
double degrees;

- (double) getFlightTimeFromVelocity:(double)vel radians:(double)rad {
    self.radians = rad;
    self.velocity = vel;
//    self.radians = rad;
    return self.tFlight;
}

- (double) getRangeFromVelocity:(double)vel radians:(double)rad {
    self.radians = rad;
    self.velocity = vel;
//    self.radians = rad;
    return self.range;
}

#pragma mark Calculations

/*
 "The motion of an object moving near the surface of the earth can be described using the equations:"
 */

- (double)x {
    return self.xO + self.Vxo * self.tFlight;
}

- (double)y {
    return self.heightFromGround + self.Vyo * self.tRise - 0.5 * gravity * pow(self.tRise, 2);
}

/*
 "The calculator solves these two simultaneous equations to obtain a description of the ballistic trajectory. The horizontal and vertical components of initial velocity are determined from:"
*/

- (double)Vxo {
    return self.velocity * cos(self.radians);
}

- (double)Vyo {
    return self.velocity * sin(self.radians);
}

/*
 "Then the calculator computes the time to reach the maximum height by finding the time at which vertical velocity becomes zero:"
 */

- (double)tRise {
    return self.Vyo / gravity;
}

/*
 "Maximum height is obtained by substitution of this time into equation (2)."
 */

- (double)maxHeight {
    self.heightFromGround = 2.4;
//        NSLog(@"maxHeight %f", self.heightFromGround + self.Vyo * self.tRise - 0.5 * gravity * pow(self.tRise, 2));
//    NSLog(@"pow %f", pow(self.tRise, 2));
    return self.heightFromGround + self.Vyo * self.tRise - 0.5 * gravity * pow(self.tRise, 2);
}

/*
 "Next, the time to fall from the maximum height is computed by solving equation (2) for an object dropped from the maximum height with zero initial velocity."
 */


- (double)tFall {
    return sqrt(2 * self.maxHeight / gravity);
}

/*
  "The total flight time of the projectile is then:"
*/

- (double)tFlight {
    return self.tRise + self.tFall;
}
/*
 "From this, equation (1) gives the maximum range:"
 */

- (double)range {
    return self.Vxo * self.tFlight;
}




@end

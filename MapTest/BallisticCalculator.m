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

static double gravity = 9.8;

@interface BallisticCalculator ()


@end



@implementation BallisticCalculator

double velocity;
double radians;
double range;
double tFlight;

// internal properties
double x;
double xO;
double Vxo;
double tTime;

double y;
double heightFromGround;
double Vyo;

double Vy;
double tRise;

double maxHeight;

double tFall;


+ (double) getFlightTimeFromVelocity:(double)vel radians:(double)rad {
    velocity = vel;
    radians = rad;
    return tFlight;
}

+ (double) getRangeFromVelocity:(double)vel radians:(double)rad {
    velocity = vel;
    radians = rad;
    return range;
}


#pragma mark Calculations

/*
 "The motion of an object moving near the surface of the earth can be described using the equations:"
 */

- (double) x {
    return xO + Vxo * tTime;
}

- (double) y {
    return heightFromGround + Vyo * tTime - 0.5 * gravity * pow(tTime, 2);
}


/*
 "The calculator solves these two simultaneous equations to obtain a description of the ballistic trajectory. The horizontal and vertical components of initial velocity are determined from:"
*/

- (double)Vxo {
    return velocity * cos(radians);
}

- (double)Vyo {
    return velocity * sinh(radians);
}

/*
 "Then the calculator computes the time to reach the maximum height by finding the time at which vertical velocity becomes zero:"
 */

- (double)Vy {
    return Vyo - (gravity * tTime);
}

- (double)tRise {
    return Vyo / gravity;
}

/*
 "Maximum height is obtained by substitution of this time into equation (2)."
 */

- (double)maxHeight {
    return heightFromGround + Vyo * tTime - 0.5 * gravity * pow(tTime, 2);
}

/*
 "Next, the time to fall from the maximum height is computed by solving equation (2) for an object dropped from the maximum height with zero initial velocity."
 */


- (double) tFall {
    return sqrt(2 * maxHeight / gravity);
}

/*
  "The total flight time of the projectile is then:"
*/

- (double) tFlight {
    return tRise + tFall;
}

/*
 "From this, equation (1) gives the maximum range:"
 */

- (double) range {
    return Vxo * tFlight;
}




@end

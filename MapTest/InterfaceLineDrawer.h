//
//  InterfaceLineDrawer.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/16/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <GoogleMaps/GoogleMaps.h>

static NSString * const right = @"right";
static NSString * const left = @"left";

@interface InterfaceLineDrawer : UIView

- (instancetype)initWithFrame:(CGRect)frame withView:(UIView *)view;

@property (nonatomic, strong) CMAttitude *attitude;
@property (nonatomic, strong) GMSCameraPosition *mapCamera;

- (void) move:(NSString *)side boxBasedByValue:(double)value;
- (void) drawRandomLines;

@end

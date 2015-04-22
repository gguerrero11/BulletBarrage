//
//  ColorRandomizer.m
//  Day4StretchProblem-RandomColor
//
//  Created by Gabriel Guerrero on 2/19/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "UIColor+InterfaceColors.h"
#define RGBA(R, G, B, A) ([UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A])

@implementation UIColor (InterfaceColors)

+ (UIColor *)screenTintColor {
    return RGBA(123.0, 204.0, 123.0, .3);
}

+ (UIColor *)lineColor {
    return  RGBA(123.0,255.0, 112.0, 1);
}

+ (UIColor *)labelColor {
    return  RGBA(123.0, 255.0, 112.0, 1);
}

+ (UIColor *)transparentBox {
    return  RGBA(123.0, 204.0, 112.0, .25);
}

@end


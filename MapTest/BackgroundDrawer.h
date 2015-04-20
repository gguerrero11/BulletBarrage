//
//  BackgroundDrawer.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/18/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BackgroundDrawer : NSObject

@property (nonatomic, assign) BOOL shouldContinue;

- (void)setUpBackgroundOnView:(UIView *)passedView nameOfView:(NSString *)nameOfView;

- (void)continueDrawing;

- (void)enterAnimation;

- (void) hideBarElements;

@end

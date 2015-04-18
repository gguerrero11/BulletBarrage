//
//  BackgroundDrawer.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/18/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//



#import "BackgroundDrawer.h"

static NSString * const flakLines = @"flakLines";
static NSString * const backgroundGrid = @"backgroundGrid";

@interface BackgroundDrawer ()

@property (nonatomic,strong) UIView *view;

@end

@implementation BackgroundDrawer

// set up background image
- (void) setUpBackgroundOnView:(UIView *)passedView {
    self.view = passedView;
    
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundImage.image = [UIImage imageNamed:@"leaderBoardScreenBlue"];
    [self.view addSubview:backgroundImage];
    
    [self drawGridBGImages:backgroundGrid];
    
    [self drawGridBGImages:flakLines];
    
}

- (void) drawGridBGImages:(NSString *)type {
    
    double randomWidth = 0;
    double randomHeight = 0;
    
    if ([type isEqualToString:flakLines]) {
        // sets random width from 600 - 800
        randomWidth = arc4random() % 200 + 600.0;
        
        // sets the height based on the percentage of the size of the randomWidth to its maximum size
        randomHeight = 508 * (randomWidth / 800);
    }
    if ([type isEqualToString:backgroundGrid]) {
        // sets random width from 400 - 2800
        randomWidth = arc4random() % 2400 + 400.0;
        
        // sets the height based on the percentage of the size of the randomWidth to its maximum size
        randomHeight = 1400.0 * (randomWidth / 2800.0);
    }
    
    // create the "grid" background
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, randomWidth, randomHeight)];
    backgroundImage.image = [UIImage imageNamed:type];
    [self.view addSubview:backgroundImage];
    
    // set the new X,Y destination of the frame.
    double newX = arc4random() % 400 - 200.0;
    double newY = arc4random() % 400 - 200.0;

    int timeOfAnimation = arc4random() % 10 + 55;
    
        NSLog(@"%f, %f", newX, newY);
    
    // don't rotate the image randomly if its if the "flakLines" image
    CGAffineTransform rotationTransform;
    if ([type isEqualToString:flakLines]) rotationTransform = CGAffineTransformMakeRotation(0);
    else rotationTransform = CGAffineTransformMakeRotation(arc4random());
    
    backgroundImage.transform = rotationTransform;
    backgroundImage.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    backgroundImage.alpha = 0;
    
    // animates the fade in, by alpha (independent from the motion animation)
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         backgroundImage.alpha = .1;
                     }
                     completion:nil];
    
    // animate the movement of the image
    [UIView animateWithDuration:timeOfAnimation
                     animations:^{
                         backgroundImage.center = CGPointMake(newX, newY);
                     }
                     completion:^(BOOL finished) {
                         // animate a fade out once the movement animation is done.
                         [UIView animateWithDuration:1.0
                                          animations:^{
                                              backgroundImage.alpha = 0;
                                          }
                                          completion:^(BOOL finished) {
                                              // remove it from the view and call the method again
                                              [backgroundImage removeFromSuperview];
                                              [self performSelector:@selector(drawGridBGImages:) withObject:type];
                                          }];
                     }];
}


@end

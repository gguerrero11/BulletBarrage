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

@property (nonatomic) UIView *view;
@property (nonatomic) UIImageView *gridImageView;
@property (nonatomic) UIImageView *flakImageView;
@property (nonatomic) UIImageView *backgroundImage;


@end

@implementation BackgroundDrawer

// set up background image
- (void) setUpBackgroundOnView:(UIView *)passedView {
    self.view = passedView;
    
    self.gridImageView.image = [UIImage imageNamed:flakLines];
    self.flakImageView.image = [UIImage imageNamed:flakLines];
    
    self.backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.backgroundImage.image = [UIImage imageNamed:@"leaderBoardScreenBlue"];
    [self.view addSubview:self.backgroundImage];
    
    [self continueDrawing];
}


- (void) drawGridBGImages:(NSString *)type {

    UIImageView *backgroundImage;
    
    // runs when bool is set to YES, (when the user is at the current screen the animation is needed)
    if (self.shouldContinue) {
        double randomWidth = 0;
        double randomHeight = 0;
        
        if ([type isEqualToString:flakLines]) {
            
            backgroundImage = self.flakImageView;
            
            // sets random width from 600 - 800
            randomWidth = arc4random() % 200 + 600.0;
            
            // sets the height based on the percentage of the size of the randomWidth to its maximum size
            randomHeight = 508 * (randomWidth / 800);
        }
        if ([type isEqualToString:backgroundGrid]) {
            
            backgroundImage = self.gridImageView;
            
            // sets random width from 400 - 2800
            randomWidth = arc4random() % 2400 + 400.0;
            
            // sets the height based on the percentage of the size of the randomWidth to its maximum size
            randomHeight = 1400.0 * (randomWidth / 2800.0);
        }

        
        // create the "grid" background
        backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, randomWidth, randomHeight)];
        backgroundImage.image = [UIImage imageNamed:type];
        [self.backgroundImage addSubview:backgroundImage];
        
        CGPoint randomCenter = CGPointMake(self.view.frame.size.width / 2.0 , self.view.frame.size.height / 2.0 );
        
        // set the new X,Y destination of the frame.
        double newX = arc4random() % 200 + 200;
        double newY = arc4random() % 200 + 200;
        int timeOfAnimation = arc4random() % 10 + 15;
        
        // don't rotate the image randomly if its if the "flakLines" image
        CGAffineTransform rotationTransform;
        if ([type isEqualToString:flakLines]) rotationTransform = CGAffineTransformMakeRotation(0);
        else rotationTransform = CGAffineTransformMakeRotation(fmodf(arc4random(), 360.0f));
        
        backgroundImage.transform = rotationTransform;
        backgroundImage.center = randomCenter;
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
                                                  backgroundImage.center = randomCenter;
                                                  
                                                  // remove it from the view and call the method again
                                                  
                                                  [self performSelector:@selector(drawGridBGImages:) withObject:type];
                                              }];
                         }];
    }
}

- (void)continueDrawing {

    [self drawGridBGImages:backgroundGrid];
    [self drawGridBGImages:flakLines];
}

@end

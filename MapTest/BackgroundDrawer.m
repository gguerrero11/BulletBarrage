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
static NSString * const metalPlate = @"metalPlate";

@interface BackgroundDrawer ()

@property (nonatomic) UIView *view;
@property (nonatomic) UIImageView *gridImageView;
@property (nonatomic) UIImageView *flakImageView;
@property (nonatomic) UIImageView *backgroundImage;
@property (nonatomic) UIImageView *foreGroundBars;
@property (nonatomic) UIImageView *barrelRing;
@property (nonatomic) UIButton *metalPlateButton;
@property (nonatomic, strong) NSString *nameOfView;
@property (nonatomic, assign) double randomRotation;
@property (nonatomic) UILabel *metalPlateLabel;
@property (nonatomic, assign) BOOL initalStart;

@end

@implementation BackgroundDrawer


// set up background image
- (void)setUpBackgroundOnView:(UIView *)passedView nameOfView:(NSString *)nameOfView {
    self.view = passedView;
    self.nameOfView = nameOfView;
    self.gridImageView.image = [UIImage imageNamed:flakLines];
    self.flakImageView.image = [UIImage imageNamed:flakLines];
    
    self.backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.backgroundImage.image = [UIImage imageNamed:@"leaderBoardScreenBlue"];
    self.backgroundImage.userInteractionEnabled = NO;
//    [self.view addSubview:self.backgroundImage];
    
    [self.view insertSubview:self.backgroundImage atIndex:0];
    
    [self continueDrawing];
    [self drawForegroundBars];
    [self drawRadialRing];
}

- (void)drawForegroundBars {
    
    self.foreGroundBars = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.foreGroundBars.image = [UIImage imageNamed:@"metalBars"];
    self.foreGroundBars.hidden = YES;
    [self.view addSubview:self.foreGroundBars];
    
}

- (void)drawRadialRing {
    
    self.barrelRing = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.height)];
    [self.barrelRing setCenter:CGPointMake(self.view.center.x,
                                           self.view.center.y - self.view.center.y * (17 / self.view.frame.size.height))];
    self.barrelRing.image = [UIImage imageNamed:@"barrelRing"];
    self.barrelRing.hidden = YES;
    self.barrelRing.userInteractionEnabled = NO;
    [self.foreGroundBars addSubview:self.barrelRing];
    
}

- (void)drawMetalPlateWithWidth:(double)width height:(double)height {
    if (!self.metalPlateButton) {
    self.metalPlateButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - width / 2, 10, width, height)];
    self.metalPlateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.metalPlateButton.frame.size.width, self.metalPlateButton.frame.size.height)];

    }
    self.metalPlateButton.hidden = YES;
    [self.metalPlateButton setImage:[UIImage imageNamed:@"metalPlate"] forState:UIControlStateNormal];
    [self.view addSubview:self.metalPlateButton];
    [self.metalPlateButton addTarget:self action:@selector(correctMetalPlateRotation:) forControlEvents:UIControlEventTouchDown];
    self.metalPlateButton.adjustsImageWhenHighlighted = NO;
    
    self.metalPlateLabel.textAlignment = NSTextAlignmentCenter;
    self.metalPlateLabel.text = self.nameOfView;
    self.metalPlateLabel.alpha = .8;
    self.metalPlateLabel.font = [UIFont boldSystemFontOfSize:20.0];
    self.metalPlateLabel.textColor = [UIColor whiteColor];
    [self.metalPlateButton addSubview:self.metalPlateLabel];
    
    [self animateMetalPlate:self.metalPlateButton];
}

- (void)animateMetalPlate:(UIButton *) metalPlateView  {
    
    self.randomRotation = fmodf(arc4random(), 0.6f) - 0.3f;
    
    // beginning transform
    CGAffineTransform beginScaleTransform = CGAffineTransformMakeScale(1.4, 1.4);
    CGAffineTransform rotationBeginTransform = CGAffineTransformMakeRotation(0);
    metalPlateView.hidden = NO;
    metalPlateView.transform = CGAffineTransformConcat(beginScaleTransform, rotationBeginTransform);
    metalPlateView.alpha = 0;
    
    // ending transform
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1, 1);
//    CGAffineTransform rotationEndTransform = CGAffineTransformMakeRotation(M_PI + self.randomRotation);
        CGAffineTransform rotationEndTransform = CGAffineTransformMakeRotation(self.randomRotation);
    
    NSLog(@"%f", self.randomRotation);
    
    [UIView animateWithDuration:.1 delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        metalPlateView.transform = CGAffineTransformConcat(scaleTransform, rotationEndTransform);
        metalPlateView.alpha = 1;
    } completion:^(BOOL finished) {
       
    }];
}

- (void)correctMetalPlateRotation:(id)sender {
    
    NSLog(@"%f", M_PI + (-self.randomRotation));
    
    UIButton *metalPlateButton = sender;
    
    
    CGAffineTransform rotationEndTransform = CGAffineTransformMakeRotation(0);
    
    [UIView animateWithDuration:.1 delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         metalPlateButton.transform = rotationEndTransform;
                     } completion:nil];
}



- (void)animateRing {
    
    if (self.shouldContinue) {
        
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(M_PI);
        CGAffineTransform rotationEndTransform = CGAffineTransformMakeRotation(M_PI * 2);
        
        [UIView animateWithDuration:45
                              delay:0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.barrelRing.transform = rotationTransform;
                         }
                         completion:^(BOOL finished) {
                             
                             

                             [UIView animateWithDuration:45
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                                              animations:^{
                                                  self.barrelRing.transform = rotationEndTransform;
                                              }
                                              completion:^(BOOL finished) {
                                                  [self animateRing];
                                              
                                              
                                              
                                              }];
                         }];
    }
}

- (void)drawGridBGImages:(NSString *)type {
    
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
    [self animateRing];
}

- (void)enterAnimation {
    
    CGAffineTransform beginScaleTransform = CGAffineTransformMakeScale(1.4, 1.4);
    self.foreGroundBars.transform = beginScaleTransform;
    
    self.barrelRing.hidden = NO;
    self.foreGroundBars.hidden = NO;
    
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1, 1);
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.foreGroundBars.transform = scaleTransform;
    } completion:^(BOOL finished) {
        [self drawMetalPlateWithWidth:250 height:60];
        
    }];
    
}

- (void)hideBarElements {
    self.barrelRing.hidden = YES;
    self.foreGroundBars.hidden = YES;
        self.metalPlateButton.hidden = YES;
}

@end

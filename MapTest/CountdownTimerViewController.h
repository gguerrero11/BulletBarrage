//
//  CountdownTimerViewController.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/10/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownTimerViewController : UIViewController {
    
    NSTimer *timer;
    UILabel *myCounterLabel;
}

@property (nonatomic, retain) UILabel *myCounterLabel;
@property (nonatomic, assign) int secondsLeft;
@property (nonatomic, assign) int millisecondsLeft;

- (id) initWithSeconds:(double)seconds;

-(void)updateCounter:(NSTimer *)theTimer;
-(void)countdownTimer;

@end
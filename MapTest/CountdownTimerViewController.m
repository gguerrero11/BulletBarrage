//
//  CountdownTimerViewController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/10/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "CountdownTimerViewController.h"
#import "SoundController.h"


@interface CountdownTimerViewController ()

@end

@implementation CountdownTimerViewController



int hours, minutes, seconds, milliseconds;

- (id) initWithSeconds:(double)passedSeconds {
    self = [super init];
    if (self) {
        self.timer = [NSTimer new];
        _millisecondsLeft = passedSeconds * 1000;
        NSLog(@"%d", _millisecondsLeft);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeAdvisoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    self.timeAdvisoryLabel.textAlignment = NSTextAlignmentCenter;
    self.timeAdvisoryLabel.text = [NSString stringWithFormat:@"ETA till impact:"];
    [self.view addSubview:self.timeAdvisoryLabel];
    
    hours = self.millisecondsLeft / 3600000;
    minutes = (self.millisecondsLeft - hours * 3600000) / 60000;
    seconds = ((self.millisecondsLeft - hours * 3600000) - minutes * 60000) / 1000;
    milliseconds = self.millisecondsLeft % 10;
    
    self.myCounterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 100)];
    self.myCounterLabel.textAlignment = NSTextAlignmentCenter;
    self.myCounterLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d:%01d", hours, minutes, seconds, milliseconds];
    [self.view addSubview:self.myCounterLabel];
    
    [self countdownTimer];
}

- (void)updateCounter:(NSTimer *)theTimer {
    
    // play missle Sound if less than 6 seconds left
    if (hours == 0 && minutes == 0 && seconds == 5 && milliseconds == 5) {
        
// [[SoundController sharedInstance] playSoundEffect:missleImpact];
    }
    
    if (hours < 0 && minutes < 0 && seconds < 0 && milliseconds < 0) {
        [self.timer invalidate];
        [self.view removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"timerDone" object:nil];
    }
    if (seconds < 0 ) seconds = 0;
    if (minutes < 0 ) minutes = 0;
    if (hours < 0 ) hours = 0;
    
    if (milliseconds > -1)
    {
        milliseconds --;
        if (milliseconds == -1)
        {
            seconds --;
            milliseconds = 9;
            if (seconds == -1 )
            {
                minutes --;
                seconds = 59;
                if (minutes == -1)
                {
                    hours --;
                    minutes = 59;
                }
            }
        }
    }
    self.myCounterLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d:%01d", hours, minutes, seconds, milliseconds];
    
}

-(void)countdownTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

@end

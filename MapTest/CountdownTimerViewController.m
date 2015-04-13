//
//  CountdownTimerViewController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/10/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "CountdownTimerViewController.h"

@interface CountdownTimerViewController ()

@end

@implementation CountdownTimerViewController
@synthesize myCounterLabel;

int hours, minutes, seconds, milliseconds;

- (id) initWithSeconds:(double)passedSeconds {
    self = [super init];
    if (self) {
        _millisecondsLeft = passedSeconds * 1000;
        
        NSLog(@"%d", _millisecondsLeft);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myCounterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 100)];
    self.myCounterLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.myCounterLabel];
    
    hours = self.millisecondsLeft / 3600000;
    minutes = self.millisecondsLeft / 60000;
    seconds = self.millisecondsLeft / 1000;
    milliseconds = self.millisecondsLeft % 10;
    
    
    myCounterLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d:%01d", hours, minutes, seconds, milliseconds];
    
    [self countdownTimer];
}

- (void)updateCounter:(NSTimer *)theTimer {
    if (hours == 0 && minutes == 0 && seconds == 0 && milliseconds == 0) {
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
            if (seconds == 0 )
            {
                 minutes --;
                if (minutes == 0)
                {
                    hours --;
                }
            }
        }
    }
    myCounterLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d:%01d", hours, minutes, seconds, milliseconds];
    
}


-(void)countdownTimer{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

@end

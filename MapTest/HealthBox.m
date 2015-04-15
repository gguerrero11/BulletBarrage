//
//  HealthBox.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/14/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "HealthBox.h"
#import <Parse/Parse.h>

@implementation HealthBox

- (instancetype)initWithFrame:(CGRect)frame healthData:(HealthData *)healthData {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor redColor];
        
        // Set up Pitch Label
        UILabel *health = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        health.textAlignment = NSTextAlignmentCenter;
        health.text = @"Health";
        health.textColor = [UIColor whiteColor];
        [self addSubview:health];
        
        // Set up Pitch Label Data
        UILabel *healthOfUser = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 50)];
        healthOfUser.textAlignment = NSTextAlignmentCenter;
        healthOfUser.font = [UIFont boldSystemFontOfSize:30];
//        healthOfUser.text = [NSString stringWithFormat:@"%f", [HealthDataController retrieveHealthForUser:[PFUser currentUser]]];
        healthOfUser.textColor = [UIColor whiteColor];
        [self addSubview:healthOfUser];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

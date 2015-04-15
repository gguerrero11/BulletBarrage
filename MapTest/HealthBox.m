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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self registerForNotifications];
        
        self.backgroundColor = [UIColor redColor];
        
        // Set up health Label
        UILabel *healthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        healthLabel.textAlignment = NSTextAlignmentCenter;
        healthLabel.text = @"Health";
        healthLabel.textColor = [UIColor whiteColor];
        [self addSubview:healthLabel];
        
        }
    return self;
}

- (void) registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHealthData) name:@"healthQueryDone" object:nil];
}

- (void) updateHealthData {
    
    HealthData *currentUserHealthData = [HealthDataController sharedInstance].currentUserHealthData;
    NSNumber *healthNumber = currentUserHealthData[healthKey];
    
    // Set up health Label Data
    UILabel *healthOfUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 50)];
    healthOfUserLabel.textAlignment = NSTextAlignmentCenter;
    healthOfUserLabel.font = [UIFont boldSystemFontOfSize:30];
    healthOfUserLabel.text = [NSString stringWithFormat:@"%lu", [healthNumber integerValue]];
    healthOfUserLabel.textColor = [UIColor whiteColor];
    [self addSubview:healthOfUserLabel];

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

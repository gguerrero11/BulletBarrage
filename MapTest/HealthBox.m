//
//  HealthBox.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/14/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "HealthBox.h"
#import <Parse/Parse.h>
#import "UIColor+InterfaceColors.h"

@implementation HealthBox



//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];

- (id) initWithView:(UIView *)view {
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor transparentBox];
        self.layer.borderWidth = 1.5;
        self.layer.borderColor = [UIColor lineColor].CGColor;
        
        // adds glow to the lines
        self.layer.shadowOpacity = .9;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 3.5;
        self.layer.shadowColor = [UIColor lineColor].CGColor;
        
        double xOrigin = view.frame.size.width * .2;
        double widthOfBox = view.frame.size.width - xOrigin * 2;
        double heightOfBox = 30;
        
        self.frame = CGRectMake(xOrigin, 0, widthOfBox, heightOfBox);
        
        [self registerForNotifications];
        
        // Set up health Label
        UILabel *healthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, self.frame.size.width, 10)];
        healthLabel.textAlignment = NSTextAlignmentCenter;
        healthLabel.text = @"DAMAGE TAKEN";
        healthLabel.font = [UIFont fontWithName:@"Menlo" size:10];
        healthLabel.textColor = [UIColor healthBarOrange];
        [self addSubview:healthLabel];
        
        self.healthOfUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 50)];
        self.healthOfUserLabel.textAlignment = NSTextAlignmentCenter;
        self.healthOfUserLabel.font = [UIFont boldSystemFontOfSize:30];
        self.healthOfUserLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.healthOfUserLabel];
        }
    
    // setup health bar
    double healthBarHeight = 10;
    double healthBarXOrigin = 5;
    double healthBarYOrigin = self.frame.size.height - healthBarXOrigin - healthBarHeight;
    double healthBarWidth = self.frame.size.width - healthBarXOrigin * 2;

    UIView *healthBarBorder = [[UIView alloc]initWithFrame:CGRectMake(healthBarXOrigin, healthBarYOrigin, healthBarWidth, healthBarHeight)];
    healthBarBorder.layer.borderColor = [UIColor healthBarOrange].CGColor;
    healthBarBorder.layer.borderWidth = 1.5;
    healthBarBorder.backgroundColor = [UIColor healthBarOrangeTransparent];
    [self addSubview:healthBarBorder];
    
    // setup health bar progress
    UIView *healthBarProgress = [[UIView alloc]initWithFrame:CGRectMake(healthBarXOrigin, healthBarYOrigin, healthBarWidth, healthBarHeight)];
    healthBarBorder.backgroundColor = [UIColor healthBarOrange];
    [self addSubview:healthBarProgress];

    
    
    return self;
}

- (void) registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHealthData) name:@"healthQueryDone" object:nil];
}

- (void) updateHealthData {
    
    self.currentUserHealthData = [[HealthDataController sharedInstance] retrieveHealthDataFromUser:[PFUser currentUser]];
    NSNumber *healthNumber = self.currentUserHealthData[healthKey];

    // Set up health Label Data
    self.healthOfUserLabel.text = [NSString stringWithFormat:@"%lu", (long)[healthNumber integerValue]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

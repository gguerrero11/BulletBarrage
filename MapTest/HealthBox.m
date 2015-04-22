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

@interface HealthBox ()

@property (nonatomic) UIView *healthBarProgress;
@property (nonatomic) UIView *healthBarBorder;
@property (nonatomic, assign) double frameHeight;
@property (nonatomic, assign) double frameWidth;



@end

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
//                self.healthBarProgress.layer.shadowOpacity = .9;
//                self.healthBarProgress.layer.shadowOffset = CGSizeMake(0, 0);
//                self.healthBarProgress.layer.shadowRadius = 3.5;
//                self.healthBarProgress.layer.shadowColor = [UIColor lineColor].CGColor;
        
        double xOrigin = view.frame.size.width * .2;
        double widthOfBox = view.frame.size.width - xOrigin * 2;
        double heightOfBox = 30;
        
        self.frame = CGRectMake(xOrigin, 5, widthOfBox, heightOfBox);
        
        [self registerForNotifications];
        
        // Set up health Label
        UILabel *healthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, self.frame.size.width, 10)];
        healthLabel.textAlignment = NSTextAlignmentCenter;
        healthLabel.text = @"DAMAGE TAKEN";
        healthLabel.font = [UIFont fontWithName:@"Menlo" size:10];
        healthLabel.textColor = [UIColor healthBarColor];
        [self addSubview:healthLabel];
        
        // setup health bar
        double healthBarHeight = 10;
        double healthBarXOrigin = 5;
        double healthBarYOrigin = self.frame.size.height - healthBarXOrigin - healthBarHeight;
        double healthBarWidth = self.frame.size.width - healthBarXOrigin * 2;
        
        self.healthBarBorder = [[UIView alloc]initWithFrame:CGRectMake(healthBarXOrigin, healthBarYOrigin, healthBarWidth, healthBarHeight)];
        self.healthBarBorder.layer.borderColor = [UIColor healthBarColor].CGColor;
        self.healthBarBorder.layer.borderWidth = 1;
        self.healthBarBorder.backgroundColor = [UIColor healthBarColorTransparent];
        [self addSubview:self.healthBarBorder];
        
        // setup health bar progress
        self.healthBarProgress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, healthBarHeight)];
        self.healthBarProgress.backgroundColor = [UIColor healthBarColor];
        [self.healthBarBorder addSubview:self.healthBarProgress];
        
        self.healthOfUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, 10)];
        self.healthOfUserLabel.textAlignment = NSTextAlignmentCenter;
        self.healthOfUserLabel.font = [UIFont fontWithName:@"Menlo" size:9];
        self.healthOfUserLabel.textColor = [UIColor lineColor];
        [self.healthBarProgress addSubview:self.healthOfUserLabel];
    
    }
    
    
    return self;
}



- (void) registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHealthData) name:@"healthQueryDone" object:nil];
}

- (void) updateHealthData {

    // retrieve health number
    self.currentUserHealthData = [[HealthDataController sharedInstance] retrieveHealthDataFromUser:[PFUser currentUser]];
    NSNumber *healthNumber = self.currentUserHealthData[healthKey];
    
    // update health bar
    CGRect currentHealthBarProgressFrame = self.healthBarProgress.frame;
    double updatedWidth = (healthNumber.integerValue / 100.0) * self.healthBarBorder.frame.size.width;
    self.healthBarProgress.frame = CGRectMake(currentHealthBarProgressFrame.origin.x,
                                              currentHealthBarProgressFrame.origin.y,
                                              updatedWidth,
                                              currentHealthBarProgressFrame.size.height);
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

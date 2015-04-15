//
//  HealthBox.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/14/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthDataController.h"

@interface HealthBox : UIView <UIAlertViewDelegate>

@property (nonatomic,strong) HealthData *currentUserHealthData;
@property (nonatomic,strong) NSNumber *health;
@property (nonatomic,strong) UILabel *healthOfUserLabel;


- (instancetype)initWithFrame:(CGRect)frame;

@end


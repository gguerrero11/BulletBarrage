//
//  HealthBox.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/14/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthDataController.h"

@interface HealthBox : UIView

@property (nonatomic,strong) HealthData *healthData;

- (instancetype)initWithFrame:(CGRect)frame healthData:(HealthData *)healthData;

@end


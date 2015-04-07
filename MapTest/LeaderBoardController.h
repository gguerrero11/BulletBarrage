//
//  LeaderBoardController.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/6/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LeaderBoardController : NSObject

@property (nonatomic) NSInteger categorySelected;



+ (LeaderBoardController *) sharedInstance;

@end

//
//  LeaderBoardController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/6/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "LeaderBoardController.h"

@implementation LeaderBoardController

+ (LeaderBoardController *) sharedInstance {
    static LeaderBoardController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [LeaderBoardController new];
    });
    return sharedInstance;
}

@end

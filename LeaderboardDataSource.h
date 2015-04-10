//
//  LeaderboardDataSource.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/3/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum
{
    sortByDistance, // == 0 (by default)
    sortByKill, // == 1 (incremented by 1 from previous)
    sortByAccuracy // == 2
    
} SortMode ;

static NSString * const cellIdentifier = @"leaderboardCell";
static NSString * const usernameKey = @"username";
static NSString * const distanceKey = @"longestDistance";
static NSString * const deathKey = @"deaths";
static NSString * const killKey = @"kills";
static NSString * const objectIdKey = @"objectId";

@interface LeaderboardDataSource : NSObject  <UITableViewDataSource>

- (void)registerTableView:(UITableView *)tableView;

@property (nonatomic,assign) SortMode sortMode;

@end

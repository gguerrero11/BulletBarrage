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

static NSString *cellIdentifier = @"leaderboardCell";
static NSString *usernameKey = @"username";
static NSString *distanceKey = @"longestDistance";
static NSString *deathKey = @"deaths";
static NSString *killKey = @"kills";
static NSString *accuracyKey = @"accuracy";

@interface LeaderboardDataSource : NSObject  <UITableViewDataSource>

- (void)registerTableView:(UITableView *)tableView;

@property (nonatomic,assign) SortMode sortMode;

@end

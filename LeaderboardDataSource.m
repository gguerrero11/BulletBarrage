//
//  LeaderboardDataSource.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/3/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "LeaderboardDataSource.h"
#import "UserController.h"
#import <Parse/Parse.h>

static NSString *cellIdentifier = @"leaderboardCell";
static NSString *usernameKey = @"username";

@interface LeaderboardDataSource ()

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation LeaderboardDataSource

- (void)registerTableView:(UITableView *)tableView {
    self.tableView = tableView;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *arrayOfUsers = [[NSArray alloc]initWithArray:[UserController sharedInstance].arrayOfUsers];
    PFUser *user = arrayOfUsers[indexPath.row];
 
    cell.textLabel.text = [NSString stringWithFormat:@"%lu. %@", indexPath.row + 1, user[usernameKey]];

    return cell;
}

@end

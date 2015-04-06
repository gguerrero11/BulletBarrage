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
    
    // Sorting the array by Distance for each User
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:distanceKey ascending:NO];
    
    // Sorting the array by Kill/Death for each User
    //NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:killKey ascending:NO];
    
    // Sorting the array by Accuracy for each User
    //NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:accuracyKey ascending:NO];

    NSArray *sortDescriptors = [NSArray arrayWithObject:distanceDescriptor];
    NSArray *arraySortedForDistance = [arrayOfUsers sortedArrayUsingDescriptors:sortDescriptors];
    PFUser *user = arraySortedForDistance[indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%lu. %@ %@m , %@/%@, %@%%", indexPath.row + 1, user[usernameKey], user[distanceKey],user[killKey], user[deathKey], user[accuracyKey]];

    return cell;
}



@end

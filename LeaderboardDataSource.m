//
//  LeaderboardDataSource.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/3/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "LeaderBoardController.h"
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
    return [UserController sharedInstance].arrayOfUsers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *arrayOfUsers = [[NSArray alloc]initWithArray:[UserController sharedInstance].arrayOfUsers];
    // NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:distanceKey ascending:NO];
    
    NSSortDescriptor *descriptor;
    switch (self.sortMode)
    {
            // Sorting the array by Distance for each User
        case sortByDistance:
            descriptor = [[NSSortDescriptor alloc] initWithKey:distanceKey ascending:NO];
            
            break;
            
            // Sorting the array by Kill/Death for each User
        case sortByKill:
            descriptor = [[NSSortDescriptor alloc] initWithKey:killKey ascending:NO];

            break;
            
            // Sorting the array by Accuracy for each User
        case sortByAccuracy:
            descriptor = [[NSSortDescriptor alloc] initWithKey:accuracyKey ascending:NO];
            break;
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
    NSArray *arraySorted = [arrayOfUsers sortedArrayUsingDescriptors:sortDescriptors];
    PFUser *user = arraySorted[indexPath.row];
    
    switch (self.sortMode)
    {
            // Sorting the array by Distance for each User
        case sortByDistance:
            cell.textLabel.text = [NSString stringWithFormat:@"%lu. %@ %@m", indexPath.row + 1, user[usernameKey], user[distanceKey]];
            
            break;
            
            // Sorting the array by Kill/Death for each User
        case sortByKill:
            cell.textLabel.text = [NSString stringWithFormat:@"%lu. %@ %@/%@", indexPath.row + 1, user[usernameKey] ,user[killKey], user[deathKey]];
            
            break;
            
            // Sorting the array by Accuracy for each User
        case sortByAccuracy:
            cell.textLabel.text = [NSString stringWithFormat:@"%lu. %@ %@%%", indexPath.row + 1, user[usernameKey], user[accuracyKey]];
            break;
    }
    
    return cell;
}



@end

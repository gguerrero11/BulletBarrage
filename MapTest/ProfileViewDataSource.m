//
//  ProfileViewDataSource.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/3/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "ProfileViewDataSource.h"

static NSString *cellIdentifier = @"profileCell";

@interface ProfileViewDataSource ()

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ProfileViewDataSource

- (void)registerTableView:(UITableView *)tableView {
    self.tableView = tableView;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = @"Cell";
    return cell;
}




@end

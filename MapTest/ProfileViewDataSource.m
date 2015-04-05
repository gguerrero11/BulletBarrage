//
//  ProfileViewDataSource.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/3/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "ProfileViewDataSource.h"
#import "AvatarTableViewCell.h"
#import "WeaponsTableViewCell.h"
#import "ProfileTableViewCell.h"

static NSString *avatarCellIdentifier = @"avatarCell";
static NSString *weaponCellIdentifier = @"weaponCell";
static NSString *profileCellIdentifier = @"profileCell";


@interface ProfileViewDataSource ()

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ProfileViewDataSource

- (void)registerTableView:(UITableView *)tableView {
    self.tableView = tableView;
    [tableView registerClass:[AvatarTableViewCell class] forCellReuseIdentifier:avatarCellIdentifier];
    [tableView registerClass:[WeaponsTableViewCell class] forCellReuseIdentifier:weaponCellIdentifier];
    [tableView registerClass:[ProfileTableViewCell class] forCellReuseIdentifier:profileCellIdentifier];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // avatar cell
    if (indexPath.row == 0) {
        AvatarTableViewCell *avatarCell = [tableView dequeueReusableCellWithIdentifier:avatarCellIdentifier];
        avatarCell.textLabel.text = @"Avatar Cell";
        avatarCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return avatarCell;
    }
    // weapon cell
    if (indexPath.row == 1) {
        WeaponsTableViewCell *weaponsCell = [tableView dequeueReusableCellWithIdentifier:weaponCellIdentifier];
        weaponsCell.textLabel.text = @"Weapon Cell";
        weaponsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return weaponsCell;
    }
    
    // profile cell
    if (indexPath.row == 2) {
        ProfileTableViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:profileCellIdentifier];
        profileCell.textLabel.text = @"Profile Cell";
        profileCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return profileCell;
    }
    return false;
}




@end

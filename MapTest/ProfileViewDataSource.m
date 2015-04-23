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
    
    
    // profile cell
    if (indexPath.row == 0) {
        ProfileTableViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:profileCellIdentifier];
        profileCell.textLabel.font = [UIFont fontWithName:@"Menlo" size:17];
        profileCell.selectionStyle = UITableViewCellSelectionStyleNone;
        profileCell.textLabel.textAlignment = NSTextAlignmentCenter;
        profileCell.textLabel.textColor = [UIColor whiteColor];
        profileCell.backgroundColor = [UIColor clearColor];
        profileCell.textLabel.text = @"Profile Cell";
        profileCell.clipsToBounds = YES;
        return profileCell;
    }

    // avatar cell
    if (indexPath.row == 1) {
        AvatarTableViewCell *avatarCell = [tableView dequeueReusableCellWithIdentifier:avatarCellIdentifier];
        avatarCell.selectionStyle = UITableViewCellSelectionStyleNone;
        avatarCell.backgroundColor = [UIColor clearColor];
        avatarCell.textLabel.text = @"";
        avatarCell.clipsToBounds = YES;
        return avatarCell;
    }
    
    // weapon cell
    if (indexPath.row == 2) {
        WeaponsTableViewCell *weaponsCell = [tableView dequeueReusableCellWithIdentifier:weaponCellIdentifier];
        weaponsCell.textLabel.font = [UIFont fontWithName:@"Menlo" size:17];
        weaponsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        weaponsCell.textLabel.textAlignment = NSTextAlignmentCenter;
        weaponsCell.textLabel.textColor = [UIColor whiteColor];
        weaponsCell.backgroundColor = [UIColor clearColor];
        weaponsCell.textLabel.text = @"Weapon Cell";
        weaponsCell.clipsToBounds = YES;
        return weaponsCell;
    }

    

    return false;
}




@end

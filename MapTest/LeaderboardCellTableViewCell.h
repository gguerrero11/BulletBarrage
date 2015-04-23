//
//  LeaderboardCellTableViewCell.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/6/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderboardCellTableViewCell : UITableViewCell

@property (nonatomic) UILabel *rank;
@property (nonatomic) UILabel *username;
@property (nonatomic) UILabel *location;
@property (nonatomic) UILabel *record;

@end

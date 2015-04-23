//
//  AvatarTableViewCell.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/4/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarTableViewCell : UITableViewCell

@property (nonatomic) UIView *containerView;

@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic) UIImageView *weaponImageView;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *subtitleLabel;
@property (nonatomic) UILabel *descriptionLabel;


@property (nonatomic) UILabel *damageLabe;
@property (nonatomic) UILabel *velocityLabel;
@property (nonatomic) UILabel *blastRadiusLabel;
@property (nonatomic) UILabel *rateOfFireLabel;

@end

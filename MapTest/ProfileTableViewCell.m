//
//  ProfileTableViewCell.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/3/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "ProfileTableViewCell.h"
#import "UIColor+InterfaceColors.h"
#import "WeaponController.h"
#import <Parse/Parse.h>

static double const padding = 5;

@implementation ProfileTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
//        double heightOfIcon = self.contentView.frame.size.height * 1.6;
//        double xOriginIconImageView = self.contentView.frame.size.width * .05;
//        
//        UIView *iconImageContainer = [[UIImageView alloc]initWithFrame:CGRectMake( xOriginIconImageView,
//                                                                                  self.contentView.frame.size.height * .6, heightOfIcon, heightOfIcon)];
//        iconImageContainer.backgroundColor = [UIColor tableBackgroundColor];
//        iconImageContainer.layer.borderColor = [UIColor tableBorderColor].CGColor;
//        iconImageContainer.layer.borderWidth = 1.5;
//        [self.contentView addSubview:iconImageContainer];
        
        // set up weapon icon
//        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(iconImageContainer.frame.size.width / 2 - iconImageContainer.frame.size.width * 0.75 / 2, iconImageContainer.frame.size.height / 2 - iconImageContainer.frame.size.height * 0.75 / 2 , iconImageContainer.frame.size.width * 0.75, iconImageContainer.frame.size.height * 0.75)];
//        
//        self.iconImageView.image = [UIImage imageNamed:@"cannon"];
//        [iconImageContainer addSubview:self.iconImageView];
        
        // set up weapon name
        double xOriginNameLabel = self.contentView.frame.size.width * .05;
        double yOriginNameLabel = self.contentView.frame.size.height;
        double nameLabelHeight = self.contentView.frame.size.height;
        double nameLabelWidth = self.contentView.frame.size.width;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOriginNameLabel + padding, yOriginNameLabel, nameLabelWidth, nameLabelHeight)];
        self.nameLabel.text = @"barragemaster33";//[PFUser currentUser].username;
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:36];
        self.nameLabel.numberOfLines = 1;
        self.nameLabel.minimumScaleFactor = 8.;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
//        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.nameLabel];
        
        // set up weapon type subtitle
        double yOriginSubtitleLabel = self.nameLabel.frame.size.height - 3;
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOriginNameLabel + padding, yOriginSubtitleLabel, nameLabelWidth, 16)];
        self.subtitleLabel.text = @"THE NOOB";
        self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
        self.subtitleLabel.textColor = [UIColor whiteColor];
        self.subtitleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        [self.nameLabel addSubview:self.subtitleLabel];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

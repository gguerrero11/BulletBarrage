//
//  AvatarTableViewCell.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/4/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "AvatarTableViewCell.h"
#import "UIColor+InterfaceColors.h"
#import "WeaponController.h"

static double const padding = 5;

@implementation AvatarTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        double heightOfIcon = self.contentView.frame.size.height * 1.6;
        double xOriginIconImageView = self.contentView.frame.size.width * .05;
        
        UIView *iconImageContainer = [[UIImageView alloc]initWithFrame:CGRectMake( xOriginIconImageView,
                                                                                  self.contentView.frame.size.height * .4, heightOfIcon, heightOfIcon)];
        iconImageContainer.backgroundColor = [UIColor tableBackgroundColor];
        iconImageContainer.layer.borderColor = [UIColor tableBorderColor].CGColor;
        iconImageContainer.layer.borderWidth = 1.5;
        [self.contentView addSubview:iconImageContainer];
        
        // set up weapon icon
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(iconImageContainer.frame.size.width / 2 - iconImageContainer.frame.size.width * 0.75 / 2, iconImageContainer.frame.size.height / 2 - iconImageContainer.frame.size.height * 0.75 / 2 , iconImageContainer.frame.size.width * 0.75, iconImageContainer.frame.size.height * 0.75)];

        self.iconImageView.image = [UIImage imageNamed:@"cannon"];
        [iconImageContainer addSubview:self.iconImageView];
        
        // set up weapon name
        double xOriginNameLabel = iconImageContainer.frame.origin.x + iconImageContainer.frame.size.width;
        double yOriginNameLabel = iconImageContainer.frame.origin.y;
        double nameLabelHeight = iconImageContainer.frame.size.height * .5;
        double nameLabelWidth = self.contentView.frame.size.width - xOriginNameLabel;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOriginNameLabel + padding, yOriginNameLabel + 5, nameLabelWidth, nameLabelHeight)];
        self.nameLabel.text = @"FLAK 88";
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:40];
        self.nameLabel.numberOfLines = 1;
        self.nameLabel.minimumScaleFactor = 8.;
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.nameLabel];
        
        // set up weapon type subtitle
        double yOriginSubtitleLabel = yOriginNameLabel + self.nameLabel.frame.size.height;
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOriginNameLabel + padding, yOriginSubtitleLabel, nameLabelWidth, nameLabelHeight)];
        self.subtitleLabel.text = @"CANNON";
        self.subtitleLabel.textColor = [UIColor whiteColor];
        self.subtitleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        [self.contentView addSubview:self.subtitleLabel];

        // weapon image
        self.weaponImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * 1.3,
                                                                            self.frame.size.height * 9, -300, -300)];
        self.weaponImageView.image = [UIImage imageNamed:@"Flak88Profile"];
        [self.contentView addSubview:self.weaponImageView];
        
        // setup description of weapon
        double yOriginDescriptionLabel = yOriginNameLabel + iconImageContainer.frame.size.height + padding * 3;
        double widthOfCell = self.contentView.frame.size.width;
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOriginIconImageView,
                                                                          yOriginDescriptionLabel,
                                                                          widthOfCell * 1.07,
                                                                          300)];
        self.descriptionLabel.text = @"The 88 mm gun (commonly called the eighty-eight) was a German anti-aircraft and anti-tank artillery gun from World War II.";
        self.descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        self.descriptionLabel.textColor = [UIColor whiteColor];
        self.descriptionLabel.numberOfLines = 0;
        [self.descriptionLabel sizeToFit];
        [self.contentView addSubview:self.descriptionLabel];
        
        // setup divider lines
        double yOriginDividerLine = yOriginDescriptionLabel + self.descriptionLabel.frame.size.height;
        double widthOfDividerLine = self.frame.size.width * .75;
        UIView *dividerLineTop = [[UIView alloc]initWithFrame:CGRectMake(xOriginIconImageView,
                                                                      yOriginDividerLine + padding * 2, widthOfDividerLine, 1.5)];
        dividerLineTop.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:dividerLineTop];
        dividerLineTop.alpha = .45;

        
        double yOriginDividerLineBottom = yOriginDividerLine * 2;
        UIView *dividerLineBottom = [[UIView alloc]initWithFrame:CGRectMake(xOriginIconImageView,
                                                                      yOriginDividerLineBottom, widthOfDividerLine, 1.5)];
        dividerLineBottom.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:dividerLineBottom];
        dividerLineBottom.alpha = .45;
        
        // setup damage label
        double heightOfDamageLabel = 40;
        double yOriginDamageLabel = (yOriginDividerLineBottom - yOriginDividerLine / 2) -(heightOfDamageLabel / 2);

        self.damageLabe = [[UILabel alloc]initWithFrame:CGRectMake(xOriginIconImageView, yOriginDamageLabel, 50, heightOfDamageLabel)];
        self.damageLabe.font = [UIFont fontWithName:@"Helvetica-bold" size:heightOfDamageLabel];
        self.damageLabe.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.damageLabe];
        self.damageLabe.text = @"30";
        
        UILabel *damageTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, heightOfDamageLabel + padding / 3, 100, 10)];;
        damageTitleLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:10];
        damageTitleLabel.textAlignment = NSTextAlignmentLeft;
        damageTitleLabel.textColor = [UIColor whiteColor];
        [self.damageLabe addSubview:damageTitleLabel];
        damageTitleLabel.text = @"DAMAGE";
        
        // set up stats
        UILabel *statTitlesLabel = [[UILabel alloc]initWithFrame:CGRectMake(dividerLineTop.frame.size.width * .75, dividerLineTop.frame.origin.y + 5, -120, 130)];
        statTitlesLabel.text = @"MUZZLE VELOCITY:\nBLAST RADIUS:\nRATE OF FIRE:\nTOTAL SHOTS:";
        statTitlesLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:10];
        statTitlesLabel.textAlignment = NSTextAlignmentRight;
        statTitlesLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:statTitlesLabel];
        statTitlesLabel.numberOfLines = 0;
        
                // set up BS stats
        UILabel *stats = [[UILabel alloc]initWithFrame:CGRectMake(dividerLineTop.frame.size.width * .75, dividerLineTop.frame.origin.y + 5, 120, 130)];
        stats.text = @" 860 m/s \n 100m \n 15-20 RPM \n 32";
        stats.font = [UIFont fontWithName:@"Helvetica-bold" size:10];
        stats.textAlignment = NSTextAlignmentLeft;
        stats.textColor = [UIColor whiteColor];
        [self.contentView addSubview:stats];
        stats.numberOfLines = 0;

    }
    return self;
}

- (void) insertLabel:(UILabel *)label atXOrigin:(double)xOrigin width:(double)width alignmentRight:(BOOL)alignmentRight {
    
    label.frame = CGRectMake(self.contentView.frame.size.width * xOrigin, 5, width, 30);
    label.font = [UIFont fontWithName:@"Menlo" size:15];
    label.textColor = [UIColor whiteColor];
    if (alignmentRight == YES)label.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:label];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

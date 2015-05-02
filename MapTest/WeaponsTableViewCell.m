//
//  WeaponsTableViewCell.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/4/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "WeaponsTableViewCell.h"
#import "UIColor+InterfaceColors.h"

@implementation WeaponsTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
                double heightOfIcon = self.contentView.frame.size.height * 10;
                double xOriginIconImageView = 2;
        
                UIView *iconImageContainer = [[UIImageView alloc]initWithFrame:CGRectMake( xOriginIconImageView,
                                                                                          2, heightOfIcon, heightOfIcon)];
                [self.contentView addSubview:iconImageContainer];
        
         //set up weapon icon
                UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10 , iconImageContainer.frame.size.width * 0.8, iconImageContainer.frame.size.height * 0.8)];
        iconImageView.image = [UIImage imageNamed:@"weapIcons"];
        iconImageView.backgroundColor = [UIColor tableBackgroundColor];
        [self addSubview:iconImageView];
        
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

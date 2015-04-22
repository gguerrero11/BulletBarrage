//
//  LeaderboardCellTableViewCell.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/6/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "LeaderboardCellTableViewCell.h"

@implementation LeaderboardCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.rank = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
        self.rank.backgroundColor = [UIColor redColor];
        
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

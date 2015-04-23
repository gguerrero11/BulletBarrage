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
        
        self.rank = [UILabel new];
        [self insertLabel:self.rank atXOrigin:0 width:30 alignmentRight:NO ];
        self.location = [UILabel new];
        [self insertLabel:self.location atXOrigin:.12 width:40 alignmentRight:NO];
        self.username = [UILabel new];
        [self insertLabel:self.username atXOrigin:.25 width:120 alignmentRight:NO];
        self.record = [UILabel new];
        [self insertLabel:self.record atXOrigin:.98 width:-120 alignmentRight:YES];
        
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

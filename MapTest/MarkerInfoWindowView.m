//
//  MarkerInfoWindowView.m
//  MapTest
//
//  Created by Gabriel Guerrero on 5/2/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "MarkerInfoWindowView.h"
#import "UIColor+InterfaceColors.h"


@implementation MarkerInfoWindowView

- (id) initWithFrame:(CGRect)frame andMarker:(GMSMarker *)marker {
    self = [super initWithFrame:frame];
    [self labelMakerWithText:marker.title YOrigin:0];
    return self;
}

- (void) labelMakerWithText:(NSString *)text YOrigin:(double)yOrigin {
    
    UILabel *label = [UILabel new];
    [self addSubview:label];
    label.font = [UIFont fontWithName:@"Helvetica-bold" size:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = text;
    [label sizeToFit];
//    label.backgroundColor = [UIColor redColor];
    label.center = self.center;

    double labelContainerPadding = 5;
    UIView *labelContainer = [UIView new];
    [self insertSubview:labelContainer belowSubview:label];
    labelContainer.backgroundColor = [UIColor transparentBox];
    labelContainer.layer.borderColor = [UIColor lineColor].CGColor;
    labelContainer.layer.borderWidth = 1.5;
    [labelContainer setFrame:CGRectMake(0,0,
                                        label.frame.size.width + labelContainerPadding,
                                        label.frame.size.height + labelContainerPadding)];
    labelContainer.center = label.center;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

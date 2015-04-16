//
//  InterfaceLineDrawer.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/16/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "InterfaceLineDrawer.h"

static NSString * const right = @"right";
static NSString * const left = @"left";
static NSString * const top = @"top";
static NSString * const bottom = @"bottom";


@interface InterfaceLineDrawer ()

@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic) double lengthOfLine;
@property (nonatomic) double lineThickness;
@property (nonatomic,strong) UIView *parentView;

@end

@implementation InterfaceLineDrawer

- (instancetype)initWithFrame:(CGRect)frame withView:(UIView *)view{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.parentView = view;
        self.lengthOfLine = view.frame.size.height * .8;
        self.lineThickness = 1.0;
        self.lineColor = [UIColor blackColor];
        
        [self drawVerticalLines:right];
        [self drawVerticalLines:left];
        
    }
    return self;
}

- (void) drawVerticalLines:(NSString *)side {
    double xOrigin = 0.0;
    
    if ([side isEqualToString:right]) xOrigin = self.parentView.frame.size.width * 0.9;
    if ([side isEqualToString:left]) xOrigin = self.parentView.frame.size.width * 0.1;
        
    UIView *zoomLineVertical = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, self.parentView.frame.size.height * 0.1,
                                                                        self.lineThickness, self.lengthOfLine)];
    zoomLineVertical.backgroundColor = self.lineColor;
    [self.parentView addSubview:zoomLineVertical];
    [self drawStudsForVerticalLine:zoomLineVertical side:side];
    [self drawBoxOn:top of:zoomLineVertical whichSide:side];
    [self drawBoxOn:bottom of:zoomLineVertical whichSide:side];
    
}

- (void) drawStudsForVerticalLine:(UIView *)verticalLine side:(NSString *)side {
    int amountOfStuds = 15;
    double spaceBetweenStuds = verticalLine.frame.size.height / amountOfStuds;
    int lineLength;
    
    for (int i = 0; i <= amountOfStuds; i++) {
        lineLength = 10;
        if ([side isEqualToString:left]) lineLength *= -1;
        if (i == 0 || i == amountOfStuds) lineLength *= 2;
        
        UIView *studdedline = [[UIView alloc] initWithFrame:CGRectMake(0, spaceBetweenStuds * i, lineLength, self.lineThickness)];
        studdedline.backgroundColor = self.lineColor;
        [verticalLine addSubview:studdedline];
    }
}

- (void) drawBoxOn:(NSString *)topOrBottom of:(UIView *)view whichSide:(NSString *)side {
    double yOrigin = 0.0;
    double heightOfBox = 30;
    double spaceBetween = 5;
    double widthOfBox = 30;
    
    if ([side isEqualToString:left]) widthOfBox *= -1;
    
    if ([topOrBottom isEqualToString:top]) yOrigin = -spaceBetween + -heightOfBox;
    if ([topOrBottom isEqualToString:bottom]) yOrigin = spaceBetween + view.frame.size.height;

    UIView *box = [[UIView alloc]initWithFrame:CGRectMake(0, yOrigin, widthOfBox, heightOfBox)];
    box.layer.borderWidth = self.lineThickness;
    box.layer.borderColor = self.lineColor.CGColor;
    [view addSubview:box];
}



/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/

@end

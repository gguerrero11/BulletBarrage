//
//  InterfaceLineDrawer.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/16/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "InterfaceLineDrawer.h"
#import "MapViewController.h"

static NSString * const top = @"top";
static NSString * const bottom = @"bottom";
static NSString * const pitch = @"pitch";
static NSString * const zoom = @"zoom";

@interface InterfaceLineDrawer ()

typedef void(^myCompletion)(BOOL);

@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,strong) UIColor *labelColor;
@property (nonatomic,strong) UIColor *transparentBox;
@property (nonatomic,strong) UIColor *screenTintColor;

@property (nonatomic) double lengthOfLine;
@property (nonatomic) double lineThickness;
@property (nonatomic,strong) UIView *parentView;

@property (nonatomic,strong) UIView *rightBoxArrow;
@property (nonatomic,strong) UIView *leftBoxArrow;
@property (nonatomic) UIView *screenTintView;
@property (nonatomic,strong) UIView *interlaceLineView;
@property (nonatomic,strong) UILabel *pitchLabel;
@property (nonatomic,strong) UILabel *zoomLabel;

@property (nonatomic) BOOL initalStartup;


@property (nonatomic) double lengthOfVerticalLines;

@end

@implementation InterfaceLineDrawer

- (instancetype)initWithFrame:(CGRect)frame withView:(UIView *)view{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.screenTintColor = [UIColor colorWithRed:.1 green:.5 blue:.5 alpha:.1];
        self.initalStartup = YES;
        self.parentView = view;
        self.lengthOfLine = view.frame.size.height * .6;
        self.lineThickness = 1.0;
        self.lineColor = [UIColor grayColor];
        self.labelColor = [UIColor blackColor];
        self.transparentBox = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.4];
        
        [self drawVerticalLines:right];
        [self drawVerticalLines:left];
        
        [self drawScreenEffect];
        [self drawGlowingLine];
    }
    return self;
}

- (void) drawVerticalLines:(NSString *)side {
    double xOrigin = 0.0;
    
    if ([side isEqualToString:right]) xOrigin = self.parentView.frame.size.width * 0.95;
    if ([side isEqualToString:left]) xOrigin = self.parentView.frame.size.width * 0.05;
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(xOrigin, self.parentView.frame.size.height * 0.1,
                                                                    self.lineThickness, self.lengthOfLine)];
    verticalLine.backgroundColor = self.lineColor;
    verticalLine.userInteractionEnabled = NO;
    [self.parentView addSubview:verticalLine];
    [self drawStudsForVerticalLine:verticalLine side:side];
    
    [self drawBoxOn:top onView:verticalLine whichSide:side withMovement:NO withText:@"+"];
    [self drawBoxOn:bottom onView:verticalLine whichSide:side withMovement:NO withText:@"–"];
    
    [self drawArrowBoxOnView:verticalLine whichSide:side withText:@"X"];
    
    self.lengthOfVerticalLines = verticalLine.frame.size.height;
    
}

- (void) drawStudsForVerticalLine:(UIView *)verticalLine side:(NSString *)side {
    int amountOfStuds = 15;
    int lineLength;
    double spaceBetweenStuds = verticalLine.frame.size.height / amountOfStuds;
    
    
    for (int i = 0; i <= amountOfStuds; i++) {
        lineLength = 10;
        
        if ([side isEqualToString:right]) lineLength *= -1;
        if (i == 0 || i == amountOfStuds) lineLength *= 2;
        
        UIView *studdedline = [[UIView alloc] initWithFrame:CGRectMake(0, spaceBetweenStuds * i, lineLength, self.lineThickness)];
        studdedline.backgroundColor = self.lineColor;
        studdedline.userInteractionEnabled = NO;
        [verticalLine addSubview:studdedline];
    }
}

- (void) drawBoxOn:(NSString *)topOrBottom onView:(UIView *)view whichSide:(NSString *)side withMovement:(BOOL)movement withText:(NSString *)text{
    double yOrigin = 0.0;
    double heightOfBox = 20;
    double spaceBetween = 13;
    double widthOfBox = 40;
    
    // if line is for right side, set box to negative width so it draws the other way.
    if ([side isEqualToString:right]) widthOfBox *= -1;
    
    // checks to see if box is on top or bottom. If top, then the space will be made going upwards (negative) as well as the height
    if ([topOrBottom isEqualToString:top] && topOrBottom != nil) yOrigin = -spaceBetween + -heightOfBox;
    if ([topOrBottom isEqualToString:bottom] && topOrBottom != nil) yOrigin = spaceBetween + view.frame.size.height;
    
    UIView *box = [[UIView alloc]initWithFrame:CGRectMake(0, yOrigin, widthOfBox, heightOfBox)];
    box.layer.borderWidth = self.lineThickness;
    box.layer.borderColor = self.lineColor.CGColor;
    [view addSubview:box];
    
    UILabel *label = [UILabel new];
    if ([side isEqual:left]) label.frame = CGRectMake(0, 0, box.frame.size.width, box.frame.size.height);
    if ([side isEqual:right]) label.frame = CGRectMake(0, 0, -box.frame.size.width, box.frame.size.height);
    [box addSubview: label];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.font = [UIFont systemFontOfSize:15];
    label.userInteractionEnabled = NO;
    label.textColor = self.labelColor;
    
    if (movement == YES) {
        box.backgroundColor = self.transparentBox;
        if (side == right) {
            self.rightBoxArrow = box;
            self.zoomLabel = label;
        }
        
        if (side == left) {
            self.leftBoxArrow = box;
            self.pitchLabel = label;
        }
    }
}

- (void) drawArrowBoxOnView:(UIView *)view whichSide:(NSString *)side withText:(NSString *)text {
    [self drawBoxOn:nil onView:view whichSide:side withMovement:YES withText:text];
}

- (void) move:(NSString *)side boxBasedByValue:(double)value {
    
    if (side == left) self.pitchLabel.text = [NSString stringWithFormat:@"%d",(int)[MapViewController convertToDegrees:value]];
    if (side == right) self.zoomLabel.text = [NSString stringWithFormat:@"%d",(int)value];
    
    // arrow box on right
    if ([side isEqualToString:right]) {
        
        // value is from 2 - 21
        double percentage = value / 21;
        self.rightBoxArrow.center = CGPointMake( -self.parentView.frame.size.width * 0.1, (percentage * self.lengthOfVerticalLines) - 25);
    }
    
    // arrow box on left
    if ([side isEqualToString:left]) {
        
        // this origin is based on radians. It places the box on percentage based on the length of the line.
        double yOrigin = (self.lengthOfVerticalLines - 24) * (value / 1.5);
        self.leftBoxArrow.center = CGPointMake(self.parentView.frame.size.width * 0.1, self.lengthOfVerticalLines - yOrigin );
    }
}

- (void) drawScreenEffect {
    
    double lineTransparency = 0.5;
    UIColor *interlaceLineColor = [UIColor colorWithRed:.1 green:.6 blue:.7 alpha:lineTransparency];
    
    // draw screen tint
    self.screenTintView = [[UIView alloc]initWithFrame:self.parentView.frame];
    self.screenTintView.userInteractionEnabled = NO;
    self.screenTintView.backgroundColor = self.screenTintColor;
    [self.parentView addSubview:self.screenTintView];
    
    // draw interlace lines
    for (int i = 0; i < (int)(self.parentView.frame.size.height); i ++) {
        if (i % 2 == 0) {
            
            self.interlaceLineView = [[UIView alloc]initWithFrame:CGRectMake(0, i, self.parentView.frame.size.width, 1)];
            self.interlaceLineView.alpha = lineTransparency;
            self.interlaceLineView.backgroundColor = interlaceLineColor;
            self.interlaceLineView.userInteractionEnabled = NO;
            [self.screenTintView addSubview:self.interlaceLineView];
        }
    }
}

- (void) drawGlowingLine {
    
    double heightOfLine = 100;
    
    // draw glowing animated line
    UIView *glowLine = [[UIView alloc]initWithFrame:CGRectMake(-30, -heightOfLine, self.parentView.frame.size.width + 60, heightOfLine)];
    glowLine.layer.shadowOpacity = 1.0;
    glowLine.layer.shadowColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    glowLine.layer.opacity = .15;
    glowLine.layer.shadowRadius = 6;
    glowLine.userInteractionEnabled = NO;
    glowLine.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    [self.screenTintView addSubview:glowLine];
    
    // animate glow line
    CGRect destinationFrame = CGRectMake(0, self.frame.size.height + 20, glowLine.frame.size.width, glowLine.frame.size.height);
    
    [UIView animateWithDuration:15
                          delay:0.0
                        options:UIViewAnimationCurveLinear | UIViewAnimationOptionRepeat | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         glowLine.frame = destinationFrame;
                     }
                     completion:^(BOOL finished){
                     }
     ];
    
}

- (void) drawRandomLines {
    
    for (int i = 0; i < 10; i++) {
        
        double heightOfLine = arc4random() % 200;
        double randomYOrigin = arc4random() % (int)self.parentView.frame.size.height;
        
        // create a random line
        UIView *randomLine = [[UIView alloc]initWithFrame:CGRectMake(-30, randomYOrigin, self.parentView.frame.size.width + 60, heightOfLine)];
        [self.screenTintView addSubview:randomLine];
        
        randomLine.backgroundColor = [UIColor colorWithWhite:.8 alpha:.8];
        
        // "darken" the screen
        self.screenTintView.backgroundColor = [UIColor blackColor];

        
        // change the yOrigin to be random
        randomYOrigin = arc4random() % (int)self.parentView.frame.size.height;
        CGRect destinationFrame = CGRectMake(0, randomYOrigin, randomLine.frame.size.width, 0 );
        
        [UIView animateWithDuration:.09 animations:^{
            randomLine.frame = destinationFrame;
        } completion:^(BOOL finished) {
            [randomLine removeFromSuperview];
        }];
        
        [UIView animateWithDuration:0.7
                              delay:0.0
                            options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionOverrideInheritedDuration
                         animations:^{
                             self.screenTintView.backgroundColor = self.screenTintColor;
                         }
                         completion:^(BOOL finished){
                         }
         ];
        
    }
}



 //Only override drawRect: if you perform custom drawing.
 //An empty implementation adversely affects performance during animation.
// - (void)drawRect:(CGRect)rect {
//     CGContextRef context = UIGraphicsGetCurrentContext();
//     
//     UIColor * whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
//     UIColor * lightGrayColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
//     UIColor * redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]; // NEW
//     
//     CGRect paperRect = self.bounds;
//     
//     //drawLinearGradient(context, paperRect, whiteColor.CGColor, lightGrayColor.CGColor);
//     
//     // START NEW
//     CGRect strokeRect = CGRectInset(paperRect, 5.0, 5.0);
//     CGContextSetStrokeColorWithColor(context, redColor.CGColor);
//     CGContextSetLineWidth(context, 1.0);
//     CGContextStrokeRect(context, strokeRect);
//     // END NEW
// }


@end

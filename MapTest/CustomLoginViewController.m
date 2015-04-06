//
//  CustomLoginViewController.m
//  KingOfTheHill
//
//  Created by Ryan S. Watt on 3/27/15.
//  Copyright (c) 2015 David Monson. All rights reserved.
//

#import "CustomLoginViewController.h"

@interface CustomLoginViewController ()
@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation CustomLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.logInView setTintColor:[UIColor blackColor]];
    [self.logInView setLogo: [[UIImageView alloc] initWithImage:[UIImage imageNamed:nil]]];
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"skate"]]];
    
    self.logInView.signUpButton.backgroundColor = [UIColor whiteColor];
    [self.logInView.signUpButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateNormal];
    self.logInView.logInButton.backgroundColor = [UIColor blackColor];
    [self.logInView.logInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.logInView.passwordForgottenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
//    self.titleLabel.text = @"Alpha";
//    self.titleLabel.textColor = [UIColor redColor];
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:24];
    
    
}

- (void)viewDidLayoutSubviews {
    [self.logInView.usernameField setFrame:CGRectMake(0, 350, self.view.frame.size.width, 50)];
    [self.logInView.passwordField setFrame:CGRectMake(0, 400, self.view.frame.size.width, 50)];
    [self.logInView.passwordForgottenButton setFrame:CGRectMake(0, 460, self.view.frame.size.width, 30)];
    [self.logInView.logInButton setFrame:CGRectMake(0, 525, self.view.frame.size.width, 75)];
    [self.logInView.signUpButton setFrame:CGRectMake(0, 600, self.view.frame.size.width, 50)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

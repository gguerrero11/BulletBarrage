//
//  CustomSignUpViewController.m
//  Bullet Barrage
//
//  Created by Gabe Guerrero on 3/27/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "CustomSignUpViewController.h"

@interface CustomSignUpViewController ()

@end

@implementation CustomSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:nil]]];
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"signup"]]];
    
    [self.signUpView.signUpButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundColor:[UIColor blackColor]];
    [self.signUpView.signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
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

//
//  ProfileviewControllerViewController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/3/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "ProfileviewControllerViewController.h"
#import "ProfileViewDataSource.h"

static int paddingFromGroupTable = 35;

@interface ProfileviewControllerViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ProfileViewDataSource *dataSource;
@property (nonatomic) float unselectedCellHeight;
@property (nonatomic) float selectedCellHeight;
@property (nonatomic) NSInteger selectedIndex;



@end

@implementation ProfileviewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
    
    [self setUpBackground];
    
    // table datasource stuff
    self.dataSource = [ProfileViewDataSource new];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -paddingFromGroupTable, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.dataSource registerTableView:self.tableView];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// set up background image
- (void) setUpBackground {
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundImage.image = [UIImage imageNamed:@"leaderBoardScreenBlue"];
    [self.view addSubview:backgroundImage];
    
    [self diagonalAnimationForView];
    [self diagonalAnimationForView];

}

- (void) diagonalAnimationForView {

    // sets random width from 400 - 2800
    double randomWidth = arc4random() % 2400 + 400;
    // sets the height based on the percentage of the size of the randomWidth to its maximum size
    double randomHeight = 1400 * (randomWidth / 2800);
    
    NSLog(@"%f, %f", randomWidth, randomHeight);
    
    UIImageView *backgroundGrid = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, randomWidth, randomHeight)];
    backgroundGrid.image = [UIImage imageNamed:@"backgroundGrid"];
    [self.view addSubview:backgroundGrid];
    

    double newX = arc4random() % 800 - 400.0;
    double newY = arc4random() % 800 - 400.0;
    while (newY > 400 && newX) {
        newX = arc4random() % 800 - 400.0;
        newY = arc4random() % 800 - 400.0;
    }
    int timeOfAnimation = arc4random() % 20 + 15;
    
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(arc4random());
    backgroundGrid.transform = rotationTransform;
    backgroundGrid.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    backgroundGrid.alpha = 0;
    
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         backgroundGrid.alpha = .1;
                     }
                     completion:nil];
    
    [UIView animateWithDuration:timeOfAnimation
                     animations:^{
                         backgroundGrid.center = CGPointMake(newX, newY);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1.0
                                          animations:^{
                                              backgroundGrid.alpha = 0;
                                          }
                                          completion:^(BOOL finished) {
                                              [backgroundGrid removeFromSuperview];
                                              [self performSelector:@selector(diagonalAnimationForView)];
                                          }];
                     }];
}

#pragma mark TableView delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCellHeight = self.view.frame.size.width;
    
    if (indexPath.row == self.selectedIndex) {
        
        return self.selectedCellHeight;
        
    }
    float remainingFrameSize =  self.view.frame.size.height -
    self.navigationController.navigationBar.frame.size.height -
        self.tabBarController.tabBar.frame.size.height -
        self.view.frame.size.width -
        [UIApplication sharedApplication].statusBarFrame.size.height;
        self.unselectedCellHeight = remainingFrameSize / 2;
        return self.unselectedCellHeight;
    }
    
    -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        // Deselect cell
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        self.selectedIndex = indexPath.row;
        
        // This is where magic happens...
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
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
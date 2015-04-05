//
//  LeaderboardViewController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/3/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "LeaderboardDataSource.h"

static double padding = 15;


@interface LeaderboardViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LeaderboardDataSource *dataSource;
@property (nonatomic, strong) UISegmentedControl *segControl;
@property (nonatomic) double heightOfStatusBarNavBar;

@end

@implementation LeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Leaderboards";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // set size of top bar size
    self.heightOfStatusBarNavBar = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    // set up segmented control categories
    NSArray *array = @[@"Distance", @"K/D", @"Accuracy"];
    
    // initialize datasource
    self.dataSource = [LeaderboardDataSource new];
    
    // create segment control
    self.segControl = [[UISegmentedControl alloc]initWithItems:array];
    self.segControl.frame = CGRectMake(padding, self.heightOfStatusBarNavBar + padding, self.view.frame.size.width - padding * 2, 35);
    [self.view addSubview:self.segControl];
    
    // set up table view
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.heightOfStatusBarNavBar + self.segControl.frame.size.height + padding * 2, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;

    [self.dataSource registerTableView:self.tableView];
    [self.view addSubview:self.tableView];
    
    
    
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

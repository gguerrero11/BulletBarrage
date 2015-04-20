//
//  LeaderboardViewController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/3/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "LeaderboardDataSource.h"
#import "LeaderBoardController.h"
#import "UserController.h"
#import <Parse/Parse.h>
#import "UserController.h"
#import "BackgroundDrawer.h"

static double padding = 15;
static double margin = 25;
static double tableBoxPadding = 8;


@interface LeaderboardViewController () <UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) LeaderboardDataSource *dataSource;
@property (nonatomic) double heightOfStatusBarAndNavBar;
@property (nonatomic) double heightTabBar;
@property (nonatomic) double yOriginOfTableView;
@property (nonatomic,strong) NSArray *arrayForAccuracy;
@property (nonatomic,strong) NSArray *arrayForDistance;
@property (nonatomic,strong) NSArray *arrayForKD;
@property (nonatomic,strong) UISegmentedControl *segControl;
@property (nonatomic,strong) BackgroundDrawer *bgDrawer;


@end

@implementation LeaderboardViewController

- (void)viewWillDisappear:(BOOL)animated {
    self.bgDrawer.shouldContinue = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    self.bgDrawer.shouldContinue = YES;
    [self.bgDrawer continueDrawing];
    

}

- (void) registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"queryDone" object:nil];

    //[self.loadCircle removeFromSuperview];
}

- (void) reloadTable {
    
    // NOTE: Putting the reloadData in the main queue SOLVES the issue where the user has to interact with the table in order for the table to reload, visually
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


- (void) drawTableBox {
    UIView *tableBox = [[UIView alloc]initWithFrame:CGRectMake(self.tableView.frame.origin.x - tableBoxPadding,
                                                              self.tableView.frame.origin.y - tableBoxPadding,
                                                              self.tableView.frame.size.width + tableBoxPadding * 2,
                                                              self.tableView.frame.size.height + tableBoxPadding * 2)];
    tableBox.backgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.3];
    tableBox.layer.borderWidth = 1;
    tableBox.layer.borderColor = [UIColor colorWithRed:90.0/255.0 green:195.0/255.0 blue:247.0/255.0 alpha:.6].CGColor;

    [self.view addSubview:tableBox];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Leaderboards";

    self.tabBarController.tabBar.alpha = 1;
    
    self.bgDrawer = [BackgroundDrawer new];
    [self.bgDrawer setUpBackgroundOnView:self.view];


    // set size of top bar size
    self.heightOfStatusBarAndNavBar = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    self.heightTabBar = self.tabBarController.tabBar.frame.size.height;

    // set up segmented control categories
    NSArray *array = @[@"Distance", @"K/D", @"Accuracy"];
    
    // initialize datasource+
    self.dataSource = [LeaderboardDataSource new];
    
    // create segment control
    self.segControl = [[UISegmentedControl alloc]initWithItems:array];
    self.segControl.frame = CGRectMake(padding, self.heightOfStatusBarAndNavBar + padding, self.view.frame.size.width - padding * 2, 35);
    self.segControl.selectedSegmentIndex = 0;
    [self.segControl addTarget:self action:@selector(updateSort:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segControl];
    
    // set up table view
    self.yOriginOfTableView = self.heightOfStatusBarAndNavBar + self.segControl.frame.size.height + padding * 2;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(margin, self.yOriginOfTableView,
                                                                  self.view.frame.size.width - margin * 2,
                                                                  self.view.frame.size.height - (self.heightOfStatusBarAndNavBar + self.heightTabBar + self.yOriginOfTableView))];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self drawTableBox];
    
    [self.dataSource registerTableView:self.tableView];
    [self.view addSubview:self.tableView];

    
}

- (void) updateSort:(id)sender {
    UISegmentedControl *segControl = sender;
    self.dataSource.sortMode = (SortMode)segControl.selectedSegmentIndex;
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
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

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

#import "ObjectAL.h"
#define BUTTONPRESS_SOUND @"buttonPress2.caf"
#define METALCLANK_SOUND @"metalClank.caf"

static double padding = 17;
static double margin = 25;
static double tableBoxPadding = 0;

@interface LeaderboardViewController () <UITableViewDelegate,UITabBarControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic) UIView *tableBorder;

@property (nonatomic,strong) LeaderboardDataSource *dataSource;
@property (nonatomic) double heightOfStatusBarAndNavBar;
@property (nonatomic) double heightTabBar;
@property (nonatomic) double yOriginOfTableView;
@property (nonatomic,strong) NSArray *arrayForAccuracy;
@property (nonatomic,strong) NSArray *arrayForDistance;
@property (nonatomic,strong) NSArray *arrayForKD;
@property (nonatomic,strong) UISegmentedControl *segControl;
@property (nonatomic,strong) BackgroundDrawer *bgDrawer;
@property (nonatomic,strong) UIColor *tableBorderColor;
@property (nonatomic,strong) UIColor *tableBackgroundColor;


@end

@implementation LeaderboardViewController

// this hides the foregroundbars and ring as to prevent it from seeing it a split second before its scaled large again when the user goes back to the screen
- (void)viewDidDisappear:(BOOL)animated {
    [self.bgDrawer hideBarElements];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.bgDrawer.shouldContinue = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    self.bgDrawer.shouldContinue = YES;
    [self.bgDrawer continueDrawing];
    [self.bgDrawer enterAnimation];
    
    [[OALSimpleAudio sharedInstance] playEffect:METALCLANK_SOUND];
    [[OALSimpleAudio sharedInstance] playEffect:BUTTONPRESS_SOUND];

}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"queryDone" object:nil];

    //[self.loadCircle removeFromSuperview];
}

- (void)reloadTable {
    
    // NOTE: Putting the reloadData in the main queue SOLVES the issue where the user has to interact with the table in order for the table to reload, visually
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)drawTableBorder {
    self.tableBorder = [[UIView alloc]initWithFrame:CGRectMake(self.tableView.frame.origin.x - tableBoxPadding,
                                                              self.tableView.frame.origin.y - tableBoxPadding,
                                                              self.tableView.frame.size.width + tableBoxPadding * 2,
                                                              self.tableView.frame.size.height + tableBoxPadding * 2)];
    self.tableBorder.backgroundColor = self.tableBackgroundColor;
    self.tableBorder.layer.borderWidth = 1;
    self.tableBorder.layer.borderColor = self.tableBorderColor.CGColor;

    [self.view addSubview:self.tableBorder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    
    self.tableBackgroundColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.3];
    self.tableBorderColor = [UIColor colorWithRed:90.0/255.0 green:195.0/255.0 blue:247.0/255.0 alpha:.6];

    self.tabBarController.tabBar.alpha = 1;
    
    self.bgDrawer = [BackgroundDrawer new];
    [self.bgDrawer setUpBackgroundOnView:self.view nameOfView:@"Leaderboards" side:@"left"];


    // set size of top bar size
    self.heightOfStatusBarAndNavBar = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    self.heightTabBar = self.tabBarController.tabBar.frame.size.height;

    // set up segmented control categories
    NSArray *array = @[@"Distance", @"K/D", @"Accuracy"];
    
    // initialize datasource+
    self.dataSource = [LeaderboardDataSource new];
    
    double widthOfSegControl = 30;
    
    // set up table view
//    self.yOriginOfTableView = self.segControl.frame.origin.y + self.segControl.frame.size.height + 7;
    self.yOriginOfTableView = self.heightOfStatusBarAndNavBar + padding * 4;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(margin, self.yOriginOfTableView,
                                                                  self.view.frame.size.width - margin * 2 - widthOfSegControl,
                                                                  self.view.frame.size.height - (self.heightOfStatusBarAndNavBar + self.heightTabBar + self.yOriginOfTableView))];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self drawTableBorder];
    [self.dataSource registerTableView:self.tableView];
    [self.view addSubview:self.tableView];
    
    [self createHeaderBarForTable];
    
    double xOriginOfSegControl = margin + self.tableView.frame.size.width;
    
    // create segment control
    self.segControl = [[UISegmentedControl alloc]initWithItems:array];
        self.segControl.layer.anchorPoint = CGPointMake(0.0f, 0.0f);
    self.segControl.frame = CGRectMake(xOriginOfSegControl + margin*1.5, self.tableView.frame.origin.y, self.tableView.frame.size.height, widthOfSegControl);
    self.segControl.selectedSegmentIndex = 0;
    self.segControl.backgroundColor = self.tableBackgroundColor;
    self.segControl.tintColor = self.tableBorderColor;

    self.segControl.transform = CGAffineTransformMakeRotation(M_PI / 2.0);

    
    [self.segControl addTarget:self action:@selector(updateSort:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segControl];

}

- (void) createHeaderBarForTable {
    //create header for table indicating rank/country/record
    UIView *headerBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, -20)];
    [self.tableBorder addSubview:headerBar];
    headerBar.backgroundColor = self.tableBorderColor;

    [self insertLabelAtXOrigin:.02 text:@"RANK" onView:headerBar];
    [self insertLabelAtXOrigin:.2 text:@"NAME" onView:headerBar];
    [self insertLabelAtXOrigin:.45 text:@"COUNTRY" onView:headerBar];
    [self insertLabelAtXOrigin:.85 text:@"RECORD" onView:headerBar];
}

- (void) insertLabelAtXOrigin:(double)xOrigin text:(NSString *)text onView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin * view.frame.size.width, -30, 100, view.frame.size.height)];
    label.text = text;
    label.font = [UIFont fontWithName:@"Menlo" size:10];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
}

- (void)updateSort:(id)sender {
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

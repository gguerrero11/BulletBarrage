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
@property (nonatomic) float unselectedCellSize;
@property (nonatomic) float selectedCellSize;

@end

@implementation ProfileviewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
    
    // table datasource stuff
    self.dataSource = [ProfileViewDataSource new];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -paddingFromGroupTable, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    
    [self.dataSource registerTableView:self.tableView];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCellSize = self.view.frame.size.width;
    if (indexPath.row == 0) {
        return self.selectedCellSize;
    }
    NSLog(@"height %f", self.view.frame.size.height);
        NSLog(@"width %f", self.view.frame.size.width);
    
    NSLog(@"TFrame %f", self.navigationController.navigationBar.frame.size.height);
    NSLog(@"TBounds %f", self.tabBarController.tabBar.frame.size.height);
    
    float remainingFrameSize =  self.view.frame.size.height -
                                self.navigationController.navigationBar.frame.size.height -
                                self.tabBarController.tabBar.frame.size.height -
                                self.view.frame.size.width -
                                20;
    
    NSLog(@"%f", remainingFrameSize);
    
    self.unselectedCellSize = remainingFrameSize / 2;
    return self.unselectedCellSize;
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
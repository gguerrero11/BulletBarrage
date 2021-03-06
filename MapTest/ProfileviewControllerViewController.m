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
    
    // init array for selecting cells

    
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
                                20;
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
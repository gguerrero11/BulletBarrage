//
//  ProfileviewControllerViewController.m
//  MapTest
//
//  Created by Gabriel Guerrero on 4/3/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import "ProfileviewControllerViewController.h"
#import "ProfileViewDataSource.h"
#import "BackgroundDrawer.h"

#import "ObjectAL.h"
#define BUTTONPRESS_SOUND @"buttonPress2.caf"
#define METALCLANK_SOUND @"metalClank.caf"


@interface ProfileviewControllerViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ProfileViewDataSource *dataSource;
@property (nonatomic, strong) BackgroundDrawer *bgDrawer;
@property (nonatomic) float unselectedCellHeight;
@property (nonatomic) float selectedCellHeight;
@property (nonatomic) NSInteger selectedIndex;




@end

@implementation ProfileviewControllerViewController

// this hides the foregroundbars and ring as to prevent it from seeing it a split second before its scaled large again when the user goes back to the screen
- (void)viewDidDisappear:(BOOL)animated {
    [self.bgDrawer hideBarElements];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.bgDrawer.shouldContinue = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    self.bgDrawer.shouldContinue = YES;
    [self.bgDrawer continueDrawing];
    [self.bgDrawer enterAnimation];
    [[OALSimpleAudio sharedInstance] playEffect:METALCLANK_SOUND];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    
    // table datasource stuff
    self.dataSource = [ProfileViewDataSource new];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.dataSource registerTableView:self.tableView];
    [self.view addSubview:self.tableView];
    
    self.bgDrawer = [BackgroundDrawer new];
    [self.bgDrawer setUpBackgroundOnView:self.view nameOfView:@"Profile"];
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
    [UIApplication sharedApplication].statusBarFrame.size.height;
    self.unselectedCellHeight = remainingFrameSize / 2;
    return self.unselectedCellHeight + 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect cell
        [[OALSimpleAudio sharedInstance] playEffect:BUTTONPRESS_SOUND];
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
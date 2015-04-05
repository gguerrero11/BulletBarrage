//
//  ProfileViewDataSource.h
//  MapTest
//
//  Created by Gabriel Guerrero on 4/3/15.
//  Copyright (c) 2015 Gabe Guerrero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ProfileViewDataSource : NSObject   <UITableViewDataSource>

- (void)registerTableView:(UITableView *)tableView;

@end

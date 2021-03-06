//
//  YXDrawerViewController.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"

@interface YXDrawerViewController : YXBaseViewController
@property (nonatomic, strong) UIViewController *paneViewController;
@property (nonatomic, strong) UIViewController *drawerViewController;
@property (nonatomic, assign) CGFloat drawerWidth;

- (void)showDrawer;
- (void)hideDrawer;

@end

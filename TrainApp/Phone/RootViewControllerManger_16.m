//
//  RootViewControllerManger_16.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RootViewControllerManger_16.h"
#import "YXSideMenuViewController.h"
#import "YXProjectMainViewController.h"
#import "YXDrawerViewController.h"
#import "YXNavigationController.h"
@implementation RootViewControllerManger_16
- (void)showDrawerViewController:(__weak UIWindow *)window {    
    YXDrawerViewController *drawerVC  = (YXDrawerViewController *)window.rootViewController;
    if (drawerVC.paneViewController.presentedViewController) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainPushNotification object:nil];
    }
    YXNavigationController *projectNavi = (YXNavigationController *)drawerVC.paneViewController;
    if ([projectNavi.viewControllers.lastObject isKindOfClass:[NSClassFromString(@"YXDynamicViewController") class]]){
        return ;
    }
    UIViewController *VC = [[NSClassFromString(@"YXDynamicViewController") alloc] init];
    [projectNavi pushViewController:VC animated:YES];
}
- (UIViewController *)rootViewController {
    YXSideMenuViewController *menuVC = [[YXSideMenuViewController alloc]init];
    YXProjectMainViewController *projectVC = [[YXProjectMainViewController alloc]init];
    YXNavigationController *projectNavi = [[YXNavigationController alloc]initWithRootViewController:projectVC];
    YXDrawerViewController *drawerVC = [[YXDrawerViewController alloc]init];
    drawerVC.drawerViewController = menuVC;
    drawerVC.paneViewController = projectNavi;
    drawerVC.drawerWidth = kScreenWidth * YXTrainLeftDrawerWidth/750.0f;
    return drawerVC;
}
@end

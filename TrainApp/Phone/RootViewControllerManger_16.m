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
#import "YXWebViewController.h"
@implementation RootViewControllerManger_16
- (void)showDrawerViewController:(__weak UIWindow *)window {    
    YXDrawerViewController *drawerVC  = (YXDrawerViewController *)window.rootViewController;
    if (drawerVC.paneViewController.presentedViewController) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainPushNotification object:nil];
    }
    YXNavigationController *projectNavi = (YXNavigationController *)drawerVC.paneViewController;
    if ([LSTSharedInstance sharedInstance].geTuiManger.url > 0){
        if ([projectNavi.viewControllers.lastObject isKindOfClass:[NSClassFromString(@"YXWebViewController") class]]){
            return ;
        }
        YXWebViewController *webView = [[YXWebViewController alloc] init];
        webView.urlString = [NSString stringWithFormat:@"%@/%@",[LSTSharedInstance sharedInstance].geTuiManger.url,[LSTSharedInstance sharedInstance].userManger.userModel.uid];
        webView.titleString = [LSTSharedInstance sharedInstance].geTuiManger.title;
        webView.isUpdatTitle = YES;
        [projectNavi pushViewController:webView animated:YES];
        [YXDataStatisticsManger trackPage:@"元旦贺卡" withStatus:YES];
        WEAK_SELF
        [webView setBackBlock:^{
            STRONG_SELF
            [YXDataStatisticsManger trackPage:@"元旦贺卡" withStatus:NO];
        }];
        [LSTSharedInstance sharedInstance].geTuiManger.url = nil;
        return;
    }
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

//
//  RootViewControllerManger.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "RootViewControllerManger.h"
#import "RootViewControllerManger_16.h"
#import "RootViewControllerManger_17.h"
#import "YXNavigationController.h"
#import "YXTabBarViewController_17.h"
#import "YXDrawerViewController.h"
#import "YXWebViewController.h"
#import "NoticeAndBriefDetailViewController.h"
#import "YXHomeworkInfoViewController.h"
#import "MasterHomeworkDetailViewController_17.h"
#import "MasterHomeworkSetListDetailViewController_17.h"

@implementation RootViewControllerManger
+ (instancetype)alloc{
    if ([self class] == [RootViewControllerManger class]) {
        if ([LSTSharedInstance sharedInstance].trainManager.trainStatus == LSTTrainProjectStatus_2016) {
           return [RootViewControllerManger_16 alloc];
        }else {
           return [RootViewControllerManger_17 alloc];
        }
    }
    return [super alloc];
}
- (void)showDynamicViewController:(UIWindow *)window {
    YXNavigationController *projectNavi = nil;
    if ([LSTSharedInstance sharedInstance].trainManager.trainStatus == LSTTrainProjectStatus_2016) {
        YXDrawerViewController *drawerVC  = (YXDrawerViewController *)window.rootViewController;
        if (drawerVC.paneViewController.presentedViewController) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainPushNotification object:nil];
        }
        projectNavi = (YXNavigationController *)drawerVC.paneViewController;
    }else if ([LSTSharedInstance sharedInstance].trainManager.trainStatus == LSTTrainProjectStatus_2017) {
        YXTabBarViewController_17 *tabVC  = (YXTabBarViewController_17 *)window.rootViewController;
        if (tabVC.selectedViewController.presentedViewController) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainPushNotification object:nil];
        }
        projectNavi = (YXNavigationController *)tabVC.selectedViewController;
    }
    if ([LSTSharedInstance sharedInstance].geTuiManger.pushModel.extendInfo.baseUrl.length > 0){
        if ([projectNavi.viewControllers.lastObject isKindOfClass:[NSClassFromString(@"YXWebViewController") class]]){
            return ;
        }
        YXWebViewController *webView = [[YXWebViewController alloc] init];
        webView.urlString = [NSString stringWithFormat:@"%@/%@",[LSTSharedInstance sharedInstance].geTuiManger.pushModel.extendInfo.baseUrl,[LSTSharedInstance sharedInstance].userManger.userModel.uid];
        webView.titleString =  [LSTSharedInstance sharedInstance].geTuiManger.pushModel.title;
        webView.isUpdatTitle = YES;
        [projectNavi pushViewController:webView animated:YES];
        [LSTSharedInstance sharedInstance].geTuiManger.pushModel = nil;
        [YXDataStatisticsManger trackPage:@"元旦贺卡" withStatus:YES];
        WEAK_SELF
        [webView setBackBlock:^{
            STRONG_SELF
            [YXDataStatisticsManger trackPage:@"元旦贺卡" withStatus:NO];
        }];
        return;
    }
    if ([LSTSharedInstance sharedInstance].geTuiManger.pushModel.type.integerValue == 1) {
        NoticeAndBriefDetailViewController *VC = [[NoticeAndBriefDetailViewController alloc] init];
        VC.nbIdString = [LSTSharedInstance sharedInstance].geTuiManger.pushModel.objectId;
        VC.titleString = [LSTSharedInstance sharedInstance].geTuiManger.pushModel.title;
        VC.detailFlag =  NoticeAndBriefFlag_Notice;
        WEAK_SELF
        VC.requestSuccessBlock = ^{
            STRONG_SELF
            [UIApplication sharedApplication].applicationIconBadgeNumber --;
            [LSTSharedInstance sharedInstance].redPointManger.dynamicInteger = [UIApplication sharedApplication].applicationIconBadgeNumber;
        };
        [projectNavi pushViewController:VC animated:YES];
        return;
    }
    if ([LSTSharedInstance sharedInstance].geTuiManger.pushModel.type.integerValue == 2) {
        NoticeAndBriefDetailViewController *VC = [[NoticeAndBriefDetailViewController alloc] init];
        VC.nbIdString = [LSTSharedInstance sharedInstance].geTuiManger.pushModel.objectId;
        VC.titleString = [LSTSharedInstance sharedInstance].geTuiManger.pushModel.title;
        VC.detailFlag = NoticeAndBriefFlag_Brief;
        WEAK_SELF
        VC.requestSuccessBlock = ^{
            STRONG_SELF
            [UIApplication sharedApplication].applicationIconBadgeNumber --;
            [LSTSharedInstance sharedInstance].redPointManger.dynamicInteger = [UIApplication sharedApplication].applicationIconBadgeNumber;
        };
        [projectNavi pushViewController:VC animated:YES];
        return;
    }
    
    if ([LSTSharedInstance sharedInstance].geTuiManger.pushModel.type.integerValue == 3 || [LSTSharedInstance sharedInstance].geTuiManger.pushModel.type.integerValue == 4) {
        YXHomeworkInfoRequestItem_Body *itemBody = [[YXHomeworkInfoRequestItem_Body alloc] init];
        itemBody.type = @"4";
        itemBody.requireId = @"";
        itemBody.homeworkid = [LSTSharedInstance sharedInstance].geTuiManger.pushModel.objectId;
        itemBody.title = [LSTSharedInstance sharedInstance].geTuiManger.pushModel.title;
        itemBody.pid = [LSTSharedInstance sharedInstance].geTuiManger.pushModel.projectId;
        YXHomeworkInfoViewController *VC = [[YXHomeworkInfoViewController alloc] init];
        VC.itemBody = itemBody;
        WEAK_SELF
        VC.requestSuccessBlock = ^{
            STRONG_SELF
            [UIApplication sharedApplication].applicationIconBadgeNumber --;
            [LSTSharedInstance sharedInstance].redPointManger.dynamicInteger = [UIApplication sharedApplication].applicationIconBadgeNumber;
        };
        [projectNavi pushViewController:VC animated:YES];
        return;
    }
    if ([LSTSharedInstance sharedInstance].geTuiManger.pushModel.type.integerValue == 34) {
        MasterHomeworkDetailViewController_17 *VC = [[MasterHomeworkDetailViewController_17 alloc] init];
        VC.homeworkId = [LSTSharedInstance sharedInstance].geTuiManger.pushModel.objectId;
        VC.pid = [LSTSharedInstance sharedInstance].geTuiManger.pushModel.projectId;
        VC.titleString =[LSTSharedInstance sharedInstance].geTuiManger.pushModel.title;
        WEAK_SELF
        VC.requestSuccessBlock = ^{
            STRONG_SELF
            [UIApplication sharedApplication].applicationIconBadgeNumber --;
            [LSTSharedInstance sharedInstance].redPointManger.dynamicInteger = [UIApplication sharedApplication].applicationIconBadgeNumber;
        };
        [projectNavi pushViewController:VC animated:YES];
        return;
    }
    if ([LSTSharedInstance sharedInstance].geTuiManger.pushModel.type.integerValue == 35) {
        MasterHomeworkSetListDetailViewController_17 *VC = [[MasterHomeworkSetListDetailViewController_17 alloc] init];
        VC.homeworkSetId = [LSTSharedInstance sharedInstance].geTuiManger.pushModel.objectId;
        VC.pid = [LSTSharedInstance sharedInstance].geTuiManger.pushModel.projectId;
        VC.titleString =[LSTSharedInstance sharedInstance].geTuiManger.pushModel.title;
        WEAK_SELF
        VC.requestSuccessBlock = ^{
            STRONG_SELF
            [UIApplication sharedApplication].applicationIconBadgeNumber --;
            [LSTSharedInstance sharedInstance].redPointManger.dynamicInteger = [UIApplication sharedApplication].applicationIconBadgeNumber;
        };
        [projectNavi pushViewController:VC animated:YES];
        return;
    }
    if ([projectNavi.viewControllers.lastObject isKindOfClass:[NSClassFromString(@"YXDynamicViewController") class]]){
        return ;
    }
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.role.integerValue == 9) {
        UIViewController *VC = [[NSClassFromString(@"YXDynamicViewController") alloc] init];
        [projectNavi pushViewController:VC animated:YES];
    }
}
- (UIViewController *)rootViewController {
    return nil;
}
@end

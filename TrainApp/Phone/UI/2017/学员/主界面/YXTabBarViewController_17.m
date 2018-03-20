//
//  XYMainViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXTabBarViewController_17.h"
#import "YXNavigationController.h"
#import "YXVideoRecordViewController.h"
#import "UITabBar+YXAddtion.h"
@interface YXTabBarViewController_17 ()<UITabBarControllerDelegate>

@end

@implementation YXTabBarViewController_17
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[LSTSharedInstance sharedInstance].webSocketManger open];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kYXTrainPushWebSocketReceiveMessage object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        NSInteger redInteger = [LSTSharedInstance sharedInstance].redPointManger.showRedPointInteger;
        NSInteger indexInteger = 2;
        if (self.viewControllers.count == 3) {
            indexInteger = 1;
        }
        if (redInteger > 0) {
            if (redInteger > 99){
                self.viewControllers[indexInteger].tabBarItem.badgeValue = @"99+";
            }else{
                self.viewControllers[indexInteger].tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)[LSTSharedInstance sharedInstance].redPointManger.showRedPointInteger];
            }
            [self.tabBar hideBadgeOnItemIndex:indexInteger withTabbarItem:self.viewControllers.count];
        }else if (redInteger == 0){
            self.viewControllers[indexInteger].tabBarItem.badgeValue = nil;
            [self.tabBar showBadgeOnItemIndex:indexInteger withTabbarItem:self.viewControllers.count];
        }else {
            self.viewControllers[indexInteger].tabBarItem.badgeValue = nil;
            [self.tabBar hideBadgeOnItemIndex:indexInteger withTabbarItem:self.viewControllers.count];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITabBarDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}
- (BOOL)shouldAutorotate {
    if ([self.presentedViewController isKindOfClass:[YXVideoRecordViewController class]]) {
        return self.presentedViewController.shouldAutorotate;
    }else {
        return ((YXNavigationController *)self.selectedViewController).topViewController.shouldAutorotate;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) {
    if ([self.presentedViewController isKindOfClass:[YXVideoRecordViewController class]]) {
        return self.presentedViewController.supportedInterfaceOrientations;
    }else {
        return ((YXNavigationController *)self.selectedViewController).topViewController.supportedInterfaceOrientations;
    }
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if ([self.presentedViewController isKindOfClass:[YXVideoRecordViewController class]]) {
        [self.presentedViewController viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    }else {
        [((YXNavigationController *)self.selectedViewController).topViewController viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    }
}
- (BOOL)prefersStatusBarHidden {
    if ([self.presentedViewController isKindOfClass:[YXVideoRecordViewController class]]) {
        return [self.presentedViewController prefersStatusBarHidden];
    }else {
        return [((YXNavigationController *)self.selectedViewController).topViewController prefersStatusBarHidden];
    }
}
@end

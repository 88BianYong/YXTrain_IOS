//
//  MasterTabBarViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterTabBarViewController_17.h"
#import "YXNavigationController.h"
#import "YXVideoRecordViewController.h"
#import "UITabBar+YXAddtion.h"
@interface MasterTabBarViewController_17 ()<UITabBarControllerDelegate>
@end

@implementation MasterTabBarViewController_17
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kYXTrainPushWebSocketReceiveMessage object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        NSInteger redInteger = [LSTSharedInstance sharedInstance].redPointManger.showRedPointInteger;
        if (redInteger > 0) {
            if (redInteger > 99){
                self.viewControllers[2].tabBarItem.badgeValue = @"99+";
            }else{
                self.viewControllers[2].tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)[LSTSharedInstance sharedInstance].redPointManger.showRedPointInteger];
            }
            [self.tabBar hideBadgeOnItemIndex:1 withTabbarItem:3];
        }else if (redInteger == 0){
            [self.tabBar showBadgeOnItemIndex:1 withTabbarItem:3];
            self.viewControllers[2].tabBarItem.badgeValue = nil;
        }else {
            self.viewControllers[2].tabBarItem.badgeValue = nil;
            [self.tabBar hideBadgeOnItemIndex:1 withTabbarItem:3];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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

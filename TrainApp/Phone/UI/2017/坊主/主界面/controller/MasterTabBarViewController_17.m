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

//
//  XYMainViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXTabBarViewController_17.h"

@interface YXTabBarViewController_17 ()<UITabBarControllerDelegate>

@end

@implementation YXTabBarViewController_17

- (void)viewDidLoad {
    [super viewDidLoad];
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


@end

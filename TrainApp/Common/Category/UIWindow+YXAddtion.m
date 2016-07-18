//
//  UIWindow+YXAddtion.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/19.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "UIWindow+YXAddtion.h"

@implementation UIWindow (YXAddtion)
- (UIViewController *)visibleViewController{
    UIViewController *rootViewController = self.rootViewController;
    return [UIWindow getVisibleViewControllerFrom:rootViewController];
}
+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    }
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}
@end

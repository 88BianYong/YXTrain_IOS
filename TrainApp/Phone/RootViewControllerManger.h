//
//  RootViewControllerManger.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootViewControllerManger : NSObject
- (void)showDynamicViewController:(UIWindow *)window;
- (UIViewController *)rootViewController;
@end

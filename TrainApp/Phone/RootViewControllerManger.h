//
//  RootViewControllerManger.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootViewControllerManger : NSObject
/**
 变换项目模板

 @param window window
 @param isPush 是否通过推送切换
 */
- (void)reloadProjectTemplateViewController:(UIWindow *)window withPushNotification:(BOOL)isPush;
- (UIViewController *)rootViewController;
@end

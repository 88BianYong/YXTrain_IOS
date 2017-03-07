//
//  AppDelegateHelper.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDelegateHelper : NSObject
- (instancetype)initWithWindow:(UIWindow *)window;
@property (nonatomic, strong, readonly) UIWindow *window;

// 启动的根视图控制器
- (void)setupRootViewController;

- (void)scanCodeEntry:(NSURL *)url;

@end

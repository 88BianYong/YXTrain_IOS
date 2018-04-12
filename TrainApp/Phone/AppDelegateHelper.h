//
//  AppDelegateHelper.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootViewControllerManger.h"
@interface AppDelegateHelper : NSObject
- (instancetype)initWithWindow:(UIWindow *)window;
@property (nonatomic, strong, readonly) UIWindow *window;
@property (nonatomic, strong) NSURL *scanCodeUrl;

@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *seg;
@property (nonatomic, copy) NSString *courseType;
@property (nonatomic, strong) RootViewControllerManger *rootManger;

// 启动的根视图控制器
- (void)setupRootViewController;
@end

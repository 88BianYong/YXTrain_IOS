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
- (void)showDrawerViewController:(UIWindow *)window {
    
}
- (UIViewController *)rootViewController {
    return nil;
}
@end

//
//  LSTSharedInstance.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXMockParser.h"
#import "YXTrainManager.h"
#import "TrainGeTuiManger.h"
#import "PopUpFloatingViewManager.h"
#import "YXFileRecordManager.h"
#import "YXRecordManager.h"
#import "YXUserManager.h"
#import "YXWebSocketManger.h"
#import "TrainRedPointManger.h"
#import "YXConfigManager.h"
#import "YXDatumGlobalSingleton.h"
#import "YXMockParser.h"
#import "YXInitRequest.h"
#import "YXUpdateProfileRequest.h"

@interface LSTSharedInstance : NSObject
@property (nonatomic, strong, readonly) YXConfigManager *configManager;//配置文件
@property (nonatomic, strong, readonly) YXUserManager *userManger;//储存个人信息
@property (nonatomic, strong, readonly) YXTrainManager *trainManager;//项目列表
@property (nonatomic, strong, readonly) TrainGeTuiManger *geTuiManger;//个推
@property (nonatomic, strong) PopUpFloatingViewManager *floatingViewManager;//浮层管理
@property (nonatomic, strong, readonly) YXFileRecordManager *fileRecordManager;//观看课程保存
@property (nonatomic, strong, readonly) YXInitHelper *upgradeManger;//升级
@property (nonatomic, strong, readonly) YXRecordManager *recordManager;//播放记录上报
@property (nonatomic, strong, readonly) YXUpdateProfileHelper *updateProfileHelper;//更新用户信息
@property (nonatomic, strong, readonly) YXWebSocketManger *webSocketManger;//websock
@property (nonatomic, strong, readonly) TrainRedPointManger *redPointManger;//红点管理
@property (nonatomic, strong, readonly) YXDatumGlobalSingleton *globalSingleton;//资源筛选
@property (nonatomic, strong, readonly) YXMockParser *mockParser;//mock数据管理
+ (instancetype)sharedInstance;
@end

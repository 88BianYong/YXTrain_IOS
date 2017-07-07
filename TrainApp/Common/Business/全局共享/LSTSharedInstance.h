//
//  LSTSharedInstance.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YXTrainManager, TrainGeTuiManger, PopUpFloatingViewManager,YXFileRecordManager;
@interface LSTSharedInstance : NSObject
@property (nonatomic, strong, readonly) YXTrainManager *trainManager;//项目列表
@property (nonatomic, strong, readonly) TrainGeTuiManger *geTuiManger;//个推
@property (nonatomic, strong, readonly) PopUpFloatingViewManager *floatingViewManager;//浮层管理
@property (nonatomic, strong, readonly) YXFileRecordManager *fileRecordManager;//观看课程保存
+ (instancetype)sharedInstance;
@end

//
//  LSTSharedInstance.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YXTrainManager, TrainGeTuiManger;
@interface LSTSharedInstance : NSObject
@property (nonatomic, strong, readonly) YXTrainManager *trainManager;
@property (nonatomic, strong, readonly) TrainGeTuiManger *geTuiManger;
+ (instancetype)sharedInstance;
@end

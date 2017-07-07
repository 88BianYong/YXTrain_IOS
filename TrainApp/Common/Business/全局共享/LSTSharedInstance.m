//
//  LSTSharedInstance.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LSTSharedInstance.h"
#import "YXTrainManager.h"
#import "TrainGeTuiManger.h"
#import "PopUpFloatingViewManager.h"
@interface LSTSharedInstance (){
    YXTrainManager *_trainManager;
    TrainGeTuiManger *_geTuiManger;
    PopUpFloatingViewManager *_floatingViewManager;
}
@end
@implementation LSTSharedInstance
+ (instancetype)sharedInstance {
    static LSTSharedInstance *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LSTSharedInstance alloc] init];
    });
    return sharedInstance;
}
#pragma mark - Manager
- (YXTrainManager *)trainManager {
    if (_trainManager == nil) {
        _trainManager = [[YXTrainManager alloc] init];
    }
    return _trainManager;
}
- (TrainGeTuiManger *)geTuiManger {
    if (_geTuiManger == nil) {
        _geTuiManger = [[TrainGeTuiManger alloc] init];
    }
    return _geTuiManger;
}
- (PopUpFloatingViewManager *)floatingViewManager {
    if (_floatingViewManager == nil && self.trainManager.trainStatus != LSTTrainProjectStatus_unKnow) {
        if (self.trainManager.trainStatus == LSTTrainProjectStatus_2017) {
            _floatingViewManager = [[NSClassFromString(@"PopUpFloatingViewManager_17") alloc] init];
        }else {
            _floatingViewManager = [[NSClassFromString(@"PopUpFloatingViewManager_16") alloc] init];
        }
    }
    return _floatingViewManager;
}
@end

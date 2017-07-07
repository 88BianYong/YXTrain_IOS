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
#import "YXFileRecordManager.h"
#import "YXInitRequest.h"
#import "YXRecordManager.h"
@interface LSTSharedInstance (){
    YXTrainManager *_trainManager;
    TrainGeTuiManger *_geTuiManger;
    PopUpFloatingViewManager *_floatingViewManager;
    YXFileRecordManager *_fileRecordManager;
    YXInitHelper *_upgradeManger;
    YXRecordManager *_recordManager;
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
- (YXFileRecordManager *)fileRecordManager {
    if (_fileRecordManager == nil) {
        _fileRecordManager = [[YXFileRecordManager alloc] init];
    }
    return _fileRecordManager;
}
- (YXInitHelper *)upgradeManger {
    if (_upgradeManger == nil) {
        _upgradeManger = [[YXInitHelper alloc] init];
    }
    return _upgradeManger;
}
- (YXRecordManager *)recordManager {
    if (_recordManager == nil) {
        _recordManager = [[YXRecordManager alloc] init];
    }
    return _recordManager;
}
@end

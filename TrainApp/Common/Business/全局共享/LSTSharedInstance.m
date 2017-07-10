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
#import "YXUpdateProfileRequest.h"
#import "YXUserManager.h"
#import "YXWebSocketManger.h"
#import "TrainRedPointManger.h"
@interface LSTSharedInstance (){
    YXTrainManager *_trainManager;
    TrainGeTuiManger *_geTuiManger;
    PopUpFloatingViewManager *_floatingViewManager;
    YXFileRecordManager *_fileRecordManager;
    YXInitHelper *_upgradeManger;
    YXRecordManager *_recordManager;
    YXUpdateProfileHelper *_updateProfileHelper;
    YXUserManager *_userManger;
    YXWebSocketManger *_webSocketManger;
    TrainRedPointManger *_redPointManger;
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
- (YXUserManager *)userManger {
    if (_userManger == nil) {
        _userManger = [[YXUserManager alloc] init];
    }
    return _userManger;
}

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
- (YXUpdateProfileHelper *)updateProfileHelper {
    if (_updateProfileHelper == nil) {
        _updateProfileHelper = [[YXUpdateProfileHelper alloc] init];
    }
    return _updateProfileHelper;
}
- (YXWebSocketManger *)webSocketManger {
    if (_webSocketManger == nil) {
        _webSocketManger = [[YXWebSocketManger alloc] init];
    }
    return _webSocketManger;
}
- (TrainRedPointManger *)redPointManger {
    if (_redPointManger == nil) {
        _redPointManger = [[TrainRedPointManger alloc] init];
    }
    return _redPointManger;
}
@end

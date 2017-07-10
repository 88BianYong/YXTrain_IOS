//
//  LSTSharedInstance.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LSTSharedInstance.h"
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
    YXConfigManager *_configManager;
    YXDatumGlobalSingleton *_globalSingleton;
    YXMockParser *_mockParser;
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
- (instancetype)init {
    if (self = [super init]) {
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXUserLogoutSuccessNotification object:nil] subscribeNext:^(id x) {
            STRONG_SELF
            self->_floatingViewManager = nil;
//            self->_trainManager = nil;
//            self->_geTuiManger = nil;
//            self->_fileRecordManager = nil;
//            self->_upgradeManger = nil;
//            self->_recordManager = nil;
//            self->_userManger = nil;
//            self->_webSocketManger = nil;
//            self->_redPointManger = nil;
//            self->_configManager = nil;
//            self->_globalSingleton = nil;
//            self->_mockParser = nil;
//            self->_updateProfileHelper = nil;
        }];
    }
    return self;
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
- (YXConfigManager*)configManager {
    if (_configManager == nil) {
        _configManager = [[YXConfigManager alloc] initWithConfigFile:@"YXConfig"];
    }
    return _configManager;
}
- (YXDatumGlobalSingleton *)globalSingleton {
    if (_globalSingleton == nil) {
        _globalSingleton = [[YXDatumGlobalSingleton alloc] init];
    }
    return _globalSingleton;
}
- (YXMockParser *)mockParser {
    if (_mockParser == nil) {
        _mockParser = [[YXMockParser alloc] initWithConfigFile:@"MockConfig"];
    }
    return _mockParser;
}
@end

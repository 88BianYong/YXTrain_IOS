//
//  LSTSharedInstance.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "LSTSharedInstance.h"
#import "PopUpFloatingViewManager_16.h"
#import "PopUpFloatingViewManager_17.h"
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
@property (nonatomic, strong) PopUpFloatingViewManager_16 *floatingManager16;
@property (nonatomic, strong) PopUpFloatingViewManager_17 *floatingManager17;
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
            self.floatingManager17.scoreString = nil;
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
- (PopUpFloatingViewManager_16 *)floatingManager16 {
    if (_floatingManager16 == nil) {
        _floatingManager16 = [[PopUpFloatingViewManager_16 alloc] init];
    }
    return _floatingManager16;
}
- (PopUpFloatingViewManager_17 *)floatingManager17 {
    if (_floatingManager17 == nil) {
        _floatingManager17 = [[PopUpFloatingViewManager_17 alloc] init];
    }
    return _floatingManager17;
}


- (PopUpFloatingViewManager *)floatingViewManager {
    if (self.trainManager.trainStatus == LSTTrainProjectStatus_2016) {
        if (!self.floatingManager17.isShowCMS) {//17显示过后16不在显示
            self.floatingManager16.isShowCMS = NO;
        }
        if (self.floatingManager17.loginStatus != PopUpFloatingLoginStatus_Already) {
            self.floatingManager16.loginStatus =  self.floatingManager17.loginStatus;
        }
        return self.floatingManager16;
    }else if (self.trainManager.trainStatus == LSTTrainProjectStatus_2017) {
        if (!self.floatingManager16.isShowCMS) {//16显示过后17不在显示
            self.floatingManager17.isShowCMS = NO;
        }
        if (self.floatingManager16.loginStatus != PopUpFloatingLoginStatus_Already) {
            self.floatingManager17.loginStatus =  self.floatingManager16.loginStatus;
        }
        return self.floatingManager17;
    }else {
        return nil;
    }
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

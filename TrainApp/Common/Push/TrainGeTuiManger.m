//
//  TrainGeTuiManger.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TrainGeTuiManger.h"
#import <UIKit/UIKit.h>
#import "GeTuiSdk.h"
#import <UserNotifications/UserNotifications.h>
@interface TrainGeTuiManger ()<GeTuiSdkDelegate , UNUserNotificationCenterDelegate>
@property (nonatomic, strong) NSString *currentUid;
@end
@implementation TrainGeTuiManger
+ (TrainGeTuiManger *)sharedInstance {
    static TrainGeTuiManger *manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [[TrainGeTuiManger alloc] init];
    });
    return manger;
}
- (void)registerGeTui {
    if ([[YXUserManager sharedManager] isLogin]) {
        [GeTuiSdk runBackgroundEnable:YES];
        [GeTuiSdk startSdkWithAppId:[YXConfigManager sharedInstance].geTuiAppId appKey:[YXConfigManager sharedInstance].geTuiAppKey appSecret:[YXConfigManager sharedInstance].geTuiAppServer delegate:self];
        [self registerUserNotification];
    }
}

- (void)registerUserNotification {
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(sysVer < 10.0){
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
    }
    else {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
}

- (void)registerDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [GeTuiSdk registerDeviceToken:token];
}
#pragma mark - iOS10 Notification Delegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [self handleApnsContent:response.notification.request.content.userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}


#pragma mark - login/out
- (void)loginSuccess {
    [self resumeGeTuiSDK];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    NSString *uid = [[YXUserManager sharedManager] userModel].uid;
    self.currentUid = uid;
    // 等待SDK启动时间 以及 防止5秒内连续退出登录
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self bindAlias:self.currentUid];
    });
}

- (void)logoutSuccess {
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [self unbindAlias:self.currentUid];
}
- (void)resume {
   [GeTuiSdk resume];
}
- (void)resumeGeTuiSDK {
    [GeTuiSdk resume];
    [GeTuiSdk runBackgroundEnable:YES];
    [GeTuiSdk startSdkWithAppId:[YXConfigManager sharedInstance].geTuiAppId appKey:[YXConfigManager sharedInstance].geTuiAppKey appSecret:[YXConfigManager sharedInstance].geTuiAppServer delegate:self];
    [self registerUserNotification];
}


#pragma mark - GeTuiSdkDelegate
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
    // 个推消息数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    if ([[YXUserManager sharedManager] isLogin]) {
        [self handleGeTuiContent:payloadMsg withOffLine:offLine];
    }
    [self setBadge:0];
}

// SDK启动成功 则返回cid
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    DDLogDebug(@"[GTSdk RegisterClientID]:%@", clientId);
    NSString *uid = [[YXUserManager sharedManager] userModel].uid;
    if (uid) {
        self.currentUid = uid;
        [self bindAlias:self.currentUid];
    }
}

// SDK遇到错误回调: 个推错误报告，集成步骤发生的任何错误都在这里通知
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    NSLog(@"[GTSdk error]:%@", [error localizedDescription]);
}

// SDK运行状态 0:正在启动 1:启动 2:停止
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    NSLog(@"[GTSdk SdkState]:%u", aStatus);
}

// SDK推送是否开启
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"[GTSdk SetModeOff Error]:%@", [error localizedDescription]);
        return;
    }
}

// SDK设置别名回调
- (void)GeTuiSdkDidAliasAction:(NSString *)action result:(BOOL)isSuccess sequenceNum:(NSString *)aSn error:(NSError *)aError {
    if ([kGtResponseBindType isEqualToString:action]) {
        if (isSuccess) {
            NSLog(@"[GTSdk 别名绑定结果]：%@ !, sn : %@", isSuccess ? @"成功" : @"失败", aSn);
        } else {
            NSLog(@"[GTSdk 别名绑定失败]: %@", aError);
        }
    } else if ([kGtResponseUnBindType isEqualToString:action]) {
        if (isSuccess) {
            NSLog(@"[GTSdk 别名解绑结果]：%@ !, sn : %@", isSuccess ? @"成功" : @"失败", aSn);
        } else {
            NSLog(@"[GTSdk 别名解绑失败]: %@", aError);
        }
        [GeTuiSdk destroy];
    }
}

#pragma mark - Private
- (void)setTagNames:(NSString *)tagNames {
    NSArray *names = [tagNames componentsSeparatedByString:@","];
    NSLog(@"[GTSdk 标签设置]：%@", ([GeTuiSdk setTags:names]) ? @"成功" : @"失败");
}

- (void)bindAlias:(NSString *)alias {
    [GeTuiSdk bindAlias:alias andSequenceNum:[NSString stringWithFormat:@"%@-sign", alias]];
}

- (void)unbindAlias:(NSString *)alias {
    [GeTuiSdk unbindAlias:alias andSequenceNum:[NSString stringWithFormat:@"%@-sign", alias]];
}

- (void)setBadge:(NSInteger)badgeNumber {
    [GeTuiSdk setBadge:badgeNumber];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
}

- (void)resetBadge {
    [GeTuiSdk resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark - Handle Notification
// 处理个推推送，App运行中
- (void)handleGeTuiContent:(NSString *)content  withOffLine:(BOOL)offLine{
    if (offLine) {
//        NSError *error = nil;
//        YXApnsContentModel *apns = nil;
//        apns = [[YXApnsContentModel alloc] initWithString:content error:&error];
//        NSLog(@"[Receive GeTui]:%@\n\n", content);
//        
//        [self showNotificationView:apns];
    }else {
        //跳转;
    }
    
}
// 处理来自苹果的推送 App后台或者杀死
-(void)handleApnsContent:(NSDictionary *)dict {
    [GeTuiSdk handleRemoteNotification:dict];
}




@end

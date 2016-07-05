//
//  YXAppStartupManager.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 1/21/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "YXAppStartupManager.h"

@interface YXAppStartupManager ()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic, strong) NSTimer *backgroundTimer;
@end

@implementation YXAppStartupManager

+ (YXAppStartupManager *)sharedInstance {
    NSAssert([YXAppStartupManager class] == self, @"Incorrect use of singleton : %@, %@", [YXAppStartupManager class], [self class]);
    static dispatch_once_t once;
    static YXAppStartupManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)setupForAppdelegate:(id)appdelegate withLauchOptions:(NSDictionary *)options {
    [GlobalUtils setupCore];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    // 1, 把UIApplicationDelegate中DataController部分转移
    // 会先执行AppDelegate.m中的实现，再执行此类中的实现
    // ！！！注意！！！
    // 为完成转移AppDelegate.m中(ApiStubForTransfer)category务必要有API的实现，哪怕为空，否则此类中相应的实现不会调用
    self.window = [appdelegate window];
    
    NSArray *deliveredMethodArray = @[@"applicationWillTerminate:",
                                      @"applicationDidEnterBackground:"
//                                      @"application:handleActionWithIdentifier:forRemoteNotification:completionHandler:",
//                                      @"application:didRegisterForRemoteNotificationsWithDeviceToken:",
//                                      @"application:didFailToRegisterForRemoteNotificationsWithError:",
//                                      @"application:didReceiveRemoteNotification:",
//                                      @"application:openURL:sourceApplication:annotation:",
//                                      @"application:openURL:options:"
                                      ];
    for (NSString *selectorName in deliveredMethodArray) {
        SEL selector = NSSelectorFromString(selectorName);
        [GlobalUtils deliverSelector:selector fromObject:appdelegate toObject:self];
    }
    
    // 3, 设置腾讯信鸽
//    [XGPush startApp:[[YXConfigManager sharedInstance].XGPushID unsignedIntValue] appKey:[YXConfigManager sharedInstance].XGPushKey];
//    // 设置APNS推送与DeviceToken,既调用 resetAPNSWithAccount: 应在获得用户uid时进行
//    if (!isEmpty(options)) {    // 是从推送通知打开App的
//        [XGPush handleLaunching:options];
//        
//        NSString *content = [[options valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey] valueForKey:@"content"];
//        [self dealWithApnsContent:content];
//    }
//    
//    // 4, 初始化接口
//    [[YXInitHelper sharedHelper] requestCompeletion:nil];
//    // 5, 三方登录
//    [[YXSSOAuthManager sharedManager] registerWXApp];
//    [[YXSSOAuthManager sharedManager] registerQQApp];
//    // 6, 用户登录通知
//    [self registerLoginNotifications];
//    
//    // 7, TalkingData
//    [TalkingData sessionStarted:[YXConfigManager sharedInstance].TalkingDataAppID withChannelId:[YXConfigManager sharedInstance].channel];
}

#pragma mark - GlobalUtils相关
- (void)applicationWillTerminate:(UIApplication *)application {
    [GlobalUtils clearCore];
}
#pragma mark - 看课记录后台上报
- (void)applicationDidEnterBackground:(UIApplication *)application{
    if ([YXRecordManager sharedManager].isActive) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kRecordNeedUpdateNotification object:nil];
        [[YXRecordManager sharedManager]report];
        WEAK_SELF
        self.backgroundTaskIdentifier =[application beginBackgroundTaskWithExpirationHandler:^(void) {
            STRONG_SELF
            [self.backgroundTimer invalidate];
            self.backgroundTimer = nil;
            [self endBackgroundTask];
        }];
        self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishRecordTimer) name:kRecordReportCompleteNotification object:nil];
    }
}
- (void)endBackgroundTask{
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    @weakify(self);
    dispatch_async(mainQueue, ^(void) {
        @strongify(self);
        if (self != nil){
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
            // 销毁后台任务标识符
            self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    });
}
- (void)finishRecordTimer {
    [self.backgroundTimer invalidate];
    self.backgroundTimer = nil;
    if (self.backgroundTaskIdentifier) {
        [self endBackgroundTask];
    }
}

- (void)timerMethod:(NSTimer *)paramSender{
    // backgroundTimeRemaining 属性包含了程序留给的我们的时间
    NSTimeInterval backgroundTimeRemaining =[[UIApplication sharedApplication] backgroundTimeRemaining];
    if (backgroundTimeRemaining == DBL_MAX){
        NSLog(@"Background Time Remaining = Undetermined");
    } else {
        NSLog(@"Background Time Remaining = %.02f Seconds", backgroundTimeRemaining);
    }
}
#pragma mark - APNS相关
//- (void)resetAPNSWithAccount:(NSString *)account {
//    if (!isEmpty(account)) {
//        [XGPush unRegisterDevice];
//    }
//    // 信鸽bug ？异步调用unRegisterDevice永远没有回调
//    [self performSelector:@selector(regAfterUnReg:) withObject:account afterDelay:1];
//}
//
//- (void)regAfterUnReg:(NSString *)account {
//    [XGPush setAccount:account];
//
//    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if(sysVer < 8){
//        [self registerPush];
//    }
//    else{
//        [self registerPushForIOS8];
//    }
//}
//
//- (void)registerPush{
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
//}
//
//- (void)registerPushForIOS8{
//    //Types
//    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//    //Actions
//    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
//    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
//    acceptAction.title = @"Accept";
//    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
//    acceptAction.destructive = NO;
//    acceptAction.authenticationRequired = NO;
//    //Categories
//    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
//    inviteCategory.identifier = @"INVITE_CATEGORY";
//    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
//    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
//    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
//    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//}
//
//- (void)dealWithApnsContent:(id)content {
//    if (isEmpty([YXUserManager sharedManager].userModel.passport.token)) {
//        return;
//    }
//    
//    NSError *error = nil;
//    YXApnsContentModel *apns = nil;
//    if ([content isKindOfClass:[NSString class]]) {
//        apns = [[YXApnsContentModel alloc] initWithString:content error:&error];
//    }
//    
//    if ([content isKindOfClass:[NSDictionary class]]) {
//        apns = [[YXApnsContentModel alloc] initWithDictionary:content error:&error];
//    }
//    
//    if (error) {
//        DDLogError(@"apns error");
//    }
//    
//    if ([apns.msg_type intValue] == 0) {
//        // 作业报告
//        [self.reportRequest stopRequest];
//        self.reportRequest = [[YXGetQuestionReportRequest alloc] init];
//        self.reportRequest.ppid = apns.uid;
//        self.reportRequest.flag = @"1";
//        @weakify(self);
//        [self.reportRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
//            @strongify(self);
//            YXIntelligenceQuestionListItem *item = retItem;
//            if (item.data.count > 0 && !error) {
//                // 作业报告
//                if ((self.delegate) && [self.delegate respondsToSelector:@selector(apnsHomeworkReport:paper:)]) {
//                    [self.delegate apnsHomeworkReport:apns paper:item.data[0]];
//                }
//            }
//        }];
//    }
//    
//    if ([apns.msg_type intValue] == 1) {
//        // 某学科作业列表
//        SAFE_CALL_OneParam(self.delegate, apnsHomeworkList, apns);
//    }
//    
//    if ([apns.msg_type intValue] == 2) {
//        // 作业Tab首页
//        SAFE_CALL_OneParam(self.delegate, apnsHomework, apns);
//    }
//    
//    if ([apns.msg_type intValue] == 3) {
//        // 网页，运营用
//        SAFE_CALL_OneParam(self.delegate, apnsWebpage, apns);
//    }
//}

#pragma mark -
//- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
//    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
//        NSLog(@"ACCEPT_IDENTIFIER is clicked");
//    }
//    
//    completionHandler();
//}
//
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    void (^successBlock)(void) = ^(void){
//        DDLogVerbose(@"[XGPush]register successBlock");
//    };
//    
//    void (^errorBlock)(void) = ^(void){
//        DDLogError(@"[XGPush]register errorBlock");
//    };
//    
//    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
//    DDLogVerbose(@"deviceTokenStr is %@",deviceTokenStr);
//}
//
//- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
//    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
//    DDLogError(@"%@",str);
//}
//
//- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
//{
//    UIApplicationState state = [application applicationState];
//    if (state != UIApplicationStateActive) {
//        //        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
//        //        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
//        //        [[UIApplication sharedApplication] cancelAllLocalNotifications];
//        
//        [XGPush handleReceiveNotification:userInfo];
//        NSString *content = [userInfo valueForKey:@"content"];
//        [self dealWithApnsContent:content];
//    }
//    
//    if (state == UIApplicationStateActive) {
//        [XGPush handleReceiveNotification:userInfo];
//        id content = [userInfo valueForKey:@"content"];
//        if (isEmpty([YXUserManager sharedManager].userModel.passport.token)) {
//            return;
//        }
//        
//        NSError *error = nil;
//        YXApnsContentModel *apns = nil;
//        if ([content isKindOfClass:[NSString class]]) {
//            apns = [[YXApnsContentModel alloc] initWithString:content error:&error];
//        }
//        
//        if ([content isKindOfClass:[NSDictionary class]]) {
//            apns = [[YXApnsContentModel alloc] initWithDictionary:content error:nil];
//        }
//        
//        if (error) {
//            DDLogError(@"apns error");
//        }
//        
//        if ([apns.msg_type intValue] == 3) {
//            YXAlertView *alertView = [YXAlertView alertWithMessage:@"有新推送是否查看"];
//            [alertView addCancelButton];
//            [alertView addButtonWithTitle:@"查看" action:^{
//                [self dealWithApnsContent:content];
//            }];
//            [alertView show];
//        }
//    }
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [YXSSOAuthManager handleOpenURL:url];
//}
//
//// 9.0
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
//{
//    return [YXSSOAuthManager handleOpenURL:url];
//}
//
//#pragma mark - 登录
//
//- (void)registerLoginNotifications
//{
//    [self removeLoginNotifications];
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center addObserver:self
//               selector:@selector(loginSuccess:)
//                   name:YXUserLoginSuccessNotification
//                 object:nil];
//    [center addObserver:self
//               selector:@selector(logoutSuccess:)
//                   name:YXUserLogoutSuccessNotification
//                 object:nil];
//    // 家长
//    [center addObserver:self
//               selector:@selector(parentLoginSuccess:)
//                   name:YXParentUserLoginSuccessNotification
//                 object:nil];
//    [center addObserver:self
//               selector:@selector(parentLogoutSuccess:)
//                   name:YXParentUserLogoutSuccessNotification
//                 object:nil];
//    [center addObserver:self
//               selector:@selector(parentBindSuccess:)
//                   name:YXParentUserBindSuccessNotification
//                 object:nil];
//    [center addObserver:self
//               selector:@selector(parentUnBindSuccess:)
//                   name:YXParentUserUnBindSuccessNotification
//                 object:nil];
//    [center addObserver:self
//               selector:@selector(parentExitBindSuccess:)
//                   name:YXParentUserExitBindNotification
//                 object:nil];
//}
//
//- (void)removeLoginNotifications
//{
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center removeObserver:self
//                      name:YXUserLoginSuccessNotification
//                    object:nil];
//    [center removeObserver:self
//                      name:YXUserLogoutSuccessNotification
//                    object:nil];
//    // 家长
//    [center removeObserver:self
//                      name:YXParentUserLoginSuccessNotification
//                    object:nil];
//    [center removeObserver:self
//                      name:YXParentUserLogoutSuccessNotification
//                    object:nil];
//    [center removeObserver:self
//                      name:YXParentUserBindSuccessNotification
//                    object:nil];
//    [center removeObserver:self
//                      name:YXParentUserUnBindSuccessNotification
//                    object:nil];
//    [center removeObserver:self
//                      name:YXParentUserExitBindNotification
//                    object:nil];
//}
//
//- (void)loginSuccess:(NSNotification *)notification
//{
//    SAFE_CALL(self.delegate, userLoginSuccess);
//}
//
//- (void)logoutSuccess:(NSNotification *)notification
//{
//    SAFE_CALL(self.delegate, userLogoutSuccess);
//}
//
//#pragma mark - 家长
//- (void)parentLoginSuccess:(NSNotification *)notification
//{
//    SAFE_CALL(self.delegate, parentUserLoginSuccess);
//}
//
//- (void)parentLogoutSuccess:(NSNotification *)notification
//{
//    SAFE_CALL(self.delegate, parentUserLogoutSuccess);
//}
//
//- (void)parentBindSuccess:(NSNotification *)notification
//{
//    SAFE_CALL(self.delegate, parentUserBindSuccess);
//}
//
//- (void)parentUnBindSuccess:(NSNotification *)notification
//{
//    SAFE_CALL(self.delegate, parentUserUnbindSuccess);
//}
//
//- (void)parentExitBindSuccess:(NSNotification *)notification
//{
//    SAFE_CALL(self.delegate, parentUserExitBindSuccess);
//}

@end

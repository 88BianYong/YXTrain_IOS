//
//  AppDelegate.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <MSDynamicsDrawerViewController.h>
#import "AppDelegate.h"
#import "YXStartViewController.h"
#import "YXNavigationController.h"
#import "YXWebSocketManger.h"
#import "AppDelegate+GetInfoList.h"
#import "TalkingData.h"
#import "TrainGeTuiManger.h"
#import "YXRecordBase.h"
#import "LaunchAppItem.h"
#import "YXNewRecordManager.h"
#import "UIDevice+HardwareName.h"
@interface AppDelegate ()
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic, strong) NSTimer *backgroundTimer;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if([launchOptions objectForKey:UIApplicationLaunchOptionsURLKey] && [[LSTSharedInstance sharedInstance].userManger isLogin]){
         self.appDelegateHelper.scanCodeUrl = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
        [[LSTSharedInstance sharedInstance].userManger logout];
    }
    
    [GlobalUtils setupCore];
    [YXNavigationBarController setup];
    [self setupKeyboardManager];
    
    // 内部统计
    [YXNewRecordManager startRegularReport];
    [self addLaunchAppStatisticWithType:YXRecordStartType];
    //七鱼
    [[QYSDK sharedSDK] registerAppId:@"5c8fda4d1143b9639ef44ef089f387dd" appName:@"手机研修"];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    YXStartViewController *VC = [[YXStartViewController alloc] init];
    self.window.rootViewController = VC;
    [self.window makeKeyAndVisible];
    self.appDelegateHelper = [[AppDelegateHelper alloc] initWithWindow:self.window];
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        self.appDelegateHelper.isRemoteNotification = YES;//标记推送启动
    }
    WEAK_SELF
    [[LSTSharedInstance sharedInstance].upgradeManger requestCompeletion:^(BOOL upgrade) {
        STRONG_SELF
        if (upgrade) {
            [self.appDelegateHelper setupRootViewController];
        }
    }];
    [GlobalUtils setDefaultExceptionHandler];
    [TalkingData setExceptionReportEnabled:YES];
    [YXDataStatisticsManger sessionStarted:@"2D51075BBBC948E36A11E656DABC1775" withChannelId:@"AppStore"];
    [[LSTSharedInstance sharedInstance].geTuiManger registerGeTui];
    return YES;
}

- (void)setupKeyboardManager {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[LSTSharedInstance  sharedInstance].webSocketManger close];
    if ([LSTSharedInstance sharedInstance].recordManager.isActive) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kRecordNeedUpdateNotification object:nil];
        [[LSTSharedInstance sharedInstance].recordManager report];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //[self getInfoListUpdateDate];
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    if ([LSTSharedInstance sharedInstance].recordManager.isActive) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kRecordNeedUpdateNotification object:nil];
        [[LSTSharedInstance sharedInstance].recordManager report];
        WEAK_SELF
        self.backgroundTaskIdentifier =[application beginBackgroundTaskWithExpirationHandler:^(void) {
            STRONG_SELF
            [self.backgroundTimer invalidate];
            self.backgroundTimer = nil;
            [self endBackgroundTask];
        }];
        self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
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
        DDLogDebug(@"Background Time Remaining = Undetermined");
    } else {
        DDLogDebug(@"Background Time Remaining = %.02f Seconds", backgroundTimeRemaining);
    }
}

#pragma mark - ApiStubForTransfer

- (void)applicationWillTerminate:(UIApplication *)application {
    [GlobalUtils clearCore];
}
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[LSTSharedInstance sharedInstance].geTuiManger resume]; // 后台恢复SDK 运行
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[LSTSharedInstance sharedInstance].geTuiManger registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    BOOL result = ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground);
    [[LSTSharedInstance sharedInstance].geTuiManger handleApnsContent:userInfo isPush:!result];
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    DDLogDebug(@"%@",userInfo);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	return YES;
}

// 9.0
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    self.appDelegateHelper.scanCodeUrl = url;
    [[LSTSharedInstance  sharedInstance].webSocketManger close];
    [[LSTSharedInstance sharedInstance].userManger logout];
	return YES;
}

- (void)addLaunchAppStatisticWithType:(YXRecordType)type {
    LaunchAppItem *record = [[LaunchAppItem alloc] init];
    record.type = type;
    record.mobileModel = [[UIDevice currentDevice] platformString];
    record.brand = @"Apple";
    record.system = [UIDevice currentDevice].systemVersion;
    record.resolution = [LaunchAppItem screenResolution];
    record.netModel = [LaunchAppItem networkStatus];
    if (record.uid.length > 0) {
        [YXNewRecordManager addRecord:record];
    }
}

@end

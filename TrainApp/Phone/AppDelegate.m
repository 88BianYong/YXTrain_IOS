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
#import "YXInitRequest.h"

#import "YXWebSocketManger.h"

#import "AppDelegate+GetInfoList.h"
#import "AppDelegateHelper.h"
#import "TalkingData.h"
@interface AppDelegate ()
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic, strong) NSTimer *backgroundTimer;
@property (nonatomic, strong) AppDelegateHelper *appDelegatehelper;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GlobalUtils setupCore];
    [YXNavigationBarController setup];
    [self setupKeyboardManager];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    YXStartViewController *VC = [[YXStartViewController alloc] init];
    self.window.rootViewController = VC;
    [self.window makeKeyAndVisible];
    self.appDelegatehelper = [[AppDelegateHelper alloc] initWithWindow:self.window];
    WEAK_SELF
    [[YXInitHelper sharedHelper] requestCompeletion:^(BOOL upgrade) {
        STRONG_SELF
        if (upgrade) {
            [self.appDelegatehelper setupRootViewController];
        }
    }];
    [GlobalUtils setDefaultExceptionHandler];
    [TalkingData setExceptionReportEnabled:YES];
    [YXDataStatisticsManger sessionStarted:@"2D51075BBBC948E36A11E656DABC1775" withChannelId:@"AppStore"];
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
    [[YXWebSocketManger  sharedInstance] close];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //[self getInfoListUpdateDate];
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    if ([YXRecordManager sharedManager].isActive) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kRecordNeedUpdateNotification object:nil];
        [[YXRecordManager sharedManager] report];
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
        DDLogDebug(@"Background Time Remaining = Undetermined");
    } else {
        DDLogDebug(@"Background Time Remaining = %.02f Seconds", backgroundTimeRemaining);
    }
}

#pragma mark - ApiStubForTransfer

- (void)applicationWillTerminate:(UIApplication *)application {
    [GlobalUtils clearCore];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	return YES;
}

// 9.0
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [[YXWebSocketManger sharedInstance] close];
    [[YXUserManager sharedManager] logout];
    self.appDelegatehelper.scanCodeUrl = url;
    [self.appDelegatehelper scanCodeEntry:url];
	return YES;
}
@end

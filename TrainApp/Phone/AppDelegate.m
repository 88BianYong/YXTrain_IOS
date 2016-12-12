//
//  AppDelegate.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <MSDynamicsDrawerViewController.h>
#import "AppDelegate.h"
#import "YXAppStartupManager.h"
#import "YXStartViewController.h"
#import "YXInitRequest.h"

#import "YXWebSocketManger.h"

#import "AppDelegate+GetInfoList.h"
#import "AppDelegateHelper.h"
@interface AppDelegate ()<YXLoginDelegate>
@property (nonatomic, strong) AppDelegateHelper *appDelegatehelper;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[YXAppStartupManager sharedInstance] setupForAppdelegate:self withLauchOptions:launchOptions];
    [YXNavigationBarController setup];
    [self setupKeyboardManager];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    YXStartViewController *VC = [[YXStartViewController alloc] init];
    self.window.rootViewController = VC;
    [self.window makeKeyAndVisible];
    WEAK_SELF
    [[YXInitHelper sharedHelper] requestCompeletion:^(BOOL upgrade) {
        STRONG_SELF
        if (upgrade) {
            self.appDelegatehelper = [[AppDelegateHelper alloc] initWithWindow:self.window];
            [self.appDelegatehelper setupRootViewController];
        }
    }];
    [GlobalUtils setDefaultExceptionHandler];
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

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //[self getInfoListUpdateDate];
}

#pragma mark - ApiStubForTransfer

- (void)applicationWillTerminate:(UIApplication *)application {
    
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
	return NO;
}

// 9.0
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
	return NO;
}
@end

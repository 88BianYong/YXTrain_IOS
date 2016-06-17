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
#import "YXTestViewController.h"
#import "YXProjectMainViewController.h"
#import "YXSideMenuViewController.h"
#import "YXNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[YXAppStartupManager sharedInstance] setupForAppdelegate:nil withLauchOptions:launchOptions];
    
    [self setupUI];
    return YES;
}

- (void)setupUI{    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    if ([YXConfigManager sharedInstance].testFrameworkOn.boolValue) {
        YXTestViewController *vc = [[YXTestViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    }else{
        MSDynamicsDrawerViewController *drawerVC = [[MSDynamicsDrawerViewController alloc]init];
        drawerVC.gravityMagnitude = 10;
        
        MSDynamicsDrawerShadowStyler *sdst = [MSDynamicsDrawerShadowStyler styler];
        sdst.shadowColor = [UIColor blackColor];
        sdst.shadowOpacity = 0.65;
        sdst.shadowRadius = 10;
        sdst.shadowOffset = CGSizeMake(-4, 0);        
        [drawerVC addStylersFromArray:@[[MSDynamicsDrawerFadeStyler styler], sdst] forDirection:MSDynamicsDrawerDirectionLeft];
        
        YXSideMenuViewController *menuVC = [[YXSideMenuViewController alloc]init];
        [drawerVC setDrawerViewController:menuVC forDirection:MSDynamicsDrawerDirectionLeft];
        
        YXProjectMainViewController *projectVC = [[YXProjectMainViewController alloc]init];
        YXNavigationController *projectNavi = [[YXNavigationController alloc]initWithRootViewController:projectVC];
        [drawerVC setPaneViewController:projectNavi];
        
        self.window.rootViewController = drawerVC;
    }
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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

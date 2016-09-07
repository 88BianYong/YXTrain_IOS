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
#import "YXDrawerViewController.h"
#import "YXLoginViewController.h"
#import "YXStartViewController.h"

#import "YXUserProfileRequest.h"
#import "YXLoginViewController.h"
#import "YXUserManager.h"
#import "YXDatumGlobalSingleton.h"
#import "YXPromtController.h"
#import "YXInitRequest.h"
#import "YXGuideViewController.h"
#import "YXGuideModel.h"
#import "YXCMSCustomView.h"
#import "YXBroseWebView.h"
@interface AppDelegate ()<YXLoginDelegate>

@property (strong, nonatomic) YXDrawerViewController *drawerVC;
@property (strong, nonatomic) YXLoginViewController *loginVC;
@property (nonatomic, strong) YXCMSCustomView *cmsView;



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[YXAppStartupManager sharedInstance] setupForAppdelegate:self withLauchOptions:launchOptions];
    //键盘自动控制
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    [YXNavigationBarController setup];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    YXStartViewController *VC = [[YXStartViewController alloc] init];
    self.window.rootViewController = VC;
    [self.window makeKeyAndVisible];
    WEAK_SELF
    [[YXInitHelper sharedHelper] requestCompeletion:^(BOOL upgrade) {
        STRONG_SELF
        if (upgrade) {
            [self setupUI];
        }
    }];
    [GlobalUtils setDefaultExceptionHandler];
    return YES;
}

- (void)setupUI {
    if ([YXConfigManager sharedInstance].testFrameworkOn.boolValue) {
        YXTestViewController *vc = [[YXTestViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    }else{
        NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
        NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
        NSString *currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:versionKey];
        if ([currentVersion compare:lastVersion] != NSOrderedSame) {
            YXGuideViewController *vc = [[YXGuideViewController alloc] init];
            vc.guideDataArray = [self configGuideArray];
            vc.startMainVCBlock = ^{
                [self startRootVC];
            };
            self.window.rootViewController = vc;
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else {
            [self startRootVC];
        }
    }
}

- (void)startRootVC {
    if ([[YXUserManager sharedManager] isLogin]) {
        self.window.rootViewController = [self rootDrawerViewController];
        [self requestCommonData];
        [self showCMSView];
    } else
    {
        self.loginVC = [[YXLoginViewController alloc] init];
        self.window.rootViewController = [[YXNavigationController alloc] initWithRootViewController:self.loginVC];
    }
}

- (YXDrawerViewController *)rootDrawerViewController {
    
    YXSideMenuViewController *menuVC = [[YXSideMenuViewController alloc]init];
    YXProjectMainViewController *projectVC = [[YXProjectMainViewController alloc]init];
    YXNavigationController *projectNavi = [[YXNavigationController alloc]initWithRootViewController:projectVC];
    
    YXDrawerViewController *drawerVC = [[YXDrawerViewController alloc]init];
    drawerVC.drawerViewController = menuVC;
    drawerVC.paneViewController = projectNavi;
    drawerVC.drawerWidth = [UIScreen mainScreen].bounds.size.width * YXTrainLeftDrawerWidth/750.0f;
    return drawerVC;
}

- (void)requestCommonData
{
	//@weakify(self);
	[[YXUserProfileHelper sharedHelper] requestCompeletion:^(NSError *error) {
		//@strongify(self);
		[[YXDatumGlobalSingleton sharedInstance] getDatumFilterData:nil];
	}];
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

#pragma mark - YXLoginDelegate

- (void)loginSuccess
{
    self.window.rootViewController = [self rootDrawerViewController];
    [self requestCommonData];
}

- (void)logoutSuccess {
    if ([self.window.rootViewController isKindOfClass:[YXDrawerViewController class]]) {
        self.loginVC = [[YXLoginViewController alloc] init];
        self.window.rootViewController = [[YXNavigationController alloc] initWithRootViewController:self.loginVC];
    }
}

- (void)tokenInvalid {
    [[YXUserManager sharedManager] resetUserData];
    [YXPromtController showToast:@"帐号授权已失效，请重新登录" inView:self.window];
    if ([self.window.rootViewController isKindOfClass:[YXDrawerViewController class]]) {
        self.loginVC = [[YXLoginViewController alloc] init];
        self.window.rootViewController = [[YXNavigationController alloc] initWithRootViewController:self.loginVC];
    }
}

- (NSArray *)configGuideArray {
    YXGuideModel *model_0 = [self guideModelWithImageName:@"高效" title:@"高效" detail:@"培训进度清晰直观\n有的放矢提高效率" isShowButton:NO];
    YXGuideModel *model_1 = [self guideModelWithImageName:@"便捷" title:@"便捷" detail:@"随时随地参与培训\n轻松便捷在线学习" isShowButton:NO];;
    YXGuideModel *model_2 = [self guideModelWithImageName:@"全新2.0" title:@"全新2.0" detail:@"通知动态随时查看\n海量资源尽情下载" isShowButton:YES];;
    NSArray *guideArry = @[model_0,model_1,model_2];
    return guideArry;
}

- (YXGuideModel *)guideModelWithImageName:(NSString *)name title:(NSString *)titile detail:(NSString *)detail isShowButton:(BOOL)isShowButton {
    YXGuideModel *model =[[YXGuideModel alloc] init];
    model.guideTitle = titile;
    model.guideImageString = name;
    model.guideDetail = detail;
    model.isShowButton = isShowButton;
    return model;
}


- (void)showCMSView
{
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        return;
    }
    self.cmsView = [[YXCMSCustomView alloc] init];
    [self.window addSubview:self.cmsView];
    [self.cmsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    WEAK_SELF
    [[YXCMSManager sharedManager] requestWithType:@"1" completion:^(NSArray *rotates, NSError *error) {
        STRONG_SELF
        if (error || rotates.count <= 0) {
            [self.cmsView removeFromSuperview];
            return;
        }
        YXRotateListRequestItem_Rotates *rotate = rotates[0];
        [self.cmsView reloadWithModel:rotate];
        WEAK_SELF
        self.cmsView.clickedBlock = ^(YXRotateListRequestItem_Rotates *model) {
            STRONG_SELF
            YXBroseWebView *webView = [[YXBroseWebView alloc] init];
            webView.urlString = model.typelink;
            webView.titleString = model.name;
            [self.window.rootViewController.navigationController pushViewController:webView animated:YES];
        };
    }];
}

@end

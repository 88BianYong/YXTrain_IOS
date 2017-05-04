//
//  AppDelegateHelper.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "AppDelegateHelper.h"
#import "YXTestViewController.h"
#import "YXGuideViewController.h"
#import "YXProjectMainViewController.h"
#import "YXSideMenuViewController.h"
#import "YXNavigationController.h"
#import "YXDrawerViewController.h"
#import "YXLoginViewController.h"

#import "YXGuideModel.h"
#import "YXUserProfileRequest.h"
#import "YXDatumGlobalSingleton.h"
#import "YXInitRequest.h"

#import "YXCMSCustomView.h"
#import "YXWebViewController.h"
#import "TrainGeTuiManger.h"
#import "TrainGeTuiManger.h"

@interface AppDelegateHelper ()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) YXCMSCustomView *cmsView;
@end
@implementation AppDelegateHelper
- (instancetype)initWithWindow:(UIWindow *)window {
    if (self = [super init]) {
        self.window = window;
        [self registeNotifications];
        [self showNotificationViewController];
    }
    return self;
}
- (void)showNotificationViewController{
    [[TrainGeTuiManger sharedInstance] setTrainGeTuiMangerCompleteBlock:^{
        if (self.isRemoteNotification || ![[YXUserManager sharedManager] isLogin] ||
            [YXInitHelper sharedHelper].showUpgradeFlag) {
            return ;//1.通过通知启动需要等待升级接口返回才进行跳转2.未登录不进行跳转3.弹出升级界面不进行跳转
        }
        [self showDrawerViewController];
    }];
}
- (void)showDrawerViewController {
    self.isRemoteNotification = NO;
    if (self.window.rootViewController.presentedViewController) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainPushNotification object:nil];
    }
    YXDrawerViewController *drawerVC  = (YXDrawerViewController *)self.window.rootViewController;
    YXNavigationController *projectNavi = (YXNavigationController *)drawerVC.paneViewController;
    if ([projectNavi.viewControllers.lastObject isKindOfClass:[NSClassFromString(@"YXDynamicViewController") class]]){
        return ;
    }
    UIViewController *VC = [[NSClassFromString(@"YXDynamicViewController") alloc] init];
    [projectNavi popToRootViewControllerAnimated:NO];
    [projectNavi pushViewController:VC animated:YES];
}
- (void)setupRootViewController{
    if ([YXConfigManager sharedInstance].testFrameworkOn.boolValue) {
        YXTestViewController *vc = [[YXTestViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    }else{
        NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
        NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
        NSString *currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:versionKey];
        if ([currentVersion compare:lastVersion] != NSOrderedSame) {
            [[TrainGeTuiManger sharedInstance] resetBadge];
            YXGuideViewController *vc = [[YXGuideViewController alloc] init];
            vc.startMainVCBlock = ^{
                [self startRootVC];
            };
            self.window.rootViewController = vc;
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (![YXTrainManager sharedInstance].trainlistItem.body.training &&![YXTrainManager sharedInstance].trainlistItem.body.trained) {
                [[YXTrainManager sharedInstance] clear];
            }
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
    } else {
        YXLoginViewController *loginVC = [[YXLoginViewController alloc] init];
        self.window.rootViewController = [[YXNavigationController alloc] initWithRootViewController:loginVC];
    }
}
- (void)requestCommonData {
    [[YXUserProfileHelper sharedHelper] requestCompeletion:^(NSError *error) {
        [[YXDatumGlobalSingleton sharedInstance] getDatumFilterData:nil];
    }];
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

#pragma mark - add notification
- (void)registeNotifications
{
    [self removeLoginNotifications];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXUserLoginSuccessNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        self.window.rootViewController = [self rootDrawerViewController];
        [self requestCommonData];
        [[YXInitHelper sharedHelper] showNoRestraintUpgrade];
        [[TrainGeTuiManger sharedInstance] loginSuccess];
        self.isRemoteNotification = NO;
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXUserLogoutSuccessNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        YXLoginViewController *loginVC = [[YXLoginViewController alloc] init];
        self.window.rootViewController = [[YXNavigationController alloc] initWithRootViewController:loginVC];
        [[TrainGeTuiManger sharedInstance] logoutSuccess];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXTokenInValidNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        [[YXUserManager sharedManager] resetUserData];
        YXLoginViewController *loginVC = [[YXLoginViewController alloc] init];
        self.window.rootViewController = [[YXNavigationController alloc] initWithRootViewController:loginVC];
        [YXPromtController showToast:@"帐号授权已失效,请重新登录" inView:self.window];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kYXTrainShowUpdate object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        [self showNoRestraintUpgradeView];
    }];
}

- (void)removeLoginNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self
                      name:YXUserLoginSuccessNotification
                    object:nil];
    [center removeObserver:self
                      name:YXUserLogoutSuccessNotification
                    object:nil];
    [center removeObserver:self
                      name:YXTokenInValidNotification
                    object:nil];
    [center removeObserver:self
                      name:kYXTrainShowUpdate
                    object:nil];
}

- (void)showCMSView {
    if (self.cmsView) {//显示过启动页则不再显示
        return;
    }
    if ([[Reachability reachabilityForInternetConnection] isReachable]) {
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
                [self showNoRestraintUpgradeView];
            }
            else{
                YXRotateListRequestItem_Rotates *rotate = rotates[0];
                [self.cmsView reloadWithModel:rotate];
                WEAK_SELF
                self.cmsView.clickedBlock = ^(YXRotateListRequestItem_Rotates *model) {
                    STRONG_SELF
                    YXWebViewController *webView = [[YXWebViewController alloc] init];
                    webView.urlString = model.typelink;
                    webView.titleString = model.name;
                    [webView setBackBlock:^{
                        STRONG_SELF
                        [[YXInitHelper sharedHelper] showNoRestraintUpgrade];
                        self.isRemoteNotification = NO;
                    }];
                    [self.window.rootViewController.navigationController pushViewController:webView animated:YES];
                };
            }
        }];
    }else{
        [self showNoRestraintUpgradeView];
    }
}
- (void)showNoRestraintUpgradeView {
    if (![[YXInitHelper sharedHelper] showNoRestraintUpgrade] && self.isRemoteNotification) {//通过通知启动且不显示升级时跳转动态界面
        [self showDrawerViewController];
    }
    self.isRemoteNotification = NO;

}
@end

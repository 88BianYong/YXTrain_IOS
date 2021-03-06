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
#import "YXUserProfileRequest.h"

#import "YXCMSCustomView.h"
#import "YXWebViewController.h"
#import "TrainGeTuiManger.h"
#import "TrainGeTuiManger.h"
#import "PopUpFloatingViewManager.h"
#import "XYChooseProjectViewController.h"
#import "YXTabBarViewController_17.h"
#import "UITabBar+YXAddtion.h"
@interface AppDelegateHelper ()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) YXCMSCustomView *cmsView;
@property (nonatomic, strong) YXUserProfileRequest *userProfileRequest;
@property (nonatomic, assign) BOOL isLoginBool;//是否为手动登录
@end
@implementation AppDelegateHelper
- (instancetype)initWithWindow:(UIWindow *)window {
    if (self = [super init]) {
        self.window = window;
        WEAK_SELF
        [[LSTSharedInstance sharedInstance].geTuiManger setTrainGeTuiMangerCompleteBlock:^{
            STRONG_SELF
             [self.rootManger reloadProjectTemplateViewController:self.window withPushNotification:YES];
        }];
        [self registeNotifications];
        
    }
    return self;
}
- (RootViewControllerManger *)rootManger {
    if (_rootManger == nil) {
        _rootManger = [RootViewControllerManger alloc];
    }
    return _rootManger;
}
- (void)setupRootViewController{
    if ([LSTSharedInstance sharedInstance].configManager.testFrameworkOn.boolValue) {
        YXTestViewController *vc = [[YXTestViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    }else{
        NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
        NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
        NSString *currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:versionKey];
        if ([currentVersion compare:lastVersion] != NSOrderedSame) {
            [[LSTSharedInstance sharedInstance].geTuiManger resetBadge];
            YXGuideViewController *vc = [[YXGuideViewController alloc] init];
            vc.startMainVCBlock = ^{
                [self startRootVC];
            };
            self.window.rootViewController = vc;
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (![LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.training &&![LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.trained) {
                [[LSTSharedInstance sharedInstance].trainManager clear];
            }
        }else {
            [self startRootVC];
        }
    }
}
- (void)startRootVC {
    if ([[LSTSharedInstance sharedInstance].userManger isLogin]) {
        YXNavigationController *projectNav = [[YXNavigationController alloc]initWithRootViewController:[[XYChooseProjectViewController alloc] init]];
        self.window.rootViewController = projectNav;
        [self requestCommonData];
    } else {
        YXLoginViewController *loginVC = [[YXLoginViewController alloc] init];
        self.window.rootViewController = [[YXNavigationController alloc] initWithRootViewController:loginVC];
    }
}
- (void)requestCommonData {
    YXUserProfileRequest *request = [[YXUserProfileRequest alloc] init];
    request.targetuid = [LSTSharedInstance sharedInstance].userManger.userModel.uid;
    WEAK_SELF
    [request startRequestWithRetClass:[YXUserProfileItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        YXUserProfileItem *item = retItem;
        if (item) {
            [LSTSharedInstance sharedInstance].userManger.userModel.profile = item.editUserInfo;
            [[LSTSharedInstance sharedInstance].userManger saveUserData];
            [[NSNotificationCenter defaultCenter] postNotificationName:YXUserProfileGetSuccessNotification object:nil];
        }
        [[LSTSharedInstance sharedInstance].globalSingleton getDatumFilterData:nil];
    }];
    self.userProfileRequest = request;
}
#pragma mark - add notification
- (void)registeNotifications {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXUserLoginSuccessNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        YXNavigationController *projectNav = [[YXNavigationController alloc]initWithRootViewController:[[XYChooseProjectViewController alloc] init]];
        self.window.rootViewController = projectNav;
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXUserLogoutSuccessNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        YXLoginViewController *loginVC = [[YXLoginViewController alloc] init];
        self.window.rootViewController = [[YXNavigationController alloc] initWithRootViewController:loginVC];
        self.isLoginBool = NO;
        [[LSTSharedInstance sharedInstance].geTuiManger logoutSuccess];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXTokenInValidNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        [[LSTSharedInstance sharedInstance].userManger resetUserData];

        YXLoginViewController *loginVC = [[YXLoginViewController alloc] init];
        self.window.rootViewController = [[YXNavigationController alloc] initWithRootViewController:loginVC];
        [YXPromtController showToast:@"帐号授权已失效,请重新登录" inView:self.window];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kXYTrainChooseProject object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        self.rootManger = nil;
        if (!isEmpty(self.courseId)) {
            [LSTSharedInstance sharedInstance].floatingViewManager.loginStatus = PopUpFloatingLoginStatus_QRCode;
        }else {
            [LSTSharedInstance sharedInstance].floatingViewManager.loginStatus = PopUpFloatingLoginStatus_Default;
        }
        self.window.rootViewController = [self.rootManger rootViewController];
        if (![LSTSharedInstance sharedInstance].upgradeManger.isShowUpgrade && [LSTSharedInstance sharedInstance].geTuiManger.isLaunchedByNotification) {
            [self.rootManger reloadProjectTemplateViewController:self.window withPushNotification:YES];
        }
        [LSTSharedInstance sharedInstance].geTuiManger.isLaunchedByNotification = NO;
        [[LSTSharedInstance sharedInstance].geTuiManger loginSuccess];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kXYTrainChangeProject object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        self.rootManger = nil;
        if (!isEmpty(self.courseId)) {
            [LSTSharedInstance sharedInstance].floatingViewManager.loginStatus = PopUpFloatingLoginStatus_QRCode;
        }else {
            [LSTSharedInstance sharedInstance].floatingViewManager.loginStatus = PopUpFloatingLoginStatus_Default;
        }
        self.window.rootViewController = [self.rootManger rootViewController];
        [[LSTSharedInstance sharedInstance].geTuiManger loginSuccess];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kYXTrainUserIdentityChange object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        if ([LSTSharedInstance sharedInstance].trainManager.currentProject.w.integerValue >= 5){
            self.rootManger = nil;
            self.window.rootViewController = [self.rootManger rootViewController];
            [[LSTSharedInstance sharedInstance].floatingViewManager startPopUpFloatingView];
            [[LSTSharedInstance sharedInstance].geTuiManger loginSuccess];
        }
    }];
}
@end

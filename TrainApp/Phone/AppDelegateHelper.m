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

@interface AppDelegateHelper ()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) YXCMSCustomView *cmsView;
@end
@implementation AppDelegateHelper
- (instancetype)initWithWindow:(UIWindow *)window {
    if (self = [super init]) {
        self.window = window;
        [self registeNotifications];
    }
    return self;
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
        if (self.scanCodeUrl) {
            [self scanCodeEntry:self.scanCodeUrl];
        }
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLoginSuccess)
                                                 name:YXUserLoginSuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLogoutSuccess )
                                                 name:YXUserLogoutSuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleTokenInvalid)
                                                 name:YXTokenInValidNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showoUpdateInterface)
                                                 name:kYXTrainShowUpdate object:nil];
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

}

- (void)handleLoginSuccess {
    self.window.rootViewController = [self rootDrawerViewController];
    [self requestCommonData];
    [self showoUpdateInterface];
}
- (void)handleLogoutSuccess {
    if (![self.window.rootViewController isKindOfClass:[YXLoginViewController class]]) {
        YXLoginViewController *loginVC = [[YXLoginViewController alloc] init];
        self.window.rootViewController = [[YXNavigationController alloc] initWithRootViewController:loginVC];
    }
}
- (void)showoUpdateInterface {
    [[YXInitHelper sharedHelper] showNoRestraintUpgrade];
}
- (void)handleTokenInvalid {
    [[YXUserManager sharedManager] resetUserData];
    [YXPromtController showToast:@"帐号授权已失效,请重新登录" inView:self.window];
    if (![self.window.rootViewController isKindOfClass:[YXLoginViewController class]]) {
        YXLoginViewController *loginVC = [[YXLoginViewController alloc] init];
        self.window.rootViewController = [[YXNavigationController alloc] initWithRootViewController:loginVC];
    }
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
                [self showoUpdateInterface];
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
                        [self showoUpdateInterface];
                    }];
                    [self.window.rootViewController.navigationController pushViewController:webView animated:YES];
                };
            }
        }];
    }else{
        [self showoUpdateInterface];
    }
    
}

- (void)scanCodeEntry:(NSURL *)url {
    if ([[url scheme] isEqualToString:@"com.yanxiu.lst"]) {
        NSString *query = [url query];
        NSDictionary *paraDic = [self urlInfo:query];
        [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainScanCodeEntry object:paraDic[@"token"]];
    }
}
#pragma mark- 链接内容
- (NSDictionary *)urlInfo:(NSString *)query{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    // 检测字符串中是否包含 ‘&’
    if([query rangeOfString:@"&"].location != NSNotFound){
        // 以 & 来分割字符，并放入数组中
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        // 遍历字符数组
        for (NSString *pair in pairs) {
            // 以等号来分割字符
            NSArray *elements = [pair componentsSeparatedByString:@"="];
            NSString *key = [elements objectAtIndex:0];
            NSString *val = [elements objectAtIndex:1];
            DDLogDebug(@"%@  %@",key, val);
            // 添加到字典中
            [dict setObject:val forKey:key];
        }
    }
    else if([query rangeOfString:@"="].location != NSNotFound){
        // 以等号来分割字符
        NSArray *elements = [query componentsSeparatedByString:@"="];
        NSString *key = [elements objectAtIndex:0];
        NSString *val = [elements objectAtIndex:1];
        DDLogDebug(@"%@  %@",key, val);
        // 添加到字典中
        [dict setObject:val forKey:key];
    }
    return dict;
}

@end

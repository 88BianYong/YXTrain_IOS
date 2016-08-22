//
//  YXInitRequest.m
//  YanXiuApp
//
//  Created by Lei Cai on 6/1/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXInitRequest.h"
#import "YXConfigManager.h"
#import "YXAlertView.h"
#import "YXUserManager.h"
#import "YXPopUpContainerView.h"
#import "YXAppUpdatePopUpView.h"

NSString *const YXInitSuccessNotification = @"kYXInitSuccessNotification";

@implementation YXInitRequestItem_Property

@end

@implementation YXInitRequestItem_Body

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"iid"}];
}

- (BOOL)isTest
{
    if ([self.targetenv isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isForce
{
    if ([self.upgradetype isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

@end

@implementation YXInitRequestItem

@end

@implementation YXInitRequest

- (id)init
{
    self = [super init];
    if (self) {
        _did = [YXConfigManager sharedInstance].deviceID;
        _brand = [YXConfigManager sharedInstance].deviceType;
        [self setCurrentNetType];
        _osType = @"1";
        _appVersion = [YXConfigManager sharedInstance].clientVersion;
        _content = @"";
        _operType = @"app.upload.log";
        _phone = @"";
        _remoteIp = @"";
        _token = [YXUserManager sharedManager].userModel.token;
#ifndef DEBUG
        _mode = @"release";
#else
        _mode = @"test";
#endif
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"initialize"];
    }
    return self;
}

- (void)setCurrentNetType
{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    switch ([r currentReachabilityStatus]) {
        case ReachableViaWiFi:
            _nettype = @"1";
            break;
        case ReachableViaWWAN:
            _nettype = @"0";
            break;
        case NotReachable:
        default:
            break;
    }
}

@end

@interface YXInitHelper ()

@property (nonatomic, strong) YXInitRequest *request;
@property (nonatomic, strong) YXInitRequestItem *item;

@end

@implementation YXInitHelper

- (void)dealloc
{
    [self.request stopRequest];
}

+ (instancetype)sharedHelper
{
    static YXInitHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
        [helper registerNotifications];
    });
    return helper;
}

- (void)requestLoginCompeletion:(void (^)(YXInitRequestItem *, NSError *))completion
{
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXInitRequest alloc] init];
    @weakify(self);
    [self.request startRequestWithRetClass:[YXInitRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        @strongify(self); if (!self) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(retItem, error);
            }
            self.item = retItem;
        });
    }];

}

- (void)requestCompeletion:(void (^)(YXInitRequestItem *, NSError *))completion
{
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXInitRequest alloc] init];
    @weakify(self);
    [self.request startRequestWithRetClass:[YXInitRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        @strongify(self); if (!self) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(retItem, error);
            }
            self.item = retItem;
            [self showUpgradeForInit:YES];
            [self saveAppleCheckingStatusToLocal];
            [[NSNotificationCenter defaultCenter] postNotificationName:YXInitSuccessNotification object:nil];
        });
    }];
}

- (void)registerNotifications
{
    [self removeNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willEnterForeground:(NSNotification *)notification
{
    [self showUpgradeForInit:NO];
}

- (void)showUpgradeForInit:(BOOL)isInit
{
    if (!self.item || self.item.body.count <= 0) {
        return;
    }
    
    YXInitRequestItem_Body *body = self.item.body[0];
    if ([body isTest]) { //测试环境
#ifndef DEBUG
        return;
#endif
    }
    if (![body isForce] && !isInit) { //非强制升级只在初始化弹出一次
        return;
    }
    if (![body.fileURL yx_isHttpLink]) { //http链接
        return;
    }
    if ([body isForce]) {
        YXAlertView *alertView = [YXAlertView alertViewWithTitle:body.title message:body.content];
        [alertView addButtonWithTitle:@"取消"];
        [alertView addButtonWithTitle:@"升级" action:^{
            Reachability *r = [Reachability reachabilityForInternetConnection];
            NetworkStatus status = [r currentReachabilityStatus];
            if (status == ReachableViaWiFi) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:body.fileURL]];
            } else if(status == ReachableViaWWAN){
                YXAlertView *showAlertView = [YXAlertView alertViewWithTitle:@"当前网络非WIFi环境，是否继续更新"];
                if (![body isForce]) {
                    [showAlertView addButtonWithTitle:@"否"];
                }
                [showAlertView addButtonWithTitle:@"继续" action:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:body.fileURL]];
                }];
                [showAlertView show];
            }
        }];
        [alertView show];
        [alertView addButtonWithTitle:@"取消"];
    }
    else{
        [self showUploadTitle:body.title andContent:body.content];
    }

}

- (BOOL)isAppleChecking
{
    id isChecking = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAppleChecking"];
    if (isChecking) {
        return [isChecking boolValue];
    }
    return YES;
}

- (void)saveAppleCheckingStatusToLocal
{
    // 网络请求返回成功，isAppleChecking存在时保存到本地
    NSString *isAppleChecking = self.item.property.isAppleChecking;
    if ([isAppleChecking yx_isValidString]) {
        [[NSUserDefaults standardUserDefaults] setObject:isAppleChecking forKey:@"isAppleChecking"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
/**
 *  这里需要接入真正逻辑
 */
- (void)showUploadTitle:(NSString *)titleString andContent:(NSString *)contentString {
    YXPopUpContainerView *v = [[YXPopUpContainerView alloc] init];
    YXAppUpdateData *data = [[YXAppUpdateData alloc] init];
    data.title = titleString;
    data.content = contentString;
    WEAK_SELF
    YXAlertAction *cancelAlertAct = [[YXAlertAction alloc] init];
    cancelAlertAct.block = ^{
        STRONG_SELF
        [v hide];
    };
    
    YXAlertAction *downloadUpdateAlertAct = [[YXAlertAction alloc] init];
    downloadUpdateAlertAct.block = ^{
        STRONG_SELF
        YXInitRequestItem_Body *body = self.item.body[0];
        Reachability *r = [Reachability reachabilityForInternetConnection];
        NetworkStatus status = [r currentReachabilityStatus];
        if (status == ReachableViaWiFi) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:body.fileURL]];
        } else if(status == ReachableViaWWAN){
            YXAlertView *showAlertView = [YXAlertView alertViewWithTitle:@"当前网络非WIFi环境，是否继续更新"];
            if (![body isForce]) {
                [showAlertView addButtonWithTitle:@"否"];
            }
            [showAlertView addButtonWithTitle:@"继续" action:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:body.fileURL]];
            }];
            [showAlertView show];
        }
        [v hide];
    };
    YXAppUpdatePopUpView *popView = [[YXAppUpdatePopUpView alloc] init];
    [popView setupConstrainsInContainerView:v];
    [popView updateWithData:data actions:@[cancelAlertAct, downloadUpdateAlertAct]];
    [v showInView:nil];
}

@end
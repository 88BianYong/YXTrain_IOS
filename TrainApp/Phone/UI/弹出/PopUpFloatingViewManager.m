//
//  PopUpFloatingViewManager.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PopUpFloatingViewManager.h"
#import "YXInitRequest.h"
#import "YXPopUpContainerView.h"
#import "YXAppUpdatePopUpView.h"
#import "YXAlertView.h"
#import "AppDelegate.h"
#import "YXCMSCustomView.h"
#import "YXWebViewController.h"

@interface PopUpFloatingViewManager ()
@property (nonatomic, strong) YXCMSCustomView *cmsView;
@property (nonatomic, strong) YXPopUpContainerView *upgradeView;
@property (nonatomic, assign) BOOL isShowCMS;
@end
@implementation PopUpFloatingViewManager
+ (instancetype)sharedInstance {
    static PopUpFloatingViewManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PopUpFloatingViewManager alloc] init];
    });
    return manager;
}
- (instancetype)init {
    if (self = [super init]) {
        self.isShowCMS = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPopUpFloatingView) name:@"cancelToUpdate" object:nil];
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kYXTrainShowUpdate object:nil] subscribeNext:^(id x) {
            STRONG_SELF
            self.isShowCMS = NO;
            if ([YXInitHelper sharedHelper].isShowUpgrade && self.upgradeView == nil) {
                [self showUpgradeView];
                BLOCK_EXEC(self.popUpFloatingViewManagerCompleteBlock,NO);
            }else {
                BLOCK_EXEC(self.popUpFloatingViewManagerCompleteBlock,YES);
            }
        }];
    }
    return self;
}

- (void)showPopUpFloatingView {
    if (self.isShowCMS && !self.isLoginFirst) {
        [self showCMSView];
    }else if ([YXInitHelper sharedHelper].isShowUpgrade) {
        if(self.upgradeView == nil) {
            [self showUpgradeView];
        }
    }else if ([self isShowMoreThanOneProject]) {
        [self showMultiProjectCutover];
    }else if ([self isShowRoleChange]) {
        [self showMultiRoleCutover];
    }else if ([self isQRCodePrompt]) {
        [self showQRCodePrompt];
    }
}
- (void)showCMSView {
    if (self.cmsView) {
        return;
    }
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    self.cmsView = [[YXCMSCustomView alloc] init];
    [window addSubview:self.cmsView];
    [self.cmsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    WEAK_SELF
    [[YXCMSManager sharedManager] requestWithType:@"1" completion:^(NSArray *rotates, NSError *error) {
        STRONG_SELF
        if (error || rotates.count <= 0) {
            self.isShowCMS = NO;
            [self.cmsView removeFromSuperview];
            if ([YXInitHelper sharedHelper].isShowUpgrade && self.upgradeView == nil) {
                [self showUpgradeView];
                BLOCK_EXEC(self.popUpFloatingViewManagerCompleteBlock,NO);
            }else {
                BLOCK_EXEC(self.popUpFloatingViewManagerCompleteBlock,YES);
            }
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
                    if ([YXInitHelper sharedHelper].isShowUpgrade && self.upgradeView == nil) {
                        [self showUpgradeView];
                    }
                    self.isShowCMS = NO;
                    BLOCK_EXEC(self.popUpFloatingViewManagerCompleteBlock,NO);
                }];
                [window.rootViewController.navigationController pushViewController:webView animated:YES];
            };
        }
    }];
}
//升级弹窗
- (void)showUpgradeView {
    YXInitRequestItem_Body *body = [YXInitHelper sharedHelper].item.body[0];
    self.upgradeView = [[YXPopUpContainerView alloc] init];
    YXAppUpdateData *data = [[YXAppUpdateData alloc] init];
    data.title = body.title;
    data.content = body.content;
    WEAK_SELF
    YXAlertAction *cancelAlertAct = [[YXAlertAction alloc] init];
    cancelAlertAct.block = ^{
        STRONG_SELF
        [self.upgradeView hide];
        [YXInitHelper sharedHelper].isShowUpgrade = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelToUpdate" object:nil];
    };
    
    YXAlertAction *downloadUpdateAlertAct = [[YXAlertAction alloc] init];
    downloadUpdateAlertAct.block = ^{
        STRONG_SELF
        [YXInitHelper sharedHelper].isShowUpgrade = NO;
        Reachability *r = [Reachability reachabilityForInternetConnection];
        NetworkStatus status = [r currentReachabilityStatus];
        if (status == ReachableViaWiFi) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:body.fileURL]];
        } else if(status == ReachableViaWWAN){
            YXAlertView *showAlertView = [YXAlertView alertViewWithTitle:@"当前网络非WIFi环境,是否继续更新"];
            [showAlertView addButtonWithTitle:@"否"];
            [showAlertView addButtonWithTitle:@"继续" action:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:body.fileURL]];
            }];
            [showAlertView show];
        }
        [self.upgradeView hide];
    };
    YXAppUpdatePopUpView *popView = [[YXAppUpdatePopUpView alloc] init];
    [popView setupConstrainsInContainerView:self.upgradeView];
    [popView updateWithData:data actions:@[downloadUpdateAlertAct,cancelAlertAct]];
    [self.upgradeView showInView:nil];
}

//多项目切换界面
- (void)showMultiProjectCutover{
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIView *guideView = [[NSClassFromString(@"ChangeProjectGuideView") alloc] init];
    [window addSubview:guideView];
    [guideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainFirstLaunch];
}

//多角色切换界面
- (void)showMultiRoleCutover{
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIView *roleView = [[NSClassFromString(@"ChangeProjectRoleView") alloc] init];
    [window addSubview:roleView];
    [roleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainFirstRoleChange];
}

//二维码扫描界面
- (void)showQRCodePrompt{
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIView *roleView = [[NSClassFromString(@"QRCodeFloatingView") alloc] init];
    [window addSubview:roleView];
    [roleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainQRCodePrompt];
}

#pragma mark - judgment
- (BOOL)isShowMoreThanOneProject {
    return ([YXTrainManager sharedInstance].trainlistItem.body.trains.count > 1) &&
    ![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainFirstLaunch] &&
    [YXTrainManager sharedInstance].currentProject.w.integerValue >= 3;
}
- (BOOL)isShowRoleChange {
    return [YXTrainManager sharedInstance].currentProject.isDoubel.boolValue &&
    ![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainFirstRoleChange] &&
    ([YXTrainManager sharedInstance].currentProject.role.integerValue == 99) &&
    [YXTrainManager sharedInstance].currentProject.w.integerValue >= 3;
}
- (BOOL)isQRCodePrompt {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainQRCodePrompt];
}
@end

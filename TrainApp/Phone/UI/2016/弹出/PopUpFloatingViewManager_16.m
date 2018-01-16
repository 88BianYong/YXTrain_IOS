//
//  PopUpFloatingViewManager_16.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PopUpFloatingViewManager_16.h"
#import "YXInitRequest.h"
#import "YXPopUpContainerView.h"
#import "YXAppUpdatePopUpView.h"
#import "YXAlertView.h"
#import "AppDelegate.h"
#import "YXCMSCustomView.h"
#import "YXWebViewController.h"
#import "FloatingBaseView.h"
#import "YXRotateListRequest.h"
#import "YXDrawerViewController.h"
#import "YXNavigationController.h"
@interface PopUpFloatingViewManager_16 ()
@property (nonatomic, strong) YXCMSCustomView *cmsView;
@property (nonatomic, strong) YXPopUpContainerView *upgradeView;

@property (nonatomic, strong) YXRotateListRequest *rotateListRequest;

@property (nonatomic, assign) BOOL isCard;//贺卡
@property (nonatomic, assign) BOOL isMultiProject;//多项目
@property (nonatomic, assign) BOOL isMultiRole;//多角色
@property (nonatomic, assign) BOOL isQRCode;//二维码扫描
@property (nonatomic, assign) BOOL isEndTime;//项目结束时间

@end
@implementation PopUpFloatingViewManager_16
- (instancetype)init {
    if (self = [super init]) {
        self.isShowCMS = YES;
        self.loginStatus = PopUpFloatingLoginStatus_Already;
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kYXTrainShowUpdate object:nil] subscribeNext:^(id x) {
            STRONG_SELF
            if ([LSTSharedInstance sharedInstance].trainManager.trainStatus != LSTTrainProjectStatus_2016) {
                return;
            }
            self.isShowCMS = NO;
            if ([LSTSharedInstance sharedInstance].upgradeManger.isShowUpgrade && self.upgradeView == nil) {
                [self startPopUpFloatingView];
                BLOCK_EXEC(self.popUpFloatingViewManagerCompleteBlock,NO);
            }else {
                BLOCK_EXEC(self.popUpFloatingViewManagerCompleteBlock,YES);
            }
        }];
    }
    return self;
}

- (void)startPopUpFloatingView {
    if (self.loginStatus == PopUpFloatingLoginStatus_QRCode) {
        return;
    }
    if (self.isShowCMS && self.loginStatus == PopUpFloatingLoginStatus_Already) {
        [self showCMSView];
    }else if ([LSTSharedInstance sharedInstance].upgradeManger.isShowUpgrade) {
        [self showUpgradeView];
    }else if ([self isGreetingCard] || self.isCard) {
        [self showNewYearsGreetingCard];
    }else if ([self isShowMoreThanOneProject] || self.isMultiProject) {
        [self showMultiProjectCutover];
    }else if ([self isShowRoleChange] || self.isMultiRole) {
        [self showMultiRoleCutover];
    }else if ([self isQRCodePrompt] || self.isQRCode) {
        [self showQRCodePrompt];
    }else if ([self isProjectEndTime] || self.isEndTime) {
        [self showProjectEndTime];
    }
}
- (void)showPopUpFloatingView {
    [self popUpFloatingViewStatus:YES];
}
- (void)hiddenPopUpFloatingView {
    [self popUpFloatingViewStatus:NO];
}
- (void)popUpFloatingViewStatus:(BOOL)isShow {
    if (self.isMultiProject || self.isMultiRole || self.isQRCode) {
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[FloatingBaseView class]]) {
                obj.hidden = !isShow;
            }
        }];
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
    YXRotateListRequest *request = [[YXRotateListRequest alloc] init];
    [request startRequestWithRetClass:[YXRotateListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        YXRotateListRequestItem *item = retItem;
        STRONG_SELF
        if (error || item.rotates.count <= 0) {
            self.isShowCMS = NO;
            [self.cmsView removeFromSuperview];
            if ([LSTSharedInstance sharedInstance].upgradeManger.isShowUpgrade && self.upgradeView == nil) {
                [self showUpgradeView];
                BLOCK_EXEC(self.popUpFloatingViewManagerCompleteBlock,NO);
            }else {
                BLOCK_EXEC(self.popUpFloatingViewManagerCompleteBlock,YES);
            }
        }
        else{
            YXRotateListRequestItem_Rotates *rotate = item.rotates[0];
            [self.cmsView reloadWithModel:rotate];
            WEAK_SELF
            self.cmsView.clickedBlock = ^(YXRotateListRequestItem_Rotates *model) {
                STRONG_SELF
                YXWebViewController *webView = [[YXWebViewController alloc] init];
                webView.urlString = model.typelink;
                webView.titleString = model.name;
                [webView setBackBlock:^{
                    STRONG_SELF
                    if ([LSTSharedInstance sharedInstance].upgradeManger.isShowUpgrade && self.upgradeView == nil) {
                        [self showUpgradeView];
                    }
                    self.isShowCMS = NO;
                    BLOCK_EXEC(self.popUpFloatingViewManagerCompleteBlock,NO);
                }];
               [window.rootViewController.navigationController pushViewController:webView animated:YES];
            };
        }
    }];
    self.rotateListRequest = request;
}
//升级弹窗
- (void)showUpgradeView {
    if (self.upgradeView != nil) {
        return;
    }
    YXInitRequestItem_Body *body = [LSTSharedInstance sharedInstance].upgradeManger.item.body[0];
    self.upgradeView = [[YXPopUpContainerView alloc] init];
    YXAppUpdateData *data = [[YXAppUpdateData alloc] init];
    data.title = body.title;
    data.content = body.content;
    WEAK_SELF
    YXAlertAction *cancelAlertAct = [[YXAlertAction alloc] init];
    cancelAlertAct.block = ^{
        STRONG_SELF
        [self.upgradeView hide];
        [LSTSharedInstance sharedInstance].upgradeManger.isShowUpgrade = NO;
        [self startPopUpFloatingView];
    };
    
    YXAlertAction *downloadUpdateAlertAct = [[YXAlertAction alloc] init];
    downloadUpdateAlertAct.block = ^{
        STRONG_SELF
        [LSTSharedInstance sharedInstance].upgradeManger.isShowUpgrade = NO;
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
//显示贺卡
- (void)showNewYearsGreetingCard{
    if (self.isCard) {
        return;
    }
    self.isCard = YES;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (![appDelegate.window.rootViewController isKindOfClass:[YXDrawerViewController class]]) {
        return;
    }
    YXDrawerViewController *drawerVC  = (YXDrawerViewController *)appDelegate.window.rootViewController;
    YXNavigationController *projectNavi = (YXNavigationController *)drawerVC.paneViewController;
    if ([projectNavi.viewControllers.lastObject isKindOfClass:[NSClassFromString(@"YXWebViewController") class]]){
        return ;
    }
    YXWebViewController *webView = [[YXWebViewController alloc] init];
    webView.urlString = [NSString stringWithFormat:@"%@/%@",[LSTSharedInstance sharedInstance].geTuiManger.url,[LSTSharedInstance sharedInstance].userManger.userModel.uid];    webView.titleString = [LSTSharedInstance sharedInstance].geTuiManger.title;
    webView.isUpdatTitle = YES;
    [YXDataStatisticsManger trackPage:@"元旦贺卡" withStatus:YES];
    WEAK_SELF
    [webView setBackBlock:^{
        STRONG_SELF
        [YXDataStatisticsManger trackPage:@"元旦贺卡" withStatus:NO];
        [self startPopUpFloatingView];
        self.isCard = NO;
        BLOCK_EXEC(self.popUpFloatingViewManagerCompleteBlock,NO);
    }];
    [projectNavi pushViewController:webView animated:YES];
    [LSTSharedInstance sharedInstance].geTuiManger.url = nil;
}

//多项目切换界面
- (void)showMultiProjectCutover{
    if (self.isMultiProject) {
        return;
    }
    self.isMultiProject = YES;
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    FloatingBaseView *guideView = [[NSClassFromString(@"ChangeProjectGuideView") alloc] init];
    WEAK_SELF
    [guideView setFloatingBaseRemoveCompleteBlock:^{
        STRONG_SELF;
        self.isMultiProject = NO;
        [self startPopUpFloatingView];
    }];
    [window addSubview:guideView];
    [guideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainFirstLaunch];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//多角色切换界面
- (void)showMultiRoleCutover{
    if (self.isMultiRole) {
        return;
    }
    self.isMultiRole = YES;
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    FloatingBaseView *roleView = [[NSClassFromString(@"ChangeProjectRoleView") alloc] init];
    WEAK_SELF
    [roleView setFloatingBaseRemoveCompleteBlock:^{
        STRONG_SELF;
        self.isMultiRole = NO;
        [self startPopUpFloatingView];
    }];
    [window addSubview:roleView];
    [roleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainFirstRoleChange];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//二维码扫描界面
- (void)showQRCodePrompt{
    if (self.isQRCode) {
        return;
    }
    self.isQRCode = YES;
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    FloatingBaseView*codeView = [[NSClassFromString(@"QRCodeFloatingView") alloc] init];
    WEAK_SELF
    [codeView setFloatingBaseRemoveCompleteBlock:^{
        STRONG_SELF;
        self.isQRCode = NO;
        [self startPopUpFloatingView];
    }];
    [window addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainQRCodePrompt];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//完成学习步骤
- (void)showProjectEndTime{
    if (self.isEndTime) {
        return;
    }
    self.isEndTime = YES;
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    FloatingBaseView*codeView = [[NSClassFromString(@"ProjectEndTimeFloatingView_17") alloc] init];
    WEAK_SELF
    [codeView setFloatingBaseRemoveCompleteBlock:^{
        STRONG_SELF;
        self.isEndTime = NO;
        [self startPopUpFloatingView];
    }];
    [window addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    NSString *key = [NSString stringWithFormat:@"%@%@",[LSTSharedInstance sharedInstance].trainManager.currentProject.pid,[LSTSharedInstance sharedInstance].trainManager.currentProject.w];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - judgment
- (BOOL)isShowMoreThanOneProject {
    return ([LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.trains.count > 1) &&
    ![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainFirstLaunch] &&
    [LSTSharedInstance sharedInstance].trainManager.currentProject.w.integerValue >= 3;
}
- (BOOL)isShowRoleChange {
    return [LSTSharedInstance sharedInstance].trainManager.currentProject.isDoubel.boolValue &&
    ![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainFirstRoleChange] &&
    ([LSTSharedInstance sharedInstance].trainManager.currentProject.role.integerValue == 99) &&
    [LSTSharedInstance sharedInstance].trainManager.currentProject.w.integerValue >= 3;
}
- (BOOL)isQRCodePrompt {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainQRCodePrompt] &&
    [LSTSharedInstance sharedInstance].trainManager.currentProject != nil &&
    [LSTSharedInstance sharedInstance].trainManager.trainHelper.presentProject != LSTTrainPresentProject_Beijing;
}
- (BOOL)isProjectEndTime {
    NSString *key = [NSString stringWithFormat:@"%@%@",[LSTSharedInstance sharedInstance].trainManager.currentProject.pid,[LSTSharedInstance sharedInstance].trainManager.currentProject.w];
    return ![[NSUserDefaults standardUserDefaults] boolForKey:key] && ([LSTSharedInstance sharedInstance].trainManager.currentProject.status.integerValue  == 0);
}
- (BOOL)isGreetingCard {
    return [LSTSharedInstance sharedInstance].geTuiManger.url.length > 0;
}
@end

//
//  PopUpFloatingViewManager_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/7.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PopUpFloatingViewManager_17.h"
#import "YXInitRequest.h"
#import "YXPopUpContainerView.h"
#import "YXAppUpdatePopUpView.h"
#import "YXAlertView.h"
#import "AppDelegate.h"
#import "YXCMSCustomView.h"
#import "YXWebViewController.h"
#import "FloatingBaseView.h"
#import "YXRotateListRequest.h"
#import "ExamineScoreFloatingView_17.h"
@interface PopUpFloatingViewManager_17 ()
@property (nonatomic, strong) YXCMSCustomView *cmsView;
@property (nonatomic, strong) YXPopUpContainerView *upgradeView;
@property (nonatomic, strong) YXRotateListRequest *rotateListRequest;

@property (nonatomic, assign) BOOL isCard;//贺卡
@property (nonatomic, assign) BOOL isScore;//学习成绩
@property (nonatomic, assign) BOOL isNotice;//通知简报
@property (nonatomic, assign) BOOL isStep;//流程
@property (nonatomic, assign) BOOL isEndTime;//项目结束时间
@end
@implementation PopUpFloatingViewManager_17
- (instancetype)init {
    if (self = [super init]) {
        self.isShowCMS = YES;
        self.loginStatus = PopUpFloatingLoginStatus_Already;
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kYXTrainShowUpdate object:nil] subscribeNext:^(id x) {
            STRONG_SELF
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
    }else if ([self isExamineUserScore] || self.isScore) {
        [self showExamineUserScore];
    }else if ([self isExamineNoticeBrief] || self.isNotice) {
        [self showExamineNoticeBrief];
    }else if ([self isFinishStudyStep] || self.isStep) {
        [self showFinishStudyStep];
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
    if (self.isScore || self.isNotice || self.isStep) {
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
                UITabBarController *tabBarVC = (UITabBarController *)window.rootViewController;
                [(UINavigationController *)(tabBarVC.selectedViewController) pushViewController:webView animated:YES];
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
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (![appDelegate.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        return;
    }
    UITabBarController *tabBarVC = (UITabBarController *)appDelegate.window.rootViewController;
    UINavigationController *projectNavi = (UINavigationController *)tabBarVC.selectedViewController;
    if ([projectNavi.viewControllers.lastObject isKindOfClass:[NSClassFromString(@"YXWebViewController") class]]){
        return ;
    }
    self.isCard = YES;
    YXWebViewController *webView = [[YXWebViewController alloc] init];
    webView.urlString = [NSString stringWithFormat:@"%@/%@",[LSTSharedInstance sharedInstance].geTuiManger.url,[LSTSharedInstance sharedInstance].userManger.userModel.uid];
    webView.titleString = [LSTSharedInstance sharedInstance].geTuiManger.title;
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
//查看我的成绩
- (void)showExamineUserScore{
    if (self.isScore) {
        return;
    }
    self.isScore = YES;
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    ExamineScoreFloatingView_17 *guideView = [[ExamineScoreFloatingView_17 alloc] init];
    guideView.scoreString = self.scoreString;
    WEAK_SELF
    [guideView setFloatingBaseRemoveCompleteBlock:^{
        STRONG_SELF;
        self.isScore = NO;
        [self startPopUpFloatingView];
    }];
    [window addSubview:guideView];
    [guideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainAcademicPerformance];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//查看通知简报
- (void)showExamineNoticeBrief{
    if (self.isNotice) {
        return;
    }
    self.isNotice = YES;
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    FloatingBaseView *roleView = [[NSClassFromString(@"NoticeBriefFloatingView_17") alloc] init];
    WEAK_SELF
    [roleView setFloatingBaseRemoveCompleteBlock:^{
        STRONG_SELF;
        self.isNotice = NO;
        [self startPopUpFloatingView];
    }];
    [window addSubview:roleView];
    [roleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainNoticeBriefing];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//完成学习步骤
- (void)showFinishStudyStep{
    if (self.isStep) {
        return;
    }
    self.isStep = YES;
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    FloatingBaseView*codeView = [[NSClassFromString(@"ExamineStepFloatingView_17") alloc] init];
    WEAK_SELF
    [codeView setFloatingBaseRemoveCompleteBlock:^{
        STRONG_SELF;
        self.isStep = NO;
        [self startPopUpFloatingView];
    }];
    [window addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainCompleteTrainingMethod];
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
- (BOOL)isGreetingCard {
    return [LSTSharedInstance sharedInstance].geTuiManger.url.length > 0;
}

- (BOOL)isExamineUserScore {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainAcademicPerformance] &&
    self.scoreString != nil;
}
- (BOOL)isExamineNoticeBrief {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainNoticeBriefing]&&
    self.scoreString != nil;
}
- (BOOL)isFinishStudyStep {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainCompleteTrainingMethod]&&
    self.scoreString != nil;
}
- (BOOL)isProjectEndTime {
    NSString *key = [NSString stringWithFormat:@"%@%@",[LSTSharedInstance sharedInstance].trainManager.currentProject.pid,[LSTSharedInstance sharedInstance].trainManager.currentProject.w];
    return ![[NSUserDefaults standardUserDefaults] boolForKey:key] && ([LSTSharedInstance sharedInstance].trainManager.currentProject.status.integerValue  == 0) &&
    self.scoreString != nil;
}

@end

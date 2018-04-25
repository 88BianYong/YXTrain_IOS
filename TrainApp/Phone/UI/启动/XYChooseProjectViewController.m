//
//  XYChooseProjectViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "XYChooseProjectViewController.h"
#import "YXCMSCustomView.h"
#import "YXWebViewController.h"
#import "YXTrainListViewController.h"
#import "YXNavigationController.h"
@interface XYChooseProjectViewController ()
@property (nonatomic, strong) YXCMSCustomView *cmsView;
@property (nonatomic, strong) YXRotateListRequest *rotateListRequest;
@property (nonatomic, assign) BOOL isShowCmsBool;
@property (nonatomic, assign) BOOL isTrainBool;
@end

@implementation XYChooseProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kYXTrainShowUpdate object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        self.isShowCmsBool = YES;
        if (self.isTrainBool) {
            [self showChooseTrainListView];
        }
    }];
    self.title = @"手机研修";
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self setupUI];
    if ([LSTSharedInstance sharedInstance].floatingViewManager.loginStatus == PopUpFloatingLoginStatus_Already) {
        [self showCMSView];
    }else {
        self.isShowCmsBool = YES;
    }
    [self requestForProjectList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
#pragma mark - setupUI
- (void)setupUI {
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForProjectList];
    };
    self.emptyView = [[YXEmptyView alloc]init];
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self requestForProjectList];
    };
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
            [self.cmsView removeFromSuperview];
            self.isShowCmsBool = YES;
            if (self.isTrainBool) {
                [self showChooseTrainListView];
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
                    self.isShowCmsBool = YES;
                    if (self.isTrainBool) {
                        [self showChooseTrainListView];
                    }
                }];
                [self.navigationController pushViewController:webView animated:YES];
            };
        }
    }];
    self.rotateListRequest = request;
}
- (void)naviRightAction {
    [[LSTSharedInstance  sharedInstance].webSocketManger close];
    [[LSTSharedInstance sharedInstance].userManger logout];
}
#pragma mark - request
- (void)requestForProjectList {
    [self startLoading];
    WEAK_SELF
    [[LSTSharedInstance sharedInstance].trainManager getProjectsWithCompleteBlock:^(NSArray *groups, NSError *error) {
        STRONG_SELF
        self.emptyView.imageName = @"无培训项目";
        self.emptyView.title = @"您没有已参加的培训项目";
        self.emptyView.subTitle = @"";
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            [self setupRightWithTitle:@"切换账号"];
            [self stopLoading];
            return;
        }
        self.isTrainBool = YES;
        if (self.isShowCmsBool) {
            [self showChooseTrainListView];
        }
    }];
}
- (void)showChooseTrainListView {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainChoosePid] && [LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.training.count > 1) {
        YXTrainListViewController *VC = [[YXTrainListViewController alloc] init];
        VC.isLoginChooseBool = YES;
        YXNavigationController *nav = [[YXNavigationController alloc] initWithRootViewController:VC];
        [self presentViewController:nav animated:YES completion:^{
            
        }];        
    }else {
        if ([LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.training.count > 0) {
            YXTrainListRequestItem_body_train *train = [LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.training[0];
            [[LSTSharedInstance sharedInstance].trainManager setupProjectId:train.pid];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kXYTrainChooseProject object:@([LSTSharedInstance sharedInstance].trainManager.trainStatus)];
        }
    }
}
@end

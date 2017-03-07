//
//  YXProjectMainViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXProjectMainViewController.h"
#import "YXDrawerController.h"
#import "YXProjectContainerView.h"
#import "YXTrainListRequest.h"
#import "YXProjectSelectionView.h"
#import "YXUserProfileRequest.h"
#import "YXUploadHeadImgRequest.h"
#import "YXInitRequest.h"
#import "YXPopUpContainerView.h"
#import "BeijingDynamicViewController.h"

#import "BeijingCheckedMobileUserRequest.h"
#import "BeijingCheckedMobileUserViewController.h"
#import "YXWebSocketManger.h"
#import "ChangeProjectGuideView.h"
#import "WebsocketRedRightView.h"
#import "WebsocketRedLeftView.h"
#import "YXProjectMainViewController+Master.h"
#import "YXProjectMainViewController+Student.h"
@interface YXProjectMainViewController ()
@property (nonatomic, strong) YXProjectSelectionView *projectSelectionView;
@property (nonatomic, strong) NSMutableArray *dataMutableArrray;
@property (nonatomic, strong) BeijingCheckedMobileUserRequest *checkedMobileUserRequest;
@property (nonatomic, strong) WebsocketRedLeftView *leftView;
@property (nonatomic, assign) BOOL isCheckedMobile;//是否应该进行测评接口请求;

@property (nonatomic, strong) WebsocketRedRightView *rightView;
@end

@implementation YXProjectMainViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataMutableArrray = [[NSMutableArray alloc] initWithCapacity:6];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSwitchGuideView) name:@"cancelToUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserRoleInterface) name:kYXTrainUserIdentityChange object:nil];
    [self setupUI];
    [self getProjectList];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.leftView.hidden = NO;
    [self showProjectSelectionView];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideProjectSelectionView];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI{
    self.leftView = [[WebsocketRedLeftView alloc] init];
    [self.leftView setWebsocketRedButtonActionBlock:^{
        [YXDrawerController showDrawer];
    }];
    [self setupLeftWithCustomView:self.leftView];
    
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        if (self.isCheckedMobile) {
            [self requestCheckedMobileUser];
        }else {
            [self getProjectList];
        }
    };
    self.emptyView = [[YXEmptyView alloc]init];
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        if (self.isCheckedMobile) {
            [self requestCheckedMobileUser];
        }else {
            [self getProjectList];
        }
    };
}
- (void)setupRightView {
    self.rightView = [[WebsocketRedRightView alloc] init];
    WEAK_SELF
    [self.rightView setWebsocketRedButtonActionBlock:^{
        STRONG_SELF
        self.rightView.pointView.hidden = YES;
        [[YXWebSocketManger sharedInstance] setState:YXWebSocketMangerState_Dynamic];
        BeijingDynamicViewController *VC = [[BeijingDynamicViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
    [self setupRightWithCustomView:self.rightView];
}
#pragma mark - request
- (void)requestCheckedMobileUser {
    self.isCheckedMobile = YES;
    if (self.checkedMobileUserRequest) {
        [self.checkedMobileUserRequest stopRequest];
    }
    WEAK_SELF
    [self startLoading];
    BeijingCheckedMobileUserRequest *request = [[BeijingCheckedMobileUserRequest alloc] init];
    request.pid = [YXTrainManager sharedInstance].currentProject.pid;
    [request startRequestWithRetClass:[BeijingCheckedMobileUserRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        
        BeijingCheckedMobileUserRequestItem *item = retItem;
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = item != nil;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        if (item.isUpdatePwd.integerValue == 0) {// 0 为 没有修改过密码 ，需要老师修改；1为不需要修改。
            BeijingCheckedMobileUserViewController *VC = [[BeijingCheckedMobileUserViewController alloc] init];
            self.leftView.hidden = YES;
            VC.passportString = item.passport;
            [self.navigationController pushViewController:VC animated:NO];
        }
        if (item.isTest.integerValue == 0) {// 0为需要老师做前测问卷，1为不需要做。
            self.emptyView.frame = self.view.bounds;
            self.emptyView.imageName = @"没选课";
            self.emptyView.title = @"您还未完成测评";
            self.emptyView.subTitle = @"请在电脑端登录研修网完成测评";
            [self.view addSubview:self.emptyView];
        }else {
            [self.emptyView removeFromSuperview];
            [self setupRightView];
            [self showProjectWithIndexPath:[YXTrainManager sharedInstance].currentProjectIndexPath];
        }
        [self dealWithProjectGroups:self.dataMutableArrray];
    }];
    self.checkedMobileUserRequest = request;
}

- (void)getProjectList{
    [self startLoading];
    WEAK_SELF
    [[YXTrainManager sharedInstance] getProjectsWithCompleteBlock:^(NSArray *groups, NSError *error) {
        STRONG_SELF
        [self stopLoading];
        self.emptyView.imageName = @"无培训项目";
        self.emptyView.title = @"您没有已参加的培训项目";
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = groups.count != 0;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        [self.dataMutableArrray addObjectsFromArray:groups];
        if ([YXTrainManager sharedInstance].trainHelper.isBeijingProject) {//北京项目需要校验信息
            [self requestCheckedMobileUser];
        }else {
            [self dealWithProjectGroups:self.dataMutableArrray];
            [self showProjectWithIndexPath:[YXTrainManager sharedInstance].currentProjectIndexPath];
        }
    }];
}
- (void)dealWithProjectGroups:(NSArray *)groups{
    YXProjectSelectionView *selectionView = [[YXProjectSelectionView alloc]initWithFrame:CGRectMake(70, 0, self.view.bounds.size.width-110, 44)];
    selectionView.currentIndexPath = [YXTrainManager sharedInstance].currentProjectIndexPath;
    selectionView.projectGroup = groups;
    WEAK_SELF
    selectionView.projectChangeBlock = ^(NSIndexPath *indexPath){
        STRONG_SELF
        DDLogDebug(@"project change indexPath: %@",indexPath);
        [self showProjectWithIndexPath:indexPath];
    };
    self.projectSelectionView = selectionView;
    [self showProjectSelectionView];
}
- (void)showProjectWithIndexPath:(NSIndexPath *)indexPath {
    [YXTrainManager sharedInstance].currentProject.role = nil;
    [YXTrainManager sharedInstance].currentProjectIndexPath = indexPath;
    [self refreshUserRoleInterface];
}
- (void)refreshUserRoleInterface {
    for (UIViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    for (UIView *v in self.view.subviews) {
        [v removeFromSuperview];
    }
    if ([YXTrainManager sharedInstance].currentProject.role.intValue == 9 || [YXTrainManager sharedInstance].currentProject.w.integerValue < 3) {
        [self showStudentInterface];
    }else {
        [self showMasterInterface];
    }
}
- (void)showSwitchGuideView {
    if ([self isShowMoreThanOneProject]) {
        static NSString *staticString = @"ChangeProjectGuideView";
        UIView *guideView = [[NSClassFromString(staticString) alloc] init];
        [self.navigationController.view addSubview:guideView];
        [guideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainFirstLaunch];
    }else if ([self isShowRoleChange]){
            static NSString *staticString = @"ChangeProjectRoleView";
            UIView *roleView = [[NSClassFromString(staticString) alloc] init];
            [self.navigationController.view addSubview:roleView];
            [roleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainFirstRoleChange];
        }
}
- (BOOL)isShowMoreThanOneProject {
    return ([YXTrainManager sharedInstance].trainlistItem.body.trains.count > 1) &&
    ![YXInitHelper sharedHelper].showUpgradeFlag &&
    ![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainFirstLaunch];
}
- (BOOL)isShowRoleChange {
    return ([YXTrainManager sharedInstance].currentProject.doubel.integerValue == 2) &&
    ![YXInitHelper sharedHelper].showUpgradeFlag &&
    ![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainFirstRoleChange] &&
    ([YXTrainManager sharedInstance].currentProject.role.integerValue == 99);
}
#pragma mark - peojects hide & show
- (void)showProjectSelectionView{
    if (self.navigationController.topViewController == self) {
        [self.navigationController.navigationBar addSubview:self.projectSelectionView];
    }
}

- (void)hideProjectSelectionView{
    [self.projectSelectionView removeFromSuperview];
}
@end

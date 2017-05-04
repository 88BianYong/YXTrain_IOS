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
#import "ProjectChooseLayerView.h"
#import "YXProjectMainViewController+Master.h"
#import "YXProjectMainViewController+Student.h"
#import "TrainRedPointManger.h"
#import "TrainLayerListRequest.h"
#import "TrainSelectLayerRequest.h"
typedef NS_ENUM(NSUInteger, TrainProjectRequestStatus) {
    TrainProjectRequestStatus_ProjectList,//请求项目列表
    TrainProjectRequestStatus_Beijing,//请求北京校验
    TrainProjectRequestStatus_LayerList,//请求分层
    
};

@interface YXProjectMainViewController ()
@property (nonatomic, strong) BeijingCheckedMobileUserRequest *checkedMobileUserRequest;
@property (nonatomic, strong) TrainLayerListRequest *layerListRequest;
@property (nonatomic, strong) TrainSelectLayerRequest *selectLayerRequest;

@property (nonatomic, strong) NSMutableArray *dataMutableArrray;
@property (nonatomic, strong) NSMutableDictionary *layerMutableDictionary;
@property (nonatomic, assign) TrainProjectRequestStatus requestStatus;

@property (nonatomic, strong) YXProjectSelectionView *projectSelectionView;
@property (nonatomic, strong) WebsocketRedLeftView *leftView;
@property (nonatomic, strong) WebsocketRedRightView *rightView;
@property (nonatomic, strong) ProjectChooseLayerView *chooseLayerView;

@end

@implementation YXProjectMainViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (ProjectChooseLayerView *)chooseLayerView {
    if (_chooseLayerView == nil) {
        _chooseLayerView = [[ProjectChooseLayerView alloc] init];
        WEAK_SELF
        [_chooseLayerView setProjectChooseLayerCompleteBlock:^(NSString *layerId){
            STRONG_SELF;
            [self requestForSelectLayer:layerId];
        }];
    }
    return _chooseLayerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataMutableArrray = [[NSMutableArray alloc] initWithCapacity:6];
    self.layerMutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSwitchGuideView) name:@"cancelToUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserRoleInterface) name:kYXTrainUserIdentityChange object:nil];
    [self setupUI];
    [self requestForProjectList];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.leftView.hidden = NO;
    [self showProjectSelectionView];
    [self showAlertView];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideProjectSelectionView];
    [self hideAlertView];
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
        if (self.requestStatus == TrainProjectRequestStatus_ProjectList) {
            [self requestForProjectList];
        }else if (self.requestStatus == TrainProjectRequestStatus_Beijing){
            [self requestCheckedMobileUser];
        }else {
            [self requestForLayerList];
        }
    };
    self.emptyView = [[YXEmptyView alloc]init];
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        if (self.requestStatus == TrainProjectRequestStatus_ProjectList) {
            [self requestForProjectList];
        }else if (self.requestStatus == TrainProjectRequestStatus_Beijing){
            [self requestCheckedMobileUser];
        }else {
            [self requestForLayerList];
        }
    };
}
- (void)setupRightView {
    self.rightView = [[WebsocketRedRightView alloc] init];
    WEAK_SELF
    [self.rightView setWebsocketRedButtonActionBlock:^{
        STRONG_SELF
        [TrainRedPointManger sharedInstance].dynamicInteger = -1;
        [[YXWebSocketManger sharedInstance] setState:YXWebSocketMangerState_Dynamic];
        BeijingDynamicViewController *VC = [[BeijingDynamicViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
    [self setupRightWithCustomView:self.rightView];
}

#pragma mark - request
- (void)requestForProjectList{
    self.requestStatus = TrainProjectRequestStatus_ProjectList;
    [self startLoading];
    WEAK_SELF
    [[YXTrainManager sharedInstance] getProjectsWithCompleteBlock:^(NSArray *groups, NSError *error) {
        STRONG_SELF
        self.emptyView.imageName = @"无培训项目";
        self.emptyView.title = @"您没有已参加的培训项目";
        self.emptyView.subTitle = @"";
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = groups.count != 0;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            [self stopLoading];
            return;
        }
        [self.dataMutableArrray addObjectsFromArray:groups];
        if ([YXTrainManager sharedInstance].trainHelper.presentProject == LSTTrainPresentProject_Beijing) {//北京项目需要校验信息
            [self requestCheckedMobileUser];
        }else {
            [self dealWithProjectGroups:self.dataMutableArrray];
            [self showProjectWithIndexPath:[YXTrainManager sharedInstance].currentProjectIndexPath];
        }
    }];
}

- (void)requestCheckedMobileUser {
    self.requestStatus = TrainProjectRequestStatus_Beijing;
    if (self.checkedMobileUserRequest) {
        [self.checkedMobileUserRequest stopRequest];
    }
    WEAK_SELF
    [self startLoading];
    BeijingCheckedMobileUserRequest *request = [[BeijingCheckedMobileUserRequest alloc] init];
    request.pid = [YXTrainManager sharedInstance].currentProject.pid;
    [request startRequestWithRetClass:[BeijingCheckedMobileUserRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        BeijingCheckedMobileUserRequestItem *item = retItem;
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = item != nil;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            [self stopLoading];
            return;
        }
        if (item.isUpdatePwd.integerValue == 0) {// 0 为 没有修改过密码 ，需要老师修改；1为不需要修改。
            [self stopLoading];
            BeijingCheckedMobileUserViewController *VC = [[BeijingCheckedMobileUserViewController alloc] init];
            self.leftView.hidden = YES;
            VC.passportString = item.passport;
            [self.navigationController pushViewController:VC animated:NO];
        }
        if (item.isTest.integerValue == 0) {// 0为需要老师做前测问卷，1为不需要做。
            [self stopLoading];
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

- (void)requestForLayerList {
    if (self.layerMutableDictionary[[YXTrainManager sharedInstance].currentProject.pid]) {
       [self showTrainLayerView:self.layerMutableDictionary[[YXTrainManager sharedInstance].currentProject.pid]];
    }else {
        self.requestStatus = TrainProjectRequestStatus_LayerList;
        TrainLayerListRequest *request = [[TrainLayerListRequest alloc] init];
        request.projectId = [YXTrainManager sharedInstance].currentProject.pid;
        WEAK_SELF
        [self startLoading];
        [request startRequestWithRetClass:[TrainLayerListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self stopLoading];
            TrainLayerListRequestItem *item = retItem;
            UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
            data.requestDataExist = YES;
            data.localDataExist = NO;
            data.error = error;
            if ([self handleRequestData:data]) {
                return;
            }
            if (item) {
                self.layerMutableDictionary[[YXTrainManager sharedInstance].currentProject.pid] = item;
                [self showTrainLayerView:item];
            }
        }];
        self.layerListRequest = request;
    }
}
- (void)requestForSelectLayer:(NSString *)layerId {
    [self startLoading];
    TrainSelectLayerRequest *request = [[TrainSelectLayerRequest alloc] init];
    request.projectId = [YXTrainManager sharedInstance].currentProject.pid;
    request.layerId = layerId;
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = YES;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        [YXTrainManager sharedInstance].currentProject.isOpenLayer = @"0";
        [YXTrainManager sharedInstance].currentProject.layerId = layerId;
        [[YXTrainManager sharedInstance] saveToCache];
        [self.chooseLayerView removeFromSuperview];
        [self refreshUserRoleInterface];
    }];
    self.selectLayerRequest = request;
}

#pragma mark - showView
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
    if ([YXTrainManager sharedInstance].currentProject.w.integerValue >= 3) {
        [self showSwitchGuideView];
    }
    if ([YXTrainManager sharedInstance].currentProject.isOpenLayer.boolValue) {
        [self requestForLayerList];
    }else {
        [self stopLoading];
        if ([YXTrainManager sharedInstance].currentProject.role.intValue == 9 ||
            [YXTrainManager sharedInstance].currentProject.w.integerValue < 3) {
            [self showStudentInterface];
        }else {
            [self showMasterInterface];
        }
    }
}
- (void)showTrainLayerView:(TrainLayerListRequestItem *)item {
    [self.view addSubview:self.chooseLayerView];
    [self.chooseLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.chooseLayerView.dataMutableArray = item.body;
}

- (void)showSwitchGuideView {
    
    if ([self isShowMoreThanOneProject]) {//显示项目切换提示
        UIView *guideView = [[NSClassFromString(@"ChangeProjectGuideView") alloc] init];
        [self.navigationController.view addSubview:guideView];
        [guideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainFirstLaunch];
    }else if ([self isShowRoleChange]){//显示角色切换提示
        UIView *roleView = [[NSClassFromString(@"ChangeProjectRoleView") alloc] init];
        [self.navigationController.view addSubview:roleView];
        [roleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainFirstRoleChange];
    }
}

#pragma mark - judge
- (BOOL)isShowMoreThanOneProject {
    return ([YXTrainManager sharedInstance].trainlistItem.body.trains.count > 1) &&
    ![YXInitHelper sharedHelper].showUpgradeFlag &&
    ![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainFirstLaunch];
}
- (BOOL)isShowRoleChange {
    return [YXTrainManager sharedInstance].currentProject.isDoubel.boolValue &&
    ![YXInitHelper sharedHelper].showUpgradeFlag &&
    ![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainFirstRoleChange] &&
    ([YXTrainManager sharedInstance].currentProject.role.integerValue == 99);
}
#pragma mark - peojects hide & show
- (void)dealWithProjectGroups:(NSArray *)groups{
    YXProjectSelectionView *selectionView = [[YXProjectSelectionView alloc]initWithFrame:CGRectMake(70, 0, self.view.bounds.size.width-110, 44)];
    selectionView.currentIndexPath = [YXTrainManager sharedInstance].currentProjectIndexPath;
    selectionView.projectGroup = groups;
    WEAK_SELF
    selectionView.projectChangeBlock = ^(NSIndexPath *indexPath){
        STRONG_SELF
        [self showProjectWithIndexPath:indexPath];
    };
    self.projectSelectionView = selectionView;
    [self showProjectSelectionView];
}
- (void)showProjectSelectionView {
    if (self.navigationController.topViewController == self) {
        [self.navigationController.navigationBar addSubview:self.projectSelectionView];
    }
}
- (void)hideProjectSelectionView {
    [self.projectSelectionView removeFromSuperview];
}
- (void)showAlertView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LSTAlertView class]]) {
            obj.hidden = NO;
        }
    }];
}
- (void)hideAlertView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LSTAlertView class]]) {
            obj.hidden = YES;
        }
    }];
}
@end

//
//  YXProjectMainViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXProjectMainViewController.h"
#import "YXDrawerController.h"

#import "YXTaskViewController.h"
#import "YXNoticeViewController.h"
#import "YXProjectContainerView.h"
#import "YXTrainListRequest.h"
#import "YXProjectSelectionView.h"
#import "YXCourseRecordViewController.h"
#import "YXUserProfileRequest.h"
#import "YXUploadHeadImgRequest.h"
#import "YXInitRequest.h"
#import "YXPopUpContainerView.h"
#import "BeijingDynamicViewController.h"

#import "BeijingCheckedMobileUserRequest.h"
#import "BeijingCheckedMobileUserViewController.h"
#import "YXWebSocketManger.h"
#import "ChangeProjectGuideView.h"
@interface YXProjectMainViewController ()
{
    UIViewController<YXTrackPageDataProtocol> *_selectedViewController;
}
@property (nonatomic, strong) YXProjectSelectionView *projectSelectionView;
@property (nonatomic, strong) YXCourseRecordViewController *recordVC;
@property (nonatomic, strong) UIView *redPointView;
@property (nonatomic, strong) NSMutableArray *dataMutableArrray;
@property (nonatomic, strong) BeijingCheckedMobileUserRequest *checkedMobileUserRequest;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, assign) BOOL isCheckedMobile;//是否应该进行测评接口请求;

@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *rightRedView;
@end

@implementation YXProjectMainViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataMutableArrray = [[NSMutableArray alloc] initWithCapacity:6];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webSocketReceiveMessage:) name:kYXTrainWebSocketReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showChangeProjectGuideView) name:@"cancelToUpdate" object:nil];
    [self setupUI];
    [self getProjectList];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.headView.hidden = NO;
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
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37.0f, 32.0f)];
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [b sd_setBackgroundImageWithURL:[NSURL URLWithString:[YXUserManager sharedManager].userModel.profile.head] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXUploadUserPicSuccessNotification object:nil]subscribeNext:^(id x) {
        [b sd_setBackgroundImageWithURL:[NSURL URLWithString:[YXUserManager sharedManager].userModel.profile.head] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXUserProfileGetSuccessNotification object:nil]subscribeNext:^(id x) {
        [b sd_setBackgroundImageWithURL:[NSURL URLWithString:[YXUserManager sharedManager].userModel.profile.head] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    }];
    b.backgroundColor = [UIColor redColor];
    b.layer.cornerRadius = 16;
    b.clipsToBounds = YES;
    [b addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:b];
    
    self.redPointView = [[UIView alloc] initWithFrame:CGRectMake(32.0f, 0.0f, 5.0f, 5.0f)];
    self.redPointView.backgroundColor = [UIColor colorWithHexString:@"ed5836"];
    self.redPointView.layer.cornerRadius = 2.5f;
    self.redPointView.hidden = YES;
    [self.headView addSubview:self.redPointView];
    [self setupLeftWithCustomView:self.headView];
    
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
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37.0f, 32.0f)];
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [b setImage:[UIImage imageNamed:@"消息动态icon-正常态A"] forState:UIControlStateNormal];
    [b setImage:[UIImage imageNamed:@"消息动态icon点击态-正常态-拷贝"] forState:UIControlStateHighlighted];
    [b addTarget:self action:@selector(naviRightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView addSubview:b];
    
    self.rightRedView = [[UIView alloc] initWithFrame:CGRectMake(27.0f, 5.0f, 5.0f, 5.0f)];
    self.rightRedView.backgroundColor = [UIColor colorWithHexString:@"ed5836"];
    self.rightRedView.layer.cornerRadius = 2.5f;
    self.rightRedView.hidden = YES;
    [self.rightView addSubview:self.rightRedView];
    [self setupRightWithCustomView:self.rightView];
}

- (void)naviRightAction {
    [[YXWebSocketManger sharedInstance] setState:YXWebSocketMangerState_Dynamic];
    self.rightRedView.hidden = YES;
    BeijingDynamicViewController *VC = [[BeijingDynamicViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
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
            self.headView.hidden = YES;
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
        if ([YXTrainManager sharedInstance].isBeijingProject) {
            [self requestCheckedMobileUser];
        }else {
            [self dealWithProjectGroups:self.dataMutableArrray];
            [self showProjectWithIndexPath:[YXTrainManager sharedInstance].currentProjectIndexPath];
        }
    }];
}

- (void)webSocketReceiveMessage:(NSNotification *)aNotification{
    NSInteger integer = [aNotification.object integerValue];
    if ([YXTrainManager sharedInstance].isBeijingProject) {
        if (integer == 3) {
            self.rightRedView.hidden = NO;
        }
        if (integer == 2) {
            self.redPointView.hidden = NO;
        }
        if (integer == 0) {
            self.redPointView.hidden = YES;
        }
    }else{
        if (integer == 0) {
            self.redPointView.hidden = YES;
        }else{
            self.redPointView.hidden = NO;
        }
    }
    
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
    for (UIView *v in self.view.subviews) {
        [v removeFromSuperview];
    }
    [YXTrainManager sharedInstance].currentProjectIndexPath = indexPath;
    if ([YXTrainManager sharedInstance].currentProject.w.integerValue >= 3) {
        YXProjectContainerView *containerView = [[YXProjectContainerView alloc]initWithFrame:self.view.bounds];
        WEAK_SELF
        containerView.selectedViewContrller = ^(UIViewController<YXTrackPageDataProtocol> *vc){
            STRONG_SELF
            [self ->_selectedViewController report:NO];
            self ->_selectedViewController = vc;
            [self ->_selectedViewController report:YES];
        };
        UIViewController<YXTrackPageDataProtocol> *examVC = [[YXTrainManager sharedInstance].trainHelper showExamProject];
        YXTaskViewController *taskVC = [[YXTaskViewController alloc]init];
        YXNoticeViewController *notiVC = [[YXNoticeViewController alloc]init];
        notiVC.flag = YXFlag_Notice;
        YXNoticeViewController *bulletinVC = [[YXNoticeViewController alloc]init];
        bulletinVC.flag = YXFlag_Bulletin;
        containerView.viewControllers = @[examVC,taskVC,notiVC,bulletinVC];
        _selectedViewController = examVC;
        containerView.tag = 10001;
        [self.view addSubview:containerView];
        [self addChildViewController:examVC];
        [self addChildViewController:taskVC];
        [self addChildViewController:notiVC];
        [self addChildViewController:bulletinVC];
        
        BOOL isSingleProject = [YXTrainManager sharedInstance].trainlistItem.body.training.count == 1 ? YES :NO;
        if (![YXInitHelper sharedHelper].showUpgradeFlag && !isSingleProject) {
            [self showChangeProjectGuideView];
        }
    }else{
        YXCourseRecordViewController *recordVc = [[YXCourseRecordViewController alloc]init];
        self.recordVC = recordVc;
        self.recordVC.view.frame = self.view.bounds;
        [self.view addSubview:self.recordVC.view];
        [self addChildViewController:recordVc];
    }
}
- (void)btnAction{
    [YXDrawerController showDrawer];
}

- (void)showChangeProjectGuideView {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainFirstLaunch]) {
        static NSString *staticString = @"ChangeProjectGuideView";
        UIView *guideView = [[NSClassFromString(staticString) alloc] init];
        [self.navigationController.view addSubview:guideView];
        [guideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainFirstLaunch];
    }
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

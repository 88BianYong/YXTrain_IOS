//
//  YXProjectMainViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXProjectMainViewController.h"
#import "YXDrawerController.h"
#import "YXExamViewController.h"
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
#import "DataErrorView.h"
@interface YXProjectMainViewController ()
{
    UIViewController<YXTrackPageDataProtocol> *_selectedViewController;
}
@property (nonatomic, strong) YXProjectSelectionView *projectSelectionView;
@property (nonatomic, strong) YXCourseRecordViewController *recordVC;
@property (nonatomic, strong) UIView *redPointView;
@end

@implementation YXProjectMainViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webSocketReceiveMessage:) name:kYXTrainWebSocketReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showoUpdateInterface:) name:kYXTrainShowUpdate object:nil];
    [self setupUI];
    
    [self getProjectList];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showProjectSelectionView];
    //    [_selectedViewController viewWillAppear:animated];
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
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37.0f, 32.0f)];
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
    [headView addSubview:b];
    
    self.redPointView = [[UIView alloc] initWithFrame:CGRectMake(32.0f, 0.0f, 5.0f, 5.0f)];
    self.redPointView.backgroundColor = [UIColor colorWithHexString:@"ed5836"];
    self.redPointView.layer.cornerRadius = 2.5f;
    self.redPointView.hidden = YES;
    [headView addSubview:self.redPointView];
    [self setupLeftWithCustomView:headView];
    
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self getProjectList];
    };
    self.emptyView = [[YXEmptyView alloc]initWithFrame:self.view.bounds];
    self.dataErrorView = [[DataErrorView alloc]initWithFrame:self.view.bounds];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self getProjectList];
    };
}



- (void)getProjectList{
    [self startLoading];
    WEAK_SELF
    [[YXTrainManager sharedInstance] getProjectsWithCompleteBlock:^(NSArray *projects, NSError *error) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            if (error.code == -2) {
                self.dataErrorView.frame = self.view.bounds;
                [self.view addSubview:self.dataErrorView];
            }
            else{
                self.errorView.frame = self.view.bounds;
                [self.view addSubview:self.errorView];
            }
            return;
        }
        if (projects.count == 0) {
            self.emptyView.frame = self.view.bounds;
            self.emptyView.imageName = @"无培训项目";
            self.emptyView.title = @"您没有已参加的培训项目";
            [self.view addSubview:self.emptyView];
            return;
        }
        [self.errorView removeFromSuperview];
        [self.emptyView removeFromSuperview];
        [self.dataErrorView removeFromSuperview];
        [self dealWithProjects:projects];
    }];
}
- (void)webSocketReceiveMessage:(NSNotification *)aNotification{
    NSInteger integer = [aNotification.object integerValue];
    if (integer == 0) {
        self.redPointView.hidden = YES;
    }else{
        self.redPointView.hidden = NO;
    }
}

- (void)showoUpdateInterface:(NSNotification *)aNotification{
    [[YXInitHelper sharedHelper] showNoRestraintUpgrade];
}
- (void)dealWithProjects:(NSArray *)projects{
    YXProjectSelectionView *selectionView = [[YXProjectSelectionView alloc]initWithFrame:CGRectMake(70, 0, self.view.bounds.size.width-110, 44)];
    selectionView.currentIndex = [YXTrainManager sharedInstance].currentProjectIndex;
    selectionView.projectArray = projects;
    WEAK_SELF
    selectionView.projectChangeBlock = ^(NSInteger index){
        STRONG_SELF
        DDLogDebug(@"project change index: %@",@(index));
        [self showProjectWithIndex:index];
    };
    self.projectSelectionView = selectionView;
    [self showProjectSelectionView];
    
    [self showProjectWithIndex:[YXTrainManager sharedInstance].currentProjectIndex];
}

- (void)showProjectWithIndex:(NSInteger)index{
    for (UIView *v in self.view.subviews) {
        [v removeFromSuperview];
    }
    [YXTrainManager sharedInstance].currentProjectIndex = index;
    if ([YXTrainManager sharedInstance].currentProject.w.integerValue >= 3) {
        YXProjectContainerView *containerView = [[YXProjectContainerView alloc]initWithFrame:self.view.bounds];
        WEAK_SELF
        containerView.selectedViewContrller = ^(UIViewController<YXTrackPageDataProtocol> *vc){
            STRONG_SELF
            [self ->_selectedViewController report:NO];
            self ->_selectedViewController = vc;
            [self ->_selectedViewController report:YES];
            if ([vc isKindOfClass:[YXExamViewController class]]){
                [(YXExamViewController *)vc startAnimation];
            }
        };
        YXExamViewController *examVC = [[YXExamViewController alloc]init];
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

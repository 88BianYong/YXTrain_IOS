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

@interface YXProjectMainViewController ()
{
    UIViewController *_selectedViewController;
}
@property (nonatomic, strong) YXProjectSelectionView *projectSelectionView;
@property (nonatomic, strong) YXCourseRecordViewController *recordVC;

@property (nonatomic, strong) YXErrorView *errorView;
@property (nonatomic, strong) YXEmptyView *emptyView;
@property (nonatomic, strong) UIView *redPointView;
@end

@implementation YXProjectMainViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[YXInitHelper sharedHelper] showNoRestraintUpgrade];
    [self setupUI];

    [self getProjectList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showProjectSelectionView];
    [_selectedViewController viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_selectedViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideProjectSelectionView];
    [_selectedViewController viewWillDisappear:animated];
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
    [headView addSubview:self.redPointView];
    [self setupLeftWithCustomView:headView];
    
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self getProjectList];
    };
    self.emptyView = [[YXEmptyView alloc]initWithFrame:self.view.bounds];
    
}



- (void)getProjectList{
    [self startLoading];
    WEAK_SELF
    [[YXTrainManager sharedInstance] getProjectsWithCompleteBlock:^(NSArray *projects, NSError *error) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            if (error.code == -2) {
                self.emptyView.frame = self.view.bounds;
                self.emptyView.imageName = @"数据错误";
                self.emptyView.title = @"数据错误";
                [self.view addSubview:self.emptyView];
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
        [self dealWithProjects:projects];
    }];
}

- (void)dealWithProjects:(NSArray *)projects{
    NSMutableArray *pArray = [NSMutableArray array];
    for (YXTrainListRequestItem_body_train *p in projects) {
        [pArray addObject:p.name];
    }
    YXProjectSelectionView *selectionView = [[YXProjectSelectionView alloc]initWithFrame:CGRectMake(70, 0, self.view.bounds.size.width-110, 44)];
    selectionView.currentIndex = [YXTrainManager sharedInstance].currentProjectIndex;
    selectionView.projectArray = pArray;
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
        containerView.selectedViewContrller = ^(UIViewController *vc){
            STRONG_SELF
            self ->_selectedViewController = vc;
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
        [self.view addSubview:containerView];
    }else{
        self.recordVC = [[YXCourseRecordViewController alloc]init];
        self.recordVC.view.frame = self.view.bounds;
        [self.view addSubview:self.recordVC.view];
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

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

@interface YXProjectMainViewController ()
@property (nonatomic, strong) YXProjectSelectionView *projectSelectionView;
@property (nonatomic, strong) YXCourseRecordViewController *recordVC;

@property (nonatomic, strong) YXErrorView *errorView;
@property (nonatomic, strong) YXEmptyView *emptyView;
@end

@implementation YXProjectMainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    b.backgroundColor = [UIColor redColor];
    [b addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self setupLeftWithCustomView:b];
    
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self getProjectList];
    };
    self.emptyView = [[YXEmptyView alloc]initWithFrame:self.view.bounds];
    
    [self getProjectList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showProjectSelectionView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideProjectSelectionView];
}

- (void)getProjectList{
    [self startLoading];
    WEAK_SELF
    [[YXTrainManager sharedInstance]getProjectsWithCompleteBlock:^(NSArray *projects, NSError *error) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            self.errorView.frame = self.view.bounds;
            [self.view addSubview:self.errorView];
            return;
        }
        if (projects.count == 0) {
            self.emptyView.frame = self.view.bounds;
            [self.view addSubview:self.emptyView];
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
        NSLog(@"project change index: %@",@(index));
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
    if ([[YXTrainManager sharedInstance].currentProject.w isEqualToString:@"3"]) {
        YXProjectContainerView *containerView = [[YXProjectContainerView alloc]initWithFrame:self.view.bounds];
        YXExamViewController *examVC = [[YXExamViewController alloc]init];
        YXTaskViewController *taskVC = [[YXTaskViewController alloc]init];
        YXNoticeViewController *notiVC = [[YXNoticeViewController alloc]init];
        notiVC.flag = YXFlag_Notice;
        YXNoticeViewController *bulletinVC = [[YXNoticeViewController alloc]init];
        bulletinVC.flag = YXFlag_Bulletin;
        containerView.viewControllers = @[examVC,taskVC,notiVC,bulletinVC];
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

//
//  XYLearningViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXLearningViewManagerController_17.h"
#import "ProjectChooseLayerView.h"
#import "TrainSelectLayerRequest.h"
#import "YXProjectSelectionView.h"
#import "YXCourseDetailPlayerViewController_17.h"
#import "AppDelegate.h"

@interface YXLearningViewManagerController_17 ()
@property (nonatomic, strong) UIView *qrCodeView;
@property (nonatomic, strong) ProjectChooseLayerView *chooseLayerView;
@property (nonatomic, strong) YXProjectSelectionView *projectSelectionView;

@property (nonatomic, strong) TrainLayerListRequest *layerListRequest;
@property (nonatomic, strong) TrainSelectLayerRequest *selectLayerRequest;
@property (nonatomic, strong) NSMutableDictionary *layerMutableDictionary;


@end

@implementation YXLearningViewManagerController_17
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.layerMutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
    [self setupUI];
    [self showProjectMainView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showProjectSelectionView];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideProjectSelectionView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - set
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

#pragma mark - setupUI
- (void)setupUI {
    self.navigationItem.title = @"";
    WEAK_SELF
    self.errorView = [[YXErrorView alloc] init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForLayerList];
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForLayerList];
    };
    
    self.emptyView = [[YXEmptyView alloc] init];
}

- (void)showProjectMainView{
    NSArray *groups = [TrainListProjectGroup projectGroupsWithRawData:[LSTSharedInstance sharedInstance].trainManager.trainlistItem.body];
    self.emptyView.imageName = @"无培训项目";
    self.emptyView.title = @"您没有已参加的培训项目";
    self.emptyView.subTitle = @"";
    UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
    data.requestDataExist = groups.count != 0;
    data.localDataExist = NO;
    data.error = nil;
    if ([self handleRequestData:data]) {
        [self stopLoading];
        return;
    }
    [self dealWithProjectGroups:groups];
    [self setupQRCodeRightView];
    [self refreshUserRoleInterface];
}
#pragma mark - peojects hide & show
- (void)dealWithProjectGroups:(NSArray *)groups{
    self.projectSelectionView = [[YXProjectSelectionView alloc]initWithFrame:CGRectMake(70, 0, self.view.bounds.size.width-110, 44)];
    self.projectSelectionView.currentIndexPath = [LSTSharedInstance sharedInstance].trainManager.currentProjectIndexPath;
   self.projectSelectionView.projectGroup = groups;
    WEAK_SELF
    self.projectSelectionView.projectChangeBlock = ^(NSIndexPath *indexPath){
        STRONG_SELF
        [self showProjectWithIndexPath:indexPath];
        [YXDataStatisticsManger trackEvent:@"切换项目" label:@"首页" parameters:nil];
    };
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
#pragma mark - showView
- (void)showProjectWithIndexPath:(NSIndexPath *)indexPath {
    [LSTSharedInstance sharedInstance].trainManager.currentProjectIndexPath = indexPath;
    [self refreshUserRoleInterface];
}
- (void)refreshUserRoleInterface {
    for (UIViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    for (UIView *v in self.view.subviews) {
        [v removeFromSuperview];
    }
    [[LSTSharedInstance sharedInstance].floatingViewManager startPopUpFloatingView];
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.isOpenLayer.boolValue) {
        [self requestForLayerList];
        self.qrCodeView.hidden = YES;
    }else {
        if ([LSTSharedInstance sharedInstance].trainManager.currentProject.special.intValue == 1) {
            UIViewController *deYangVC = [[NSClassFromString(@"YXLearningViewController_DeYang17") alloc] init];
            [self addChildViewController:deYangVC];
            [self.view addSubview:deYangVC.view];
            [deYangVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }else {
            UIViewController *defaultVC = [[NSClassFromString(@"YXLearningViewController_Default17") alloc] init];
            [self addChildViewController:defaultVC];
            [self.view addSubview:defaultVC.view];
            [defaultVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
        self.qrCodeView.hidden = NO;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (!isEmpty(appDelegate.appDelegateHelper.courseId)) {
            YXCourseDetailPlayerViewController_17 *vc = [[YXCourseDetailPlayerViewController_17 alloc] init];
            YXCourseListRequestItem_body_module_course *course = [[YXCourseListRequestItem_body_module_course alloc] init];
            course.courses_id = appDelegate.appDelegateHelper.courseId;
            course.courseType = appDelegate.appDelegateHelper.courseType;
            vc.course = course;
            vc.seekInteger = [appDelegate.appDelegateHelper.seg integerValue];
            vc.fromWhere = VideoCourseFromWhere_QRCode;
            [self.navigationController pushViewController:vc animated:YES];
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
- (void)setupQRCodeRightView{
    self.qrCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"扫二维码右"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"扫二维码右"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(20, 0, 44.0f, 44.0f);
    WEAK_SELF
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        UIViewController *VC = [[NSClassFromString(@"VideoCourseQRViewController") alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
    [self.qrCodeView addSubview:button];
    [self setupRightWithCustomView:self.qrCodeView];
}

#pragma mark - request
- (void)requestForLayerList {
    if (self.layerMutableDictionary[[LSTSharedInstance sharedInstance].trainManager.currentProject.pid]) {
        [self stopLoading];
        [self showTrainLayerView:self.layerMutableDictionary[[LSTSharedInstance sharedInstance].trainManager.currentProject.pid]];
    }else {
        TrainLayerListRequest *request = [[TrainLayerListRequest alloc] init];
        request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
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
                self.layerMutableDictionary[[LSTSharedInstance sharedInstance].trainManager.currentProject.pid] = item;
                [self showTrainLayerView:item];
            }
        }];
        self.layerListRequest = request;
    }
}
- (void)requestForSelectLayer:(NSString *)layerId {
    [self startLoading];
    TrainSelectLayerRequest *request = [[TrainSelectLayerRequest alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
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
        [LSTSharedInstance sharedInstance].trainManager.currentProject.isOpenLayer = @"0";
        [LSTSharedInstance sharedInstance].trainManager.currentProject.layerId = layerId;
        [[LSTSharedInstance sharedInstance].trainManager saveToCache];
        [self.chooseLayerView removeFromSuperview];
        [self refreshUserRoleInterface];
    }];
    self.selectLayerRequest = request;
}
@end

//
//  XYLearningViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXLearningViewController_17.h"
#import "ExamineDetailRequest_17.h"
#import "MJRefresh.h"
#import "ProjectChooseLayerView.h"
#import "TrainSelectLayerRequest.h"
#import "YXProjectSelectionView.h"
#import "YXLearningTableHeaderView_17.h"
#import "YXLearningStageHeaderView_17.h"
#import "YXLearningStageCell_17.h"
#import "YXLearningChannelHeaderView_17.h"
#import "CourseListMangerViewController_17.h"
typedef NS_ENUM(NSUInteger, YXLearningRequestStatus) {
    YXLearningRequestStatus_ExamineDetail,//请求个人工作室信息
    YXLearningRequestStatus_LayerList,//请求分层
};
@interface YXLearningViewController_17 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) UIView *qrCodeView;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) ProjectChooseLayerView *chooseLayerView;
@property (nonatomic, strong) YXProjectSelectionView *projectSelectionView;
@property (nonatomic, strong) YXLearningTableHeaderView_17 *headerView;



@property (nonatomic, strong) ExamineDetailRequest_17 *examineDetailRequest;
@property (nonatomic, strong) ExamineDetailRequest_17Item *examineDetailItem;
@property (nonatomic, strong) TrainLayerListRequest *layerListRequest;
@property (nonatomic, strong) TrainSelectLayerRequest *selectLayerRequest;

@property (nonatomic, strong) NSMutableDictionary *layerMutableDictionary;
@property (nonatomic, assign) YXLearningRequestStatus requestStatus;


@end

@implementation YXLearningViewController_17
- (void)dealloc{
    [self.header free];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self startLoading];
     NSArray *groups = [TrainListProjectGroup projectGroupsWithRawData:[LSTSharedInstance sharedInstance].trainManager.trainlistItem.body];
    [self dealWithProjectGroups:groups];
    self.layerMutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.isOpenLayer.boolValue) {
        [self requestForLayerList];
    }else {
        [self requestForExamineDetail];
    }
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
- (void)setExamineDetailItem:(ExamineDetailRequest_17Item *)examineDetailItem {
    _examineDetailItem = examineDetailItem;
    self.headerView.scoreString = _examineDetailItem.examine.userGetScore;
    self.headerView.hidden = NO;
    [self.tableView reloadData];
}

#pragma mark - setupUI
- (void)setupUI {
    self.navigationItem.title = @"";
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[YXLearningStageHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"YXLearningStageHeaderView_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self.tableView registerClass:[YXLearningStageCell_17 class] forCellReuseIdentifier:@"YXLearningStageCell_17"];
    [self.tableView registerClass:[YXLearningChannelHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"YXLearningChannelHeaderView_17"];
    self.headerView = [[YXLearningTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 155.0f)];
    self.headerView.hidden = YES;
    WEAK_SELF
    self.headerView.learningMyScoreCompleteBlock = ^(BOOL isScoreBool) {
        STRONG_SELF
        if (isScoreBool) {
            UIViewController *VC = [[NSClassFromString(@"YXMyLearningScoreViewController") alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }else {
            
            
        }
    };
    self.tableView.tableHeaderView = self.headerView;
    self.errorView = [[YXErrorView alloc] init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        if (self.requestStatus == YXLearningRequestStatus_LayerList) {
            [self requestForLayerList];
        }else {
            [self requestForExamineDetail];
        }
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        if (self.requestStatus == YXLearningRequestStatus_LayerList) {
            [self requestForLayerList];
        }else {
            [self requestForExamineDetail];
        }
    };
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self requestForExamineDetail];
    };
    [self setupQRCodeLeftView];
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
    [LSTSharedInstance sharedInstance].trainManager.currentProject.role = nil;
    [LSTSharedInstance sharedInstance].trainManager.currentProjectIndexPath = indexPath;
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.isOpenLayer.boolValue) {
        [self requestForLayerList];
    }else {
        [self requestForExamineDetail];
    }
}
- (void)showTrainLayerView:(TrainLayerListRequestItem *)item {
    [self.view addSubview:self.chooseLayerView];
    [self.chooseLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.chooseLayerView.dataMutableArray = item.body;
}
- (void)setupQRCodeLeftView{
    self.qrCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"扫二维码"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"扫二维码"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(-10, 0, 44.0f, 44.0f);
    WEAK_SELF
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        UIViewController *VC = [[NSClassFromString(@"VideoCourseQRViewController") alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
    [self.qrCodeView addSubview:button];
    [self setupLeftWithCustomView:self.qrCodeView];
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section >= self.examineDetailItem.stages.count) {
        YXLearningChannelHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXLearningChannelHeaderView_17"];
        headerView.mockOther = self.examineDetailItem.mockOthers[section - self.examineDetailItem.stages.count];
        WEAK_SELF
        headerView.learningChannelButtonCompleteBlock = ^(ExamineDetailRequest_17Item_MockOther *mockOther) {
            STRONG_SELF
            DDLogDebug(@">>>>>>>>>>>%@",mockOther.otherName);
        };
        return headerView;
        
    }else {
        YXLearningStageHeaderView_17 *heaerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXLearningStageHeaderView_17"];
        heaerView.stage = self.examineDetailItem.stages[section];
        WEAK_SELF
        heaerView.learningStageHeaderViewBlock = ^() {
            STRONG_SELF
            ExamineDetailRequest_17Item_Stages *stage = self.examineDetailItem.stages[section];
            stage.isMockFold = stage.isMockFold.boolValue ? @"0" : @"1";
            [tableView beginUpdates];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            [tableView endUpdates];
        };
        return heaerView;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section >= self.examineDetailItem.stages.count ? 45.0f : 80.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExamineDetailRequest_17Item_Stages *stages = self.examineDetailItem.stages[indexPath.section];
    return ceil((double)stages.tools.count/4.0f) * 80.0f;;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.examineDetailItem.stages.count + self.examineDetailItem.mockOthers.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section >= self.examineDetailItem.stages.count) {
        return 0;
    }else {
        ExamineDetailRequest_17Item_Stages *stage = self.examineDetailItem.stages[section];
        if (!stage.status.boolValue || !stage.isMockFold.boolValue) {
            return 0;
        }else {
            return 1;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXLearningStageCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"YXLearningStageCell_17" forIndexPath:indexPath];
    ExamineDetailRequest_17Item_Stages *stages = self.examineDetailItem.stages[indexPath.section];
    cell.tools = stages.tools;
    WEAK_SELF
    cell.learningStageToolCompleteBlock = ^(ExamineDetailRequest_17Item_Stages_Tools *tool) {
        STRONG_SELF
        CourseListMangerViewController_17 *VC = [[CourseListMangerViewController_17 alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    };
    return cell;
}
#pragma mark - request
- (void)requestForExamineDetail {
    self.requestStatus = YXLearningRequestStatus_ExamineDetail;
    ExamineDetailRequest_17 *request = [[ExamineDetailRequest_17 alloc] init];
    request.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.role = [LSTSharedInstance sharedInstance].trainManager.currentProject.role;
    WEAK_SELF
    [request startRequestWithRetClass:[ExamineDetailRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        [self.header endRefreshing];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        self.examineDetailItem = retItem;
        
    }];
    self.examineDetailRequest = request;
}
- (void)requestForLayerList {
    if (self.layerMutableDictionary[[LSTSharedInstance sharedInstance].trainManager.currentProject.pid]) {
        [self showTrainLayerView:self.layerMutableDictionary[[LSTSharedInstance sharedInstance].trainManager.currentProject.pid]];
    }else {
        self.requestStatus = YXLearningRequestStatus_LayerList;
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
        [self requestForExamineDetail];
    }];
    self.selectLayerRequest = request;
}

@end

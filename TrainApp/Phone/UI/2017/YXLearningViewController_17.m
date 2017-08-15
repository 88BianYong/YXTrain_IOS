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
#import "ReadingListViewController_17.h"
#import "ActivityListViewController_17.h"
#import "HomeworkListViewController_17.h"
#import "YXMyLearningScoreViewController_17.h"
#import "CourseCenterManagerViewController_17.h"
#import "ExamineToolStatusRequest_17.h"
#import "PopUpFloatingViewManager_17.h"
#import "VideoCourseDetailViewController_17.h"
#import "AppDelegate.h"
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
@property (nonatomic, strong) ExamineToolStatusRequest_17 *toolStatusRequest;

@property (nonatomic, strong) NSMutableDictionary *layerMutableDictionary;
@property (nonatomic, assign) YXLearningRequestStatus requestStatus;


@end

@implementation YXLearningViewController_17
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
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
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!isEmpty(appDelegate.appDelegateHelper.courseId)) {
        VideoCourseDetailViewController_17 *vc = [[VideoCourseDetailViewController_17 alloc]init];
        YXCourseListRequestItem_body_module_course *course = [[YXCourseListRequestItem_body_module_course alloc] init];
        course.courses_id = appDelegate.appDelegateHelper.courseId;
        course.courseType = appDelegate.appDelegateHelper.courseType;
        vc.course = course;
        vc.seekInteger = [appDelegate.appDelegateHelper.seg integerValue];
        vc.fromWhere = VideoCourseFromWhere_QRCode;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showProjectSelectionView];
    if (self.requestStatus == YXLearningRequestStatus_ExamineDetail) {
        [self requestForExamineToolStatus];
    }
    [[LSTSharedInstance sharedInstance].floatingViewManager showPopUpFloatingView];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideProjectSelectionView];
    [[LSTSharedInstance sharedInstance].floatingViewManager hiddenPopUpFloatingView];
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
    if (self.qrCodeView == nil) {
        [self setupQRCodeLeftView];
    }
    self.headerView.scoreString = _examineDetailItem.examine.userGetScore;
    self.headerView.hidden = NO;
    [self.tableView reloadData];
    PopUpFloatingViewManager_17 *floatingView = (PopUpFloatingViewManager_17 *)[LSTSharedInstance sharedInstance].floatingViewManager;
    floatingView.scoreString = _examineDetailItem.examine.userGetScore;
    [[LSTSharedInstance sharedInstance].floatingViewManager startPopUpFloatingView];
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
            YXMyLearningScoreViewController_17 *VC = [[YXMyLearningScoreViewController_17 alloc] init];
            VC.examine = self.examineDetailItem.examine;
            [self.navigationController pushViewController:VC animated:YES];
        }else {
            UIViewController *VC = [[NSClassFromString(@"NoticeBriefMangerViewController_17") alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
    };
    self.tableView.tableHeaderView = self.headerView;
    self.errorView = [[YXErrorView alloc] init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        if (self.requestStatus == YXLearningRequestStatus_LayerList) {
            [self requestForLayerList];
        }else {
            [self requestForExamineDetail];
        }
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
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
        self.qrCodeView.hidden = YES;
    }else {
        [self requestForExamineDetail];
        self.qrCodeView.hidden = NO;

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
            if (mockOther.otherType.integerValue == 1) {
                CourseCenterManagerViewController_17 *VC = [[CourseCenterManagerViewController_17 alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }else  {
                [self showToast:@"相关功能暂未开放"];
            }
        };
        return headerView;
        
    }else {
        YXLearningStageHeaderView_17 *heaerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXLearningStageHeaderView_17"];
        heaerView.stage = self.examineDetailItem.stages[section];
        WEAK_SELF
        heaerView.learningStageHeaderViewBlock = ^(BOOL isFinish) {
            STRONG_SELF
            if (!isFinish) {
                ExamineDetailRequest_17Item_Stages *stage = self.examineDetailItem.stages[section];
                if ([self compareDateDate:stage.startTime]) {
                    [self showToast:@"阶段尚未开始"];
                }else {
                    [self showToast:@"请先完成上一个阶段全部任务"];
                }
                return;
            }
            ExamineDetailRequest_17Item_Stages *stage = self.examineDetailItem.stages[section];
            stage.isMockFold = stage.isMockFold.boolValue ? @"0" : @"1";
            [tableView beginUpdates];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            [tableView endUpdates];
            
        };
        return heaerView;
    }
}
- (BOOL)compareDateDate:(NSString*)dateString {
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateformater dateFromString:dateString];
    NSComparisonResult result = [[NSDate date] compare:date];
    if (result == NSOrderedDescending) {
        return NO;
    }else {
        return YES;
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
    return section >= self.examineDetailItem.stages.count ? 45.0f : 70.f;
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
    cell.learningStageToolCompleteBlock = ^(ExamineDetailRequest_17Item_Stages_Tools *tool, NSInteger tagInteger) {
        STRONG_SELF
        if (tool.status.integerValue > 0){
            if (tool.toolID.integerValue == 201){//课程
                CourseListMangerViewController_17 *VC = [[CourseListMangerViewController_17 alloc] init];
                VC.stageString = stages.stageID;
                VC.studyString = self.examineDetailItem.user.study;
                VC.segmentString = self.examineDetailItem.user.segment;
                ExamineDetailRequest_17Item_Examine_Process *process = self.examineDetailItem.examine.process[indexPath.section];
                __block BOOL isShowChoose = NO;
                if (process.toolExamineVoList.count > tagInteger) {
                    ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList *voList = process.toolExamineVoList[tagInteger];
                    [voList.toolExamineVoList enumerateObjectsUsingBlock:^(ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.toolID.integerValue == 223) {
                            isShowChoose = YES;
                            *stop = YES;
                        }
                    }];
                }
                VC.isShowChoose = isShowChoose;
                [self.navigationController pushViewController:VC animated:YES];
            }else if (tool.toolID.integerValue == 202){//活动
                ActivityListViewController_17 *VC = [[ActivityListViewController_17 alloc] init];
                VC.stageID = stages.stageID;
                [self.navigationController pushViewController:VC animated:YES];
            }else if (tool.toolID.integerValue == 203 || tool.toolID.integerValue == 205){//作业
                HomeworkListViewController_17 *VC = [[HomeworkListViewController_17 alloc] init];
                VC.stageString = stages.stageID;
                VC.toolString = tool.toolID;
                [self.navigationController pushViewController:VC animated:YES];
            }else if (tool.toolID.integerValue == 207){//测评
                [self showToast:@"手机暂不支持测评,请到电脑端完成"];
            }else if (tool.toolID.integerValue == 222) {//阅读
                ReadingListViewController_17 *VC = [[ReadingListViewController_17 alloc] init];
                VC.stageString = stages.stageID;
                VC.toolString = tool.toolID;
                [self.navigationController pushViewController:VC animated:YES];
            }
        }else {
            [self showToast:@"请先完成上一个任务"];
        }
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
- (void)requestForExamineToolStatus {
    ExamineToolStatusRequest_17 *request = [[ExamineToolStatusRequest_17 alloc] init];
    WEAK_SELF
    [request startRequestWithRetClass:[ExamineToolStatusRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error == nil) {
            ExamineToolStatusRequest_17Item *item = retItem;
            [self.examineDetailItem.stages enumerateObjectsUsingBlock:^(ExamineDetailRequest_17Item_Stages *stage, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = item.sts[stage.stageID];
                if (dic != nil) {
                    stage.isMockFold = nil;
                    stage.status = @"0";
                    stage.isFinish = @"1";
                    [stage.tools enumerateObjectsUsingBlock:^(ExamineDetailRequest_17Item_Stages_Tools *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.status = dic[obj.toolID] ?: obj.status;
                        if (obj.status.integerValue >= 1) {
                            stage.status = @"1";
                        }
                        if (obj.status.integerValue != 2) {
                            stage.isFinish =  @"0";
                        }
                    }];
                }
            }];
            [self.tableView reloadData];
        }
    }];
    self.toolStatusRequest = request;
    
}
@end

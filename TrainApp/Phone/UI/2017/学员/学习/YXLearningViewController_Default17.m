//
//  YXLearningViewController_Default17.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/2/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXLearningViewController_Default17.h"
#import "ExamineDetailRequest_17.h"
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
#import "YXCourseDetailPlayerViewController_17.h"
@interface YXLearningViewController_Default17 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) YXLearningTableHeaderView_17 *headerView;


@property (nonatomic, strong) ExamineDetailRequest_17 *examineDetailRequest;
@property (nonatomic, strong) ExamineDetailRequest_17Item *examineDetailItem;
@property (nonatomic, strong) ExamineToolStatusRequest_17 *toolStatusRequest;

@property (nonatomic, strong) YXErrorView *notPayView;

@end

@implementation YXLearningViewController_Default17

- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
#pragma mark - set
- (void)setExamineDetailItem:(ExamineDetailRequest_17Item *)examineDetailItem {
    _examineDetailItem = examineDetailItem;
    [self.headerView reloadHeaderViewContent:_examineDetailItem.examine.userGetScore withPassString:_examineDetailItem.examine.passDesc  withPass:_examineDetailItem.examine.isPass.integerValue];
    self.headerView.hidden = NO;
    [self.tableView reloadData];
    PopUpFloatingViewManager_17 *floatingView = (PopUpFloatingViewManager_17 *)[LSTSharedInstance sharedInstance].floatingViewManager;
    floatingView.scoreString = _examineDetailItem.examine.userGetScore;
    [[LSTSharedInstance sharedInstance].floatingViewManager startPopUpFloatingView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForExamineDetail];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.examineDetailItem.other.stageLockWay.integerValue == 0) {
        [self requestForExamineToolStatus];
    }
    [[LSTSharedInstance sharedInstance].floatingViewManager showPopUpFloatingView];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[LSTSharedInstance sharedInstance].floatingViewManager hiddenPopUpFloatingView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - setupUI
- (void)setupUI {
    self.navigationItem.title = @"";
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[YXLearningStageHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"YXLearningStageHeaderView_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self.tableView registerClass:[YXLearningStageCell_17 class] forCellReuseIdentifier:@"YXLearningStageCell_17"];
    [self.tableView registerClass:[YXLearningChannelHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"YXLearningChannelHeaderView_17"];
    self.headerView = [[YXLearningTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 218)];
    self.headerView.hidden = YES;
    WEAK_SELF
    self.headerView.learningMyScoreCompleteBlock = ^{
        STRONG_SELF
        YXMyLearningScoreViewController_17 *VC = [[YXMyLearningScoreViewController_17 alloc] init];
        VC.examine = self.examineDetailItem.examine;
        [self.navigationController pushViewController:VC animated:YES];
    };
    self.headerView.masterHomeOpenCloseBlock = ^(BOOL isOpen) {
        STRONG_SELF
        if (isOpen) {
            [UIView animateWithDuration:0.25f animations:^{
                self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 218.0f);
                [self.tableView setTableHeaderView:self.headerView];
            }];
        }else {
            self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 193.0f);
            [self.tableView setTableHeaderView:self.headerView];
        }
    };
    self.tableView.tableHeaderView = self.headerView;
    self.errorView = [[YXErrorView alloc] init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForExamineDetail];
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForExamineDetail];
    };
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        STRONG_SELF
        [self requestForExamineDetail];
    }];
    
    self.notPayView = [[YXErrorView alloc] init];
    self.notPayView.title = @"业务异常";
    self.notPayView.subTitle = @"您需要线上支付培训费用,为了不影响学习请您尽快去电脑平台端支付";
    self.notPayView.imageName = @"业务异常";
    self.notPayView.hidden = YES;
    self.notPayView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForExamineDetail];
    };
    [self.view addSubview:self.notPayView];
    [self.notPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
    return ceil((double)stages.tools.count/4.0f) * 80.0f;
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
                        if ((obj.toolID.integerValue == 223) || (obj.toolID.integerValue == 201 && obj.type.integerValue == 1)) {
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
//isPay   是否开启缴费
//isForce  是否强制缴费
//payCount   需要支付的订单数
//
//isPay==1 && payCount>0   弹出提示缴费层
//isForce==1               不能继续学习
#pragma mark - request
- (void)requestForExamineDetail {
    ExamineDetailRequest_17 *request = [[ExamineDetailRequest_17 alloc] init];
    request.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.role = [LSTSharedInstance sharedInstance].trainManager.currentProject.role;
    request.hook = @"yes";

    WEAK_SELF
    [request startRequestWithRetClass:[ExamineDetailRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        self.notPayView.hidden = YES;
        [self.tableView.mj_header endRefreshing];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        ExamineDetailRequest_17Item *item = retItem;
        if (item.isPayStatus.integerValue == 1) {
             self.notPayView.hidden = NO;
            return;
        }
        if (item.isPayStatus.integerValue == 2) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您需要线上支付培训费用，为了不影响学习请您尽快去电脑平台端支付" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                STRONG_SELF

            }];
            [alertVC addAction:goAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        
 //0正常流程   1 强制缴费   2 需要缴费但可以继续学习
        
        self.examineDetailItem = item;
    }];
    self.examineDetailRequest = request;
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
                        if (idx > 0) {
                            ExamineDetailRequest_17Item_Stages_Tools *tool = stage.tools[idx - 1];
                            if (tool.status.integerValue == 1 && obj.status.integerValue <= 0) {
                                obj.status = @"-2";
                            }
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

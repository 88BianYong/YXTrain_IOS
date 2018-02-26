//
//  YXLearningViewController_DeYang17.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/2/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "YXLearningViewController_DeYang17.h"
#import "ExamineDetailRequest_17.h"
#import "YXLearningTableHeaderView_DeYang17.h"
#import "YXLearningStageHeaderView_DeYang17.h"
#import "YXLearningStageCell_DeYang17.h"
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
#import "YXLearningExamExplainView_DeYang17.h"
@interface YXLearningViewController_DeYang17 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) YXLearningTableHeaderView_DeYang17 *headerView;


@property (nonatomic, strong) ExamineDetailRequest_17 *examineDetailRequest;
@property (nonatomic, strong) ExamineDetailRequest_17Item *examineDetailItem;
@property (nonatomic, strong) ExamineToolStatusRequest_17 *toolStatusRequest;

@end

@implementation YXLearningViewController_DeYang17
//JYY04624@yanxiu.com
//JYY04625@yanxiu.com
//JYY04626@yanxiu.com
//JYY04627@yanxiu.com
//JYY04628@yanxiu.com


-(void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
#pragma mark - set
- (void)setExamineDetailItem:(ExamineDetailRequest_17Item *)examineDetailItem {
    _examineDetailItem = examineDetailItem;
    self.headerView.isPass = _examineDetailItem.examine.isPass;
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
    [self.tableView registerClass:[YXLearningStageHeaderView_DeYang17 class] forHeaderFooterViewReuseIdentifier:@"YXLearningStageHeaderView_DeYang17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self.tableView registerClass:[YXLearningStageCell_DeYang17 class] forCellReuseIdentifier:@"YXLearningStageCell_DeYang17"];
    [self.tableView registerClass:[YXLearningChannelHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"YXLearningChannelHeaderView_17"];
    self.headerView = [[YXLearningTableHeaderView_DeYang17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 155.0f + 90.0f + 5.0f + 1.0f)];
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
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ExamineDetailRequest_17Item_Examine_Process *proces = self.examineDetailItem.examine.process[section];
    YXLearningStageHeaderView_DeYang17 *heaerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXLearningStageHeaderView_DeYang17"];
    heaerView.proces = proces;
    WEAK_SELF
    heaerView.learningStageHeaderViewBlock = ^(BOOL isStage) {
        STRONG_SELF
        if (!isStage) {
            if ([self compareDateDate:proces.startDate] &&proces.stageID.integerValue != 0) {
                [self showToast:@"阶段尚未开始"];
                return;
            }
            proces.isMockFold = proces.isMockFold.boolValue ? @"0" : @"1";
            [tableView beginUpdates];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
        }
    };
    heaerView.learningStageExplainBlock = ^(UIButton *sender) {
        STRONG_SELF
        CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
        if (proces.procesID.integerValue == 304) {
            NSString *explainString = [NSString stringWithFormat:@"手机不支持，请到电脑端完成.<br />%@",proces.descr?:@""];
            [self showMarkWithOriginRect:rect explain:explainString];
        }else {
            [self showMarkWithOriginRect:rect explain:proces.descr?:@""];
        }
    };
    return heaerView;
}
- (void)showMarkWithOriginRect:(CGRect)rect explain:(NSString *)string {
    YXLearningExamExplainView_DeYang17 *v = [[YXLearningExamExplainView_DeYang17 alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    [v setupOriginRect:rect withToTop:(rect.origin.y - [YXLearningExamExplainView_DeYang17 heightForDescription:string] - 30 > 0) ? YES : NO];
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
    ExamineDetailRequest_17Item_Examine_Process *proces = self.examineDetailItem.examine.process[section];
    return isEmpty(proces.startDate) ? 45.0f : 70.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExamineDetailRequest_17Item_Examine_Process *proces = self.examineDetailItem.examine.process[indexPath.section];
    return ceil((double)proces.toolExamineVoList.count/4.0f) * 80.0f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.examineDetailItem.examine.process.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ExamineDetailRequest_17Item_Examine_Process *proces = self.examineDetailItem.examine.process[section];
    if (!proces.isMockFold.boolValue) {
        return 0 ;
    }else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXLearningStageCell_DeYang17 *cell = [tableView dequeueReusableCellWithIdentifier:@"YXLearningStageCell_DeYang17" forIndexPath:indexPath];
        ExamineDetailRequest_17Item_Examine_Process *proces = self.examineDetailItem.examine.process[indexPath.section];
    cell.toolExamineVoLists = proces.toolExamineVoList;
    WEAK_SELF
    cell.learningExamineProcesToolCompleteBlock = ^(ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList *tool, NSInteger tagInteger) {
        STRONG_SELF
        if (tool.toolID.integerValue == 201){//课程
            CourseListMangerViewController_17 *VC = [[CourseListMangerViewController_17 alloc] init];
            VC.stageString = proces.stageID;
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
            VC.stageID = proces.stageID;
            [self.navigationController pushViewController:VC animated:YES];
        }else if (tool.toolID.integerValue == 203 || tool.toolID.integerValue == 205){//作业
            HomeworkListViewController_17 *VC = [[HomeworkListViewController_17 alloc] init];
            VC.stageString = proces.stageID;
            VC.toolString = tool.toolID;
            [self.navigationController pushViewController:VC animated:YES];
        }else if (tool.toolID.integerValue == 207){//测评
            [self showToast:@"手机暂不支持测评,请到电脑端完成"];
        }else if (tool.toolID.integerValue == 222) {//阅读
            ReadingListViewController_17 *VC = [[ReadingListViewController_17 alloc] init];
            VC.stageString = proces.stageID;
            VC.toolString = tool.toolID;
            [self.navigationController pushViewController:VC animated:YES];
        }else if (tool.toolID.integerValue == 216) {//集体成果
            HomeworkListViewController_17 *VC = [[HomeworkListViewController_17 alloc] init];
            VC.stageString = proces.stageID;
            VC.toolString = tool.toolID;
            [self.navigationController pushViewController:VC animated:YES];
        }else if (tool.toolID.integerValue == 1010) {
            [self showToast:@"请进入[研修宝]完成"];
        }else if (tool.toolID.integerValue == 1011) {
            [self showToast:@"请进入[研修宝]完成"];
        }else if (tool.toolID.integerValue == 1001) {
            [self showToast:@"手机不支持,请到电脑完成"];
        }else if (tool.toolID.integerValue == 1002) {
            [self showToast:@"手机不支持,请到电脑完成"];
        }else if (tool.toolID.integerValue == 218) {
            [self showToast:@"手机不支持,请到电脑完成"];
        }else {
            [self showToast:@"手机不支持,请到电脑完成"];
        }
    };
    return cell;
}

#pragma mark - request
- (void)requestForExamineDetail {
    ExamineDetailRequest_17 *request = [[ExamineDetailRequest_17 alloc] init];
    request.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.role = [LSTSharedInstance sharedInstance].trainManager.currentProject.role;
    WEAK_SELF
    [request startRequestWithRetClass:[ExamineDetailRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        [self.tableView.mj_header endRefreshing];
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
@end


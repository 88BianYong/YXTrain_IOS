//
//  MasterHomeViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeViewController_17.h"
#import "MasterIndexRequest_17.h"
#import "MasterHomeTableHeaderView_17.h"
#import "MasterHomeHeaderView_17.h"
#import "MasterHomeBarCell_17.h"
#import "MasterHomeModuleCell_17.h"
#import "YXProjectSelectionView.h"
#import "YXSectionHeaderFooterView.h"
#import "MasterReadingListViewController_17.h"
#import "MasterLearningInfoViewController_17.h"
#import "MasterBriefViewController_17.h"
#import "MasterNoticeViewController_17.h"
#import "MasterHomeworkViewController_17.h"
#import "MasterManageActiveViewController_17.h"
#import "MasterManageOffActiveViewController_17.h"
#import "MasterHomeworkSetListViewController_17.h"
#import "MasterCourseRecordListViewController_17.h"
#import "MasterOverallRatingListViewController_17.h"
#import "AppDelegate.h"
#import "YXCourseDetailPlayerViewController_17.h"
#import "MasterServiceAgreementViewController_17.h"
#import "MasterThemeViewController_17.h"

@interface MasterHomeViewController_17()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) MasterHomeTableHeaderView_17 *tableHeaderView;
@property (nonatomic, strong) MasterHomeModuleCell_17 *moduleCell;
@property (nonatomic, strong) YXProjectSelectionView *projectSelectionView;
@property (nonatomic, strong) UIView *qrCodeView;

@property (nonatomic, strong) MasterIndexRequest_17 *indexRequest;
@property (nonatomic, strong) MasterIndexRequestItem_Body *masterItem;
@end

@implementation MasterHomeViewController_17
- (void)dealloc {
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (![LSTSharedInstance sharedInstance].trainManager.currentProject.isSignAgreement.boolValue) {
        MasterServiceAgreementViewController_17 *VC = [[MasterServiceAgreementViewController_17 alloc] init];
        WEAK_SELF
        VC.masterServiceAgreementReloadBlock = ^{
            STRONG_SELF
            [self setupMasterHomePage];
        };
        [self.navigationController pushViewController:VC animated:NO];
        [[LSTSharedInstance sharedInstance].floatingViewManager startPopUpFloatingView];
        return;
    }
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.isOpenTheme.boolValue) {
        WEAK_SELF
        MasterThemeViewController_17 *VC = [[MasterThemeViewController_17 alloc] init];
        VC.masterThemeReloadBlock = ^{
            STRONG_SELF
           [self setupMasterHomePage];
        };
        [self.navigationController pushViewController:VC animated:NO];
        [[LSTSharedInstance sharedInstance].floatingViewManager startPopUpFloatingView];
        return;
    }
    [self setupMasterHomePage];
}
- (void)setupMasterHomePage {
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForMasterIndex];
    NSArray *groups = [TrainListProjectGroup projectGroupsWithRawData:[LSTSharedInstance sharedInstance].trainManager.trainlistItem.body];
    [self dealWithProjectGroups:groups];
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
    [[LSTSharedInstance sharedInstance].floatingViewManager startPopUpFloatingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:@"项目首页" withStatus:YES];
    [self showProjectSelectionView];
    [[LSTSharedInstance sharedInstance].floatingViewManager showPopUpFloatingView];
    [self setupRightWithCustomView:self.qrCodeView];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:@"项目首页" withStatus:NO];
    [self hideProjectSelectionView];
    [[LSTSharedInstance sharedInstance].floatingViewManager hiddenPopUpFloatingView];
}
#pragma mark - set
- (void)setMasterItem:(MasterIndexRequestItem_Body *)masterItem {
    _masterItem = masterItem;
    self.tableView.hidden = NO;
    [self.tableHeaderView reloadHeaderViewContent:_masterItem.myExamine.total withPassString:_masterItem.myExamine.passDesc withDeladyString:_masterItem.myExamine.delayDesc withPass:_masterItem.myExamine.isPass.integerValue];
    [self.tableView reloadData];
}
#pragma mark - setupUI
- (void)setupUI{
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    self.moduleCell = [[MasterHomeModuleCell_17 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MasterHomeModuleCell_17"];
    [self.tableView registerClass:[MasterHomeBarCell_17 class]
           forCellReuseIdentifier:@"MasterHomeBarCell_17"];
    [self.tableView registerClass:[MasterHomeHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"MasterHomeHeaderView_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    self.tableHeaderView = [[MasterHomeTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 237.0f)];
    self.tableView.tableHeaderView = self.tableHeaderView;
    WEAK_SELF
    self.tableHeaderView.masterHomeOpenCloseBlock = ^(BOOL isOpen) {
        STRONG_SELF
        if (isOpen) {
            [UIView animateWithDuration:0.25f animations:^{
                self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 237.0f);
                [self.tableView setTableHeaderView:self.tableHeaderView];
            }];
         }else {
             self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 193.0f);
             [self.tableView setTableHeaderView:self.tableHeaderView];
//             [UIView animateWithDuration:0.25f animations:^{
//                 self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 193.0f);
//                 [self.tableView setTableHeaderView:self.tableHeaderView];
//             }];
//             self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 193.0f);
//             [self.tableView beginUpdates];
//             [self.tableView setTableHeaderView:self.tableHeaderView];
//             [self.tableView endUpdates];
        }
    };
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        STRONG_SELF
        [self requestForMasterIndex];
    }];
    self.errorView = [[YXErrorView alloc] init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForMasterIndex];
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForMasterIndex];
    };
    [self setupQRCodeRightView];

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
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
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
}
#pragma mark - UITableViewDataScore
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.masterItem == nil ? 0 : 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.masterItem.countBars.count;
    }else {
        return 1.0f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MasterHomeBarCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterHomeBarCell_17" forIndexPath:indexPath];
        cell.countBar = self.masterItem.countBars[indexPath.row];
        return cell;
    }else {
        self.moduleCell.modules = self.masterItem.modules;
        WEAK_SELF
        self.moduleCell.masterHomeModuleCompleteBlock = ^(MasterIndexRequestItem_Body_Modules *tool) {
            STRONG_SELF
            if (tool.code.integerValue == 0) {//前置
                MasterReadingListViewController_17 *VC = [[MasterReadingListViewController_17 alloc] init];
                VC.stageString = tool.extend.stageId;
                VC.toolString = tool.toolId;
                [self.navigationController pushViewController:VC animated:YES];
            }else if (tool.code.integerValue == 4) {//学情
                MasterLearningInfoViewController_17 *VC = [[MasterLearningInfoViewController_17 alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }else if (tool.code.integerValue == 3) {//简报
                MasterBriefViewController_17 *VC = [[MasterBriefViewController_17 alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }else if (tool.code.integerValue == 1) {//作业
                MasterHomeworkViewController_17 *VC = [[MasterHomeworkViewController_17 alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }else if (tool.code.integerValue == 2) {//通知
                MasterNoticeViewController_17 *VC = [[MasterNoticeViewController_17 alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }else if (tool.code.integerValue == 6) {//线上
                MasterManageActiveViewController_17 *VC = [[MasterManageActiveViewController_17 alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }else if (tool.code.integerValue == 8) {//线下活动
                MasterManageOffActiveViewController_17 *VC = [[MasterManageOffActiveViewController_17 alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }else if (tool.code.integerValue == 5) {//作品集
                MasterHomeworkSetListViewController_17 *VC = [[MasterHomeworkSetListViewController_17 alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }else if (tool.code.integerValue == 30) {//看课
                MasterCourseRecordListViewController_17 *VC = [[MasterCourseRecordListViewController_17 alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }else if (tool.code.integerValue == 31) {//综合
                MasterOverallRatingListViewController_17 *VC = [[MasterOverallRatingListViewController_17 alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }else if (tool.code.integerValue == 11) {//综合
                MasterThemeViewController_17 *VC = [[MasterThemeViewController_17 alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }else {
                [self showToast:@"手机暂不支持该功能,请到电脑端完成"];
            }
        };
        return self.moduleCell;
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 45.0f;
    }else {
        return ceil((double)self.masterItem.modules.count/4.0f) * kScreenWidth /4.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 37.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MasterHomeHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MasterHomeHeaderView_17"];
    if (section == 0) {
        [headerView reloadHomeHeader:@"我的工作坊" withLine:NO];
    }else {
        [headerView reloadHomeHeader:@"我的辅导任务" withLine:YES];
    }
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - request
- (void)requestForMasterIndex {
    MasterIndexRequest_17 *request = [[MasterIndexRequest_17 alloc] init];
    request.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterIndexRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
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
        MasterIndexRequestItem *item = retItem;
        self.masterItem = item.body;
    }];
    self.indexRequest = request;
}
@end

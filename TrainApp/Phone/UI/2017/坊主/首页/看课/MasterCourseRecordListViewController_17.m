//
//  MasterCourseRecordListViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/4.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterCourseRecordListViewController_17.h"
#import "CourseListRequest_17.h"
#import "CourseHistoryListFetcher_17.h"
#import "MasterCourseListCell_17.h"
#import "CourseListFormatModel_17.h"
#import "MasterCourseRecordListTableHeaderView_17.h"
#import "YXCourseDetailPlayerViewController_17.h"
#import "MasterCourseAllListViewController_17.h"
@interface MasterCourseRecordListViewController_17 ()
@property (nonatomic,strong) MasterCourseRecordListTableHeaderView_17 *headerView;
@end

@implementation MasterCourseRecordListViewController_17
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    CourseHistoryListFetcher_17 *fetcher = [[CourseHistoryListFetcher_17 alloc]init];
    fetcher.stageID = @"0";
    WEAK_SELF
    fetcher.masterCourseHistoryBlock = ^(CourseListRequest_17Item_Scheme *scheme) {
        STRONG_SELF
        if (self.headerView.scheme == nil) {
            self.headerView.scheme = scheme;
        }
        if (scheme.scheme.finishScore.integerValue == 0) {
            self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 0.0001f);
        }else {
            self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 202);
        }
        self.tableView.tableHeaderView = self.headerView;
    };
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:@"看课列表" withStatus:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:@"看课列表" withStatus:NO];
}
#pragma mark - setupUI
- (void)setupUI {
    self.navigationItem.title = @"课程";
    self.emptyView.title = @"没有符合条件的课程";
    self.emptyView.imageName = @"没有符合条件的课程";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MasterCourseListCell_17 class]
           forCellReuseIdentifier:@"MasterCourseListCell_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    self.headerView = [[MasterCourseRecordListTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 198.0f)];
    WEAK_SELF
    self.headerView.masterCourseRecordButtonBlock = ^(UIButton *sender) {
        STRONG_SELF
        CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
        [self showMarkWithOriginRect:rect explain:self.headerView.scheme.scheme.descripe?:@""];
    };
    self.headerView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
    [self setupObservers];
    [self setupAllCourseRightView];
}
- (void)setupAllCourseRightView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"全部课程" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"0070c9"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    button.frame = CGRectMake(0, 0, 80.0f, 30.0f);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 20.0f, 0.0f, -20.0f);
    WEAK_SELF
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        MasterCourseAllListViewController_17 *VC = [[MasterCourseAllListViewController_17 alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
    [self setupRightWithCustomView:button];
}
- (void)showMarkWithOriginRect:(CGRect)rect explain:(NSString *)string {
    MasterMyExamExplainView_17 *v = [[MasterMyExamExplainView_17 alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    [v setupOriginRect:rect];
}

- (void)setupObservers{
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kRecordReportSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSString *course_id = noti.userInfo.allKeys.firstObject;
        NSString *record = noti.userInfo[course_id];
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CourseListRequest_17Item_Objs *course = (CourseListRequest_17Item_Objs *)obj;
            if ([course.objID isEqualToString:course_id]) {
                CourseListRequest_17Item_Scheme *scheme = self.headerView.scheme;
                scheme.process.userFinishNum = [NSString stringWithFormat:@"%ld",scheme.process.userFinishNum.integerValue + (record.integerValue - course.timeLengthSec.integerValue)/60];
                self.headerView.scheme = scheme;
                course.timeLengthSec = record;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                *stop = YES;
            }
        }];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count > 0 ? 1 : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MasterCourseListCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterCourseListCell_17" forIndexPath:indexPath];
    cell.course = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXSectionHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXCourseDetailPlayerViewController_17 *vc = [[YXCourseDetailPlayerViewController_17 alloc] init];
    vc.course = [CourseListFormatModel_17 formatModel:self.dataArray[indexPath.row]];
    vc.stageString = @"0";
    vc.fromWhere = VideoCourseFromWhere_Detail;
    [self.navigationController pushViewController:vc animated:YES];
}
@end

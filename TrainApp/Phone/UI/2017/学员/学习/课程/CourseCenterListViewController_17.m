//
//  CourseCenterListViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseCenterListViewController_17.h"
#import "CourseListFilterView_17.h"
#import "CourseListHeader_17.h"
#import "CourseListCell_17.h"
#import "CourseListFormatModel_17.h"
#import "VideoCourseDetailViewController.h"
#import "CourseHistoryViewController_17.h"
#import "YXCourseDetailPlayerViewController_17.h"
#import "CourseCenterConditionRequest_17.h"
#import "CourseCenterListFetcher_17.h"
@interface CourseCenterListViewController_17 ()
@property (nonatomic, strong) CourseListFilterView_17 *filterView;
@property (nonatomic, strong) CourseListRequest_17Item_Scheme *schemeItem;
@end

@implementation CourseCenterListViewController_17


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    CourseCenterListFetcher_17 *fetcher = [[CourseCenterListFetcher_17 alloc]init];
    fetcher.status = @"0";
    fetcher.tab = self.tabString;
    CourseCenterConditionRequest_17Item_CourseTypes *courseType = self.conditionItem.coursetypes[self.status];
    [self.conditionItem.scheme enumerateObjectsUsingBlock:^(CourseListRequest_17Item_Scheme *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.status == CourseCenterListStatus_Elective && (obj.scheme.toolID.integerValue == 215 || obj.scheme.toolID.integerValue == 315)) {
            self.schemeItem = obj;
            *stop = YES;
        }
        if (self.status == CourseCenterListStatus_Local && (obj.scheme.toolID.integerValue == 217 || obj.scheme.toolID.integerValue == 317)) {
            self.schemeItem = obj;
            *stop = YES;
        }
    }];
    fetcher.stageID = courseType.typeID;
    fetcher.study = self.conditionItem.defaultValue.study;
    fetcher.segment = self.conditionItem.defaultValue.segment;
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    if (self.conditionItem.isLockStudy.boolValue) {
        [self reforeUI];
    }
}
#pragma mark - setupUI 
- (void)reforeUI {
    self.filterView.alpha = 0.0f;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (void)setupUI {
    self.filterView = [[CourseListFilterView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30.0f)];
    [self.view addSubview:self.filterView];
    WEAK_SELF
    self.filterView.courseListFilterSelectedBlock = ^(NSMutableArray *selectedArray) {
        STRONG_SELF
        CourseCenterListFetcher_17 *fetcher = (CourseCenterListFetcher_17 *)self.dataFetcher;
        fetcher.segment = selectedArray[0];
        fetcher.study = selectedArray[1];
        [self startLoading];
        [self firstPageFetch];
    };
    self.filterView.searchTerm = self.conditionItem;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 104.0f;
    [self.tableView registerClass:[CourseListCell_17 class]
           forCellReuseIdentifier:@"CourseListCell_17"];
    [self.tableView registerClass:[CourseListHeader_17 class] forHeaderFooterViewReuseIdentifier:@"CourseListHeader_17"];
    self.emptyView.title = @"没有符合条件的课程";
    self.emptyView.imageName = @"没有符合条件的课程";
    [self setupRightWithTitle:@"看课记录"];
    [self setupObservers];
    [self setupLayout];
}
- (void)setupLayout {
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_offset(30.0f);
    }];
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.filterView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
                if (self.schemeItem.scheme.type.integerValue == 0) {
                    self.schemeItem.process.userFinishNum = [NSString stringWithFormat:@"%ld",self.schemeItem.process.userFinishNum.integerValue + (record.integerValue - course.timeLength.integerValue)/60];
                }
                CourseListHeader_17 *headerView = (CourseListHeader_17 *)[self.tableView headerViewForSection:0];
                headerView.scheme = self.schemeItem;
                course.timeLength = record;
                [self.tableView reloadData];
//                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                *stop = YES;
            }
        }];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kYXTrainCompleteCourse object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSString *course_id = noti.userInfo.allKeys.firstObject;
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CourseListRequest_17Item_Objs *course = (CourseListRequest_17Item_Objs *)obj;
            if ([course.objID isEqualToString:course_id] && self.schemeItem.scheme.type.integerValue == 1) {
                course.isFinish = @"1";
                self.schemeItem.process.userFinishNum = [NSString stringWithFormat:@"%ld",self.schemeItem.process.userFinishNum.integerValue + 1];
                CourseListHeader_17 *headerView = (CourseListHeader_17 *)[self.tableView headerViewForSection:0];
                headerView.scheme = self.schemeItem;
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
    CourseListCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseListCell_17" forIndexPath:indexPath];
    CourseListRequest_17Item_Objs *obj = self.dataArray[indexPath.row];
    cell.course = obj;
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.schemeItem == nil) {
        return 0.0001f;
    }
    return 70.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CourseListHeader_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CourseListHeader_17"];
    headerView.scheme = self.schemeItem;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     YXCourseDetailPlayerViewController_17 *vc = [[YXCourseDetailPlayerViewController_17 alloc]init];
    vc.course = [CourseListFormatModel_17 formatModel:self.dataArray[indexPath.row]];
    vc.fromWhere = VideoCourseFromWhere_Detail;
    vc.isHiddenTestBool = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end

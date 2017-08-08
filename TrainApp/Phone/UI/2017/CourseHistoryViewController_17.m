//
//  CourseHistoryViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseHistoryViewController_17.h"
#import "CourseListRequest_17.h"
#import "CourseHistoryListFetcher_17.h"
#import "CourseHistoryCell_17.h"
#import "YXCourseListRequest.h"
#import "VideoCourseDetailViewController_17.h"
@interface CourseHistoryViewController_17 ()
@end

@implementation CourseHistoryViewController_17
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    CourseHistoryListFetcher_17 *fetcher = [[CourseHistoryListFetcher_17 alloc]init];
    fetcher.stageID = self.stageString;
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    self.title = @"看课记录";
    self.emptyView.title = @"没有符合条件的课程";
    self.emptyView.imageName = @"没有符合条件的课程";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CourseHistoryCell_17 class]
           forCellReuseIdentifier:@"CourseHistoryCell_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self setupObservers];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    CourseHistoryCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseHistoryCell_17" forIndexPath:indexPath];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourseListRequest_17Item_Objs *obj = self.dataArray[indexPath.row];
    YXCourseListRequestItem_body_module_course *course  = [[YXCourseListRequestItem_body_module_course alloc] init];
    course.courses_id = obj.objID;
    course.course_title = obj.name;
    course.course_img = obj.content.imgUrl;
    course.record = obj.timeLength;
    course.is_selected = obj.isSelected;
    course.module_id = obj.stageID;
    course.isSupportApp = @"1";//新接口中暂无是否支持移动端的字段
    course.type = obj.type;
    if (course.isSupportApp.boolValue) {
        VideoCourseDetailViewController_17 *vc = [[VideoCourseDetailViewController_17 alloc]init];
        vc.course = course;
        vc.stageString = self.stageString;
        vc.fromWhere = VideoCourseFromWhere_Detail;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end

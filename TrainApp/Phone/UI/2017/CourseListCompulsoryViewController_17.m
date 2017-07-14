//
//  CompulsoryCourseListViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseListCompulsoryViewController_17.h"
#import "CourseListFetcher_17.h"
#import "CourseListTableViewHeader_17.h"
#import "CourseListHeader_17.h"
#import "CourseListCell_17.h"
@interface CourseListCompulsoryViewController_17 ()

@end

@implementation CourseListCompulsoryViewController_17

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    CourseListFetcher_17 *fetcher = [[CourseListFetcher_17 alloc]init];
    fetcher.stageID = @"";
    fetcher.study = @"";
    fetcher.segment = @"";
    fetcher.type = @"";
    WEAK_SELF
    fetcher.courseListItemBlock = ^(CourseListRequest_17Item *model) {
        STRONG_SELF
    };
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
}
- (void)setupUI {
//    self.emptyView.title = @"没有符合条件的课程";
//    self.emptyView.imageName = @"没有符合条件的课程";
//    [self setupRightWithTitle:@"看课记录"];
//    [self setupObservers];
//    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.tableView registerClass:[YXCourseListCell class] forCellReuseIdentifier:@"YXCourseListCell"];
//    
//    if (self.isWaitingForFilter) {
//        self.filterErrorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
//        WEAK_SELF
//        self.filterErrorView.retryBlock = ^{
//            STRONG_SELF
//            [self getFilters];
//        };
//        [self getFilters];
//    }
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
    // Dispose of any resources that can be recreated.
}


//- (void)setupObservers{
//    WEAK_SELF
//    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kRecordReportSuccessNotification object:nil]subscribeNext:^(id x) {
//        STRONG_SELF
//        NSNotification *noti = (NSNotification *)x;
//        NSString *course_id = noti.userInfo.allKeys.firstObject;
//        NSString *record = noti.userInfo[course_id];
//        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            YXCourseListRequestItem_body_module_course *course = (YXCourseListRequestItem_body_module_course *)obj;
//            if ([course.courses_id isEqualToString:course_id]) {
//                course.record = record;
//                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//                *stop = YES;
//            }
//        }];
//    }];
//}

//- (void)naviRightAction{
//    YXCourseRecordViewController *vc = [[YXCourseRecordViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - UITableViewDataSource
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    YXCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXCourseListCell"];
//    cell.course = self.dataArray[indexPath.row];
//    return cell;
//}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    YXCourseListRequestItem_body_module_course *course = self.dataArray[indexPath.row];
//    if (course.isSupportApp.boolValue) {
//        VideoCourseDetailViewController *vc = [[VideoCourseDetailViewController alloc]init];
//        vc.course = course;
//        vc.fromWhere = VideoCourseFromWhere_Detail;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

@end

//
//  ElectiveCourseListViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseListElectiveViewController_17.h"
#import "CourseListCompulsoryViewController_17.h"
#import "CourseListFetcher_17.h"
#import "CourseListFilterView_17.h"
#import "CourseListHeader_17.h"
#import "CourseListCell_17.h"
#import "YXCourseListRequest.h"
#import "VideoCourseDetailViewController.h"
@interface CourseListElectiveViewController_17 ()
@property (nonatomic, strong) CourseListFilterView_17 *filterView;
@end

@implementation CourseListElectiveViewController_17

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
        self.filterView.searchTerm = model.searchTerm;
    };
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
}
- (void)setupUI {
    self.filterView = [[CourseListFilterView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30.0f)];
    [self.contentView addSubview:self.filterView];
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_offset(30.0f);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.filterView.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    self.emptyView.title = @"没有符合条件的课程";
    self.emptyView.imageName = @"没有符合条件的课程";
    [self setupRightWithTitle:@"看课记录"];
    [self setupObservers];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CourseListCell_17 class]
           forCellReuseIdentifier:@"CourseListCell_17"];
    [self.tableView registerClass:[CourseListHeader_17 class] forHeaderFooterViewReuseIdentifier:@"CourseListHeader_17"];
    [self setupObservers];
    
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
                course.timeLength = record;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                *stop = YES;
            }
        }];
    }];
}

- (void)naviRightAction{
    //    YXCourseRecordViewController *vc = [[YXCourseRecordViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseListCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseListCell_17"];
    cell.course = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CourseListHeader_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CourseListHeader_17"];
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
        VideoCourseDetailViewController *vc = [[VideoCourseDetailViewController alloc]init];
        vc.course = course;
        vc.fromWhere = VideoCourseFromWhere_Detail;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end

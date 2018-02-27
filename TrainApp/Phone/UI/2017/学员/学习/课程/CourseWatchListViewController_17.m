//
//  CompulsoryCourseListViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseWatchListViewController_17.h"
#import "CourseListFetcher_17.h"
#import "CourseListFilterView_17.h"
#import "CourseListHeader_17.h"
#import "CourseListCell_17.h"
#import "CourseListFormatModel_17.h"
#import "VideoCourseDetailViewController.h"
#import "CourseHistoryViewController_17.h"
#import "YXCourseDetailPlayerViewController_17.h"
@interface CourseWatchListViewController_17 ()
@property (nonatomic, strong) CourseListFilterView_17 *filterView;
@property (nonatomic, strong) CourseListRequest_17Item_Scheme *schemeItem;

@end

@implementation CourseWatchListViewController_17

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    CourseListFetcher_17 *fetcher = [[CourseListFetcher_17 alloc]init];
    fetcher.stageID = self.stageString;
    fetcher.study = self.studyString;
    fetcher.segment = self.segmentString;
    fetcher.type = self.typeString;
    WEAK_SELF
    fetcher.courseListItemBlock = ^(CourseListRequest_17Item *model) {
        STRONG_SELF
        if (model.scheme.count > 0) {
            [model.scheme enumerateObjectsUsingBlock:^(CourseListRequest_17Item_Scheme *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (self.typeString.integerValue == 0) {
                    self.schemeItem = obj;
                    *stop = YES;
                    return ;
                }
                if (self.typeString.integerValue == 102 && obj.scheme.toolID.integerValue == 201) {
                    self.schemeItem = obj;
                    *stop = YES;
                    return;
                }
                if (self.typeString.integerValue == 101 && obj.scheme.toolID.integerValue == 223) {
                    self.schemeItem = obj;
                    *stop = YES;
                    return;
                }
            }];
            if (self.schemeItem == nil) {
                self.schemeItem = model.scheme[0];
            }
        }
        if (self.typeString.integerValue != 0 || model.searchTerm.isLockStudy.boolValue) {
            [self reforeUI];
        }else if (self.filterView.searchTerm == nil) {
            self.filterView.searchTerm = model.searchTerm;
            self.filterView.hidden = NO;
        }
    };
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
}
- (void)setupUI {
    self.filterView = [[CourseListFilterView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30.0f)];
    WEAK_SELF
    self.filterView.courseListFilterSelectedBlock = ^(NSMutableArray *selectedArray) {
        STRONG_SELF
        CourseListFetcher_17 *fetcher = (CourseListFetcher_17 *)self.dataFetcher;
        fetcher.segment = selectedArray[0];
        fetcher.study = selectedArray[1];
        [self startLoading];
        [self firstPageFetch];
    };
    self.filterView.hidden = YES;
    [self.view addSubview:self.filterView];
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
    self.emptyView.title = @"没有符合条件的课程";
    self.emptyView.imageName = @"没有符合条件的课程";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[CourseListCell_17 class]
           forCellReuseIdentifier:@"CourseListCell_17"];
    [self.tableView registerClass:[CourseListHeader_17 class] forHeaderFooterViewReuseIdentifier:@"CourseListHeader_17"];
    [self setupObservers];
}
- (void)reforeUI {
    self.filterView.alpha = 0.0f;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
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
                    self.schemeItem.process.userFinishNum = [NSString stringWithFormat:@"%ld",self.schemeItem.process.userFinishNum.integerValue + (record.integerValue - course.timeLengthSec.integerValue)/60];
                }
                CourseListHeader_17 *headerView = (CourseListHeader_17 *)[self.tableView headerViewForSection:0];
                headerView.scheme = self.schemeItem;
                course.timeLengthSec = record;
                [self.tableView reloadData];
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
            if ([course.objID isEqualToString:course_id] && self.schemeItem.scheme.type.integerValue == 1){
                course.isFinish = @"1";
                self.schemeItem.process.userFinishNum = [NSString stringWithFormat:@"%ld",self.schemeItem.process.userFinishNum.integerValue + 1];
                CourseListHeader_17 *headerView = (CourseListHeader_17 *)[self.tableView headerViewForSection:0];
                headerView.scheme = self.schemeItem;
                [self.tableView reloadData];
                *stop = YES;
            }
        }];
    }];
    
    //德阳项目
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kYXTrainReadingClassRecordsCleared object:nil] subscribeNext:^(NSNotification *noti) {
        STRONG_SELF
        NSString *course_id = noti.object;
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CourseListRequest_17Item_Objs *course = (CourseListRequest_17Item_Objs *)obj;
            if ([course.objID isEqualToString:course_id]) {
                course.timeLengthSec = @"0";
                [self.tableView reloadData];
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
    cell.course = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.schemeItem == nil) {//没有返回考核要求不显示
        return 0.0001f;
    }
    if (self.schemeItem.scheme.finishNum.integerValue == 0) {//有考核要求但为0 显示无考核要求
        return 45.0f;
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
    YXCourseListRequestItem_body_module_course *course = [CourseListFormatModel_17 formatModel:self.dataArray[indexPath.row]];
    if (course.isSupportApp.boolValue) {
        YXCourseDetailPlayerViewController_17 *vc = [[YXCourseDetailPlayerViewController_17 alloc] init];
        vc.course = course;
        vc.stageString = self.stageString;
        vc.fromWhere = VideoCourseFromWhere_Detail;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self showToast:@"手机端暂不支持播放该视频，请到PC端观看"];
    }
}

#pragma mark - request
- (void)firstPageFetch {
    [super firstPageFetch];
}
@end

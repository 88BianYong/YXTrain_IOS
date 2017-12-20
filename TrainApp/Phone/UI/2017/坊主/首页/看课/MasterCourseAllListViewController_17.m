//
//  MasterCourseAllListViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/4.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterCourseAllListViewController_17.h"
#import "MasterCourseAllFetcher_17.h"
#import "MasterCourseListCell_17.h"
#import "CourseListFormatModel_17.h"
#import "YXCourseDetailPlayerViewController_17.h"
#import "LSTCollectionFilterView.h"
@interface MasterCourseAllListViewController_17 ()
@property (nonatomic, strong) LSTCollectionFilterModel *filterModel;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) AlertView *alert;
@end

@implementation MasterCourseAllListViewController_17
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - set
- (AlertView *)alert {
    if (_alert == nil) {
        _alert = [[AlertView alloc]init];
        _alert.hideWhenMaskClicked = YES;
    }
    return _alert;
}
- (void)viewDidLoad {
    MasterCourseAllFetcher_17 *fetcher = [[MasterCourseAllFetcher_17 alloc]init];
    fetcher.stageID = @"0";
    fetcher.study = @"10";
    fetcher.segment = @"10";
    fetcher.type = @"0";
    fetcher.status = @"2";
    WEAK_SELF
    fetcher.masterCourseFilterBlock = ^(LSTCollectionFilterModel *model) {
        STRONG_SELF
        if (self.filterModel == nil) {
            self.filterModel = model;
        }
        
    };
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    self.navigationItem.title = @"全部课程";
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self setupUI];
    [self setupObservers];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:@"全部课程列表" withStatus:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:@"全部课程列表" withStatus:NO];
}
- (void)setupUI {
    self.emptyView.title = @"没有符合条件的课程";
    self.emptyView.imageName = @"没有符合条件的课程";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MasterCourseListCell_17 class]
           forCellReuseIdentifier:@"MasterCourseListCell_17"];
    [self setupFilterRightView];
}
- (void)setupFilterRightView {
    self.filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.filterButton setTitle:@"筛选" forState:UIControlStateNormal];
    [self.filterButton setTitleColor:[UIColor colorWithHexString:@"0070c9"] forState:UIControlStateNormal];
    self.filterButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.filterButton.frame = CGRectMake(0, 0, 40.0f, 30.0f);
    WEAK_SELF
    [[self.filterButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        if (!self.filterButton.selected) {
            [self showSelectionView];
        }else {
            [self.alert hide];
        }
    }];
    [self setupRightWithCustomView:self.filterButton];
}
- (void)showSelectionView {
    __block LSTCollectionFilterView *selectionView = [[LSTCollectionFilterView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    selectionView.filterModel = self.filterModel;
    self.alert.contentView = selectionView;
    WEAK_SELF
    [self.alert setHideBlock:^(AlertView *view) {
        STRONG_SELF
        self.filterButton.selected = NO;
        self.filterButton.enabled = NO;
        [UIView animateWithDuration:0.3 animations:^{
            [selectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left);
                make.right.equalTo(view.mas_right);
                make.top.equalTo(view.mas_top);
                make.height.mas_offset(5.0f);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.filterButton.enabled = YES;
            [selectionView cancleUserSelected];
            self.alert.contentView = nil;
            [selectionView removeFromSuperview];
            selectionView = nil;
            [view removeFromSuperview];
        }];
    }];
    [self.alert showInView:self.view withFrame:^(AlertView *view) {
        STRONG_SELF
        self.filterButton.selected = YES;
        selectionView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, 0.0f);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25f animations:^{
                if (self.view.bounds.size.height > selectionView.collectionSize.height) {
                    selectionView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, selectionView.collectionSize.height);
                }else {
                    selectionView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, self.view.bounds.size.height);
                }
            }];
        });
    }];
    selectionView.filterSelectedBlock = ^(LSTCollectionFilterModel_ItemName *itemName) {
        STRONG_SELF
        [self.alert hide];
        if (itemName != nil) {
            //顺序：阶段、状态、类型、学段、学科
            MasterCourseAllFetcher_17 *fetcher = (MasterCourseAllFetcher_17 *)self.dataFetcher;
            fetcher.stageID = itemName.defaultSelectedID;
            fetcher.status = itemName.itemName.defaultSelectedID;
            fetcher.type = itemName.itemName.itemName.defaultSelectedID;
            fetcher.segment = itemName.itemName.itemName.itemName.defaultSelectedID;
            fetcher.study = itemName.itemName.itemName.itemName.itemName.defaultSelectedID;
            [self startLoading];
            [self firstPageFetch];
        }
    };
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    return 0.0001f;
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

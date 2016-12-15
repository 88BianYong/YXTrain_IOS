//
//  BeijingActivityListViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingActivityListViewController.h"
#import "BeijingActivityListCell.h"
#import "ActivityListFetcher.h"
#import "ActivityListCell.h"
#import "BeijingActivityFilterRequest.h"
#import "ActivityFilterModel.h"
#import "ActivityDetailViewController.h"
#import "YXCourseFilterView.h"
@interface BeijingActivityListViewController ()
<YXCourseFilterViewDelegate>
@property (nonatomic, strong) BeijingActivityFilterRequest *filterRequest;
@property (nonatomic, strong) ActivityFilterModel *filterModel;
@property (nonatomic, strong) YXCourseFilterView *filterView;
@property (nonatomic, strong) YXErrorView *filterErrorView;
@property (nonatomic, assign) BOOL isWaitingForFilter;
@property (nonatomic, assign) BOOL isNavBarHidden;
@property (nonatomic, strong) NSString *segmentId;
@property (nonatomic, strong) NSString *studyId;
@property (nonatomic, strong) NSString *stageId;
@end

@implementation BeijingActivityListViewController
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [self setupFetcher];
    YXEmptyView *emptyView = [[YXEmptyView alloc]init];
    emptyView.title = @"没有符合条件的活动";
    emptyView.imageName = @"没有符合条件的课程";
    self.emptyView = emptyView;
    self.isWaitingForFilter = YES;
    [super viewDidLoad];
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isNavBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)setupFetcher {
    ActivityListFetcher *fetcher = [[ActivityListFetcher alloc]init];
    fetcher.pid = [YXTrainManager sharedInstance].currentProject.pid;
    fetcher.pageindex = 0;
    fetcher.pagesize = 10;
    WEAK_SELF
    fetcher.listCompleteBlock = ^(){
        STRONG_SELF

    };
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
}
- (void)dealWithFilterModel:(ActivityFilterModel *)model {
    YXCourseFilterView *filterView = [[YXCourseFilterView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.filterView = filterView;
    for (ActivityFilterGroup *group in model.groupArray) {
        NSMutableArray *array = [NSMutableArray array];
        for (ActivityFilter *filter in group.filterArray) {
            [array addObject:filter.name];
        }
        [filterView addFilters:array forKey:group.name];
    }
    filterView.delegate = self;
    [self.view addSubview:filterView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(44);
    }];
}
- (void)refreshDealWithFilterModel:(ActivityFilterModel *)model {
    for (ActivityFilterGroup *group in model.groupArray) {
        if ([group.name isEqualToString:@"学科"]) {
            NSMutableArray *array = [NSMutableArray array];
            for (ActivityFilter *filter in group.filterArray) {
                [array addObject:filter.name];
            }
            [self.filterView refreshStudysFilters:array forKey:group.name];
        }
    }
}

- (void)setupUI {
    self.title = @"活动列表";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[BeijingActivityListCell class] forCellReuseIdentifier:@"BeijingActivityListCell"];
    [self.emptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.right.bottom.mas_equalTo(0);
    }];
    if (self.isWaitingForFilter) {
        self.filterErrorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
        WEAK_SELF
        self.filterErrorView.retryBlock = ^{
            STRONG_SELF
            [self allFiltersForIsRefresh:NO];
        };
        [self allFiltersForIsRefresh:NO];
    }
}
- (void)allFiltersForIsRefresh:(BOOL)isRefresh {
    [self.filterRequest stopRequest];
    self.filterRequest = [[BeijingActivityFilterRequest alloc]init];
    self.filterRequest.pid = [YXTrainManager sharedInstance].currentProject.pid;
    self.filterRequest.w = [YXTrainManager sharedInstance].currentProject.w;
    self.filterRequest.segmentId = self.segmentId;
    [self startLoading];
    WEAK_SELF
    [self.filterRequest startRequestWithRetClass:[ActivityFilterRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self stopLoading];
            self.filterErrorView.frame = self.view.bounds;
            [self.view addSubview:self.filterErrorView];
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            return;
        }
        [self.filterErrorView removeFromSuperview];
        ActivityFilterRequestItem *item = (ActivityFilterRequestItem *)retItem;
        self.filterModel = [item filterModel];
        self.isWaitingForFilter = NO;

        if (isRefresh || self.filterView) {
            [self refreshDealWithFilterModel:self.filterModel];
        }else {
            [self dealWithFilterModel:self.filterModel];
            self.segmentId = [self firstRequestParameter:self.filterModel.groupArray.firstObject];
        }
        ActivityListFetcher *fetcher = (ActivityListFetcher *)self.dataFetcher;
        fetcher.studyid = self.studyId?:@"0";
        fetcher.segid = self.segmentId?:@"0";
        fetcher.stageid = self.stageId?:[self firstRequestParameter:self.filterModel.groupArray.lastObject];
        [self firstPageFetch:YES];
    }];
}
- (NSString *)firstRequestParameter:(ActivityFilterGroup *)stageGroup {
    ActivityFilter *filter = stageGroup.filterArray.firstObject;
    return filter.filterID;
}

- (void)tableViewWillRefresh {
    CGFloat top = 0.f;
    if (self.filterView) {
        top = 44.f;
    }
    [self.errorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.right.bottom.mas_equalTo(0);
    }];
}
- (void)firstPageFetch:(BOOL)isShow {
    if (self.isWaitingForFilter) {
        return;
    }
    [super firstPageFetch:isShow];
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BeijingActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeijingActivityListCell"];
    cell.activity = self.dataArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"BeijingActivityListCell" configuration:^(BeijingActivityListCell *cell) {
        cell.activity = self.dataArray[indexPath.row];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ActivityListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.activity.source isEqualToString:@"zgjiaoyan"]) {//目前暂不支持教研网的活动
        [self showToast:@"暂不支持教研网活动"];
    }else if ([cell.activity.status isEqualToString:@"-1"]) {//活动关闭
        [self showToast:@"该活动已关闭"];
    }else {
        ActivityDetailViewController *detailVC = [[ActivityDetailViewController alloc] init];
        detailVC.activity = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
#pragma mark - YXCourseFilterViewDelegate
- (void)filterChanged:(NSArray *)filterArray {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    // 学段
    NSNumber *num0 = filterArray[0];
    ActivityFilterGroup *group0 = self.filterModel.groupArray[0];
    ActivityFilter *segmentItem = [[ActivityFilter alloc]init];
    if (group0.filterArray.count > 0) {
        segmentItem = group0.filterArray[num0.integerValue];
        if (![self.segmentId isEqualToString:segmentItem.filterID]) {
            self.studyId = nil;
            self.segmentId = segmentItem.filterID;
            [self allFiltersForIsRefresh:YES];
            return;
        }
        self.segmentId = segmentItem.filterID;
    }
    // 学科
    NSNumber *num1 = filterArray[1];
    ActivityFilterGroup *group1 = self.filterModel.groupArray[1];
    ActivityFilter *studyItem = [[ActivityFilter alloc]init];
    if (group0.filterArray.count > 0) {
        studyItem = group1.filterArray[num1.integerValue];
        self.studyId = studyItem.filterID;
    }
    // 阶段
    NSNumber *num2 = filterArray[2];
    ActivityFilterGroup *group2 = self.filterModel.groupArray[2];
    ActivityFilter *stageItem = [[ActivityFilter alloc]init];
    if (group2.filterArray.count > 0) {
        stageItem = group2.filterArray[num2.integerValue];
        self.stageId = stageItem.filterID;
    }
    DDLogDebug(@"Changed: 学段:%@，学科:%@，阶段:%@",segmentItem.name,studyItem.name,stageItem.name);
    ActivityListFetcher *fetcher = (ActivityListFetcher *)self.dataFetcher;
    fetcher.studyid = studyItem.filterID?:@"0";//服务端数据返回空的处理:"0"-全部,即不做筛选
    fetcher.segid = segmentItem.filterID?:@"0";
    fetcher.stageid = stageItem.filterID?:@"0";
    [self firstPageFetch:YES];
}
#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height >= kScreenHeight -  44 + 10.0f){
        CGPoint point = scrollView.contentOffset;
        if (point.y >= 5 && !self.isNavBarHidden) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            self.filterView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 44);
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(64);
            }];
            DDLogDebug(@"隐藏");
            self.isNavBarHidden = YES;
        }else if (point.y < 5 && self.isNavBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            self.filterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(44);
            }];
            DDLogDebug(@"显示");
            self.isNavBarHidden = NO;
        }
    }else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.filterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(44);
        }];
        self.isNavBarHidden = NO;
    }
}
@end

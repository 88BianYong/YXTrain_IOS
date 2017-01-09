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
#import "ActivityDetailViewController.h"
#import "YXCourseFilterView.h"
#import "BeijingActivityFilterManager.h"
@interface BeijingActivityListViewController ()
<YXCourseFilterViewDelegate>
@property (nonatomic, strong) BeijingActivityFilterManager *filterManager;
@property (nonatomic, strong) YXCourseFilterView *filterView;
@property (nonatomic, strong) YXErrorView *filterErrorView;
@property (nonatomic, strong) DataErrorView *filterDataErrorView;
@property (nonatomic, assign) BOOL isWaitingForFilter;
@property (nonatomic, assign) BOOL isNavBarHidden;
@property (nonatomic, strong) NSString *segmentId;
@property (nonatomic, strong) NSString *studyId;
@property (nonatomic, strong) NSString *stageId;

@property (nonatomic, strong) BeijingActivityFilterModel *filterModel;
@property (nonatomic, assign) NSInteger chooseSegment;
@property (nonatomic, assign) CGFloat oldOffsetY;
@property (nonatomic, assign) BOOL isAllowChange;
@end

@implementation BeijingActivityListViewController
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [self setupFetcher];
    self.isWaitingForFilter = YES;
    [super viewDidLoad];
    self.isAllowChange = YES;
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


- (void)setupUI {
    self.title = @"活动列表";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[BeijingActivityListCell class] forCellReuseIdentifier:@"BeijingActivityListCell"];
    if (self.isWaitingForFilter) {
        self.filterErrorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
        WEAK_SELF
        self.filterErrorView.retryBlock = ^{
            STRONG_SELF
            [self allFiltersForIsRefresh:NO];
        };
        [self allFiltersForIsRefresh:NO];
        
        self.filterDataErrorView = [[DataErrorView alloc] initWithFrame:self.view.bounds];
        self.filterDataErrorView.refreshBlock = ^ {
            STRONG_SELF
            [self allFiltersForIsRefresh:NO];
        };
    }
    self.emptyView.title = @"没有符合条件的活动";
    self.emptyView.imageName = @"没有符合条件的课程";
}
- (void)allFiltersForIsRefresh:(BOOL)isRefresh {
    self.filterManager = [[BeijingActivityFilterManager alloc] init];
    [self startLoading];
    WEAK_SELF
    [self.filterManager startRequestActivityFilterItemWithBlock:^(BeijingActivityFilterModel *model, NSError *error) {
        STRONG_SELF
        if (error) {
            [self stopLoading];
            if (error.code == 2) {
                self.filterDataErrorView.frame = self.view.bounds;
                [self.view addSubview:self.filterDataErrorView];
            }else {
                self.filterErrorView.frame = self.view.bounds;
                [self.view addSubview:self.filterErrorView];
            }
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            return;
        }
        [self.filterErrorView removeFromSuperview];
        [self.filterDataErrorView removeFromSuperview];
        self.filterModel = model;
        [self dealWithFilterModel:self.filterModel];
        self.isWaitingForFilter = NO;
        ActivityListFetcher *fetcher = (ActivityListFetcher *)self.dataFetcher;
        fetcher.segid = self.filterModel.segment[0].filterID;
        fetcher.studyid = self.filterModel.study[0].filterID;
        fetcher.stageid = self.filterModel.stage[0].filterID;
        [self firstPageFetch];
    }];
}
- (void)dealWithFilterModel:(BeijingActivityFilterModel *)body {
    YXCourseFilterView *filterView = [[YXCourseFilterView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    self.filterView = filterView;
    [self addFilters:body.segment forKey:body.segmentName];
    [self addFilters:body.study forKey:body.studyName];
    [self addFilters:body.stage forKey:body.stageName];
    filterView.delegate = self;
    [self.view addSubview:filterView];
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(44);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
}

- (void)addFilters:(NSArray *)filters forKey:(NSString *)key {
    NSMutableArray *array = [NSMutableArray array];
    for (BeijingActivityFilter *filter in filters) {
        [array addObject:filter.name];
    }
    [self.filterView addFilters:array forKey:key];
    if (![array[0] isEqualToString:@"全部"]) {
        [self.filterView setCurrentIndex:0 forKey:key];
    }
}
- (void)refreshDealWithFilterModel{
    NSMutableArray *array = [NSMutableArray array];
    for (BeijingActivityFilter *filter in self.filterModel.study) {
        [array addObject:filter.name];
    }
    [self.filterView refreshStudysFilters:array forKey:self.filterModel.studyName];
}

- (void)firstPageFetch {
    if (self.isWaitingForFilter) {
        return;
    }
    [super firstPageFetch];
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
    BeijingActivityListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
    NSNumber *num1 = [NSNumber numberWithInteger:0];
    if (num0.integerValue != self.filterModel.chooseInteger) {
        self.filterModel.chooseInteger = num0.integerValue;
        [self refreshDealWithFilterModel];
    }else {
        // 学科
        num1 = filterArray[1];
    }
    //类型
    NSNumber *num2 = filterArray[2];
    ActivityListFetcher *fetcher = (ActivityListFetcher *)self.dataFetcher;
    //服务端数据返回空的处理:"0"-全部,即不做筛选
    fetcher.segid = self.filterModel.segment[num0.integerValue].filterID?:@"0";
    fetcher.studyid = self.filterModel.study[num1.integerValue].filterID?:@"0";
    fetcher.stageid = self.filterModel.stage[num2.integerValue].filterID?:@"0";
    [self startLoading];
    [self firstPageFetch];
}
#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentSize.height >= kScreenHeight -  44 + 10.0f){
        if (scrollView.contentSize.height - self.tableView.bounds.size.height < self.oldOffsetY && self.isAllowChange) {
            self.isNavBarHidden = YES;
            self.isAllowChange = NO;
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            self.filterView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 44);
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(64);
            }];
            return;
        }
        
        if (scrollView.contentOffset.y > self.oldOffsetY && self.isAllowChange) {
            self.isNavBarHidden = YES;
            self.isAllowChange = NO;
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            self.filterView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 44);
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(64);
            }];
        }
        if (scrollView.contentOffset.y < self.oldOffsetY && self.isAllowChange) {
            self.isNavBarHidden = NO;
            self.isAllowChange = NO;
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            self.filterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(44);
            }];
        }
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.filterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(44);
        }];
        self.isNavBarHidden = NO;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.oldOffsetY = MAX(scrollView.contentOffset.y, 0.0f);
    self.isAllowChange = YES;
}
@end

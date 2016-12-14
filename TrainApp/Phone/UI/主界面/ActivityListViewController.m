//
//  ActivityListViewController.m
//  TrainApp
//
//  Created by ZLL on 2016/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityListFetcher.h"
#import "ActivityListCell.h"
#import "ActivityFilterRequest.h"
#import "ActivityFilterModel.h"
#import "ActivityDetailViewController.h"
#import "YXCourseFilterView.h"
@interface ActivityListViewController ()<YXCourseFilterViewDelegate>
@property (nonatomic, strong) ActivityFilterRequest *filterRequest;
@property (nonatomic, strong) ActivityFilterModel *filterModel;
@property (nonatomic, strong) YXCourseFilterView *filterView;
@property (nonatomic, strong) YXErrorView *filterErrorView;
@property (nonatomic, assign) BOOL isWaitingForFilter;
@property (nonatomic, assign) BOOL isNavBarHidden;
@end

@implementation ActivityListViewController
- (void)viewDidLoad {
    [self setupFetcher];
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
    fetcher.stageid = self.stageID;
    fetcher.pageindex = 0;
    fetcher.pagesize = 10;
    WEAK_SELF
    fetcher.listCompleteBlock = ^(){
        STRONG_SELF
        if (self.filterView) {
            return;
        }
        [self dealWithFilterModel:self.filterModel];
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
    [self setupWithCurrentFilters];
    filterView.delegate = self;
    [self.view addSubview:filterView];
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(44);
    }];
}
- (void)setupWithCurrentFilters {
        ActivityFilterGroup *stageGroup = self.filterModel.groupArray.lastObject;
        __block NSInteger stageIndex = -1;
        [stageGroup.filterArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ActivityFilter *filter = (ActivityFilter *)obj;
            if ([self.stageID isEqualToString:filter.filterID]) {
                stageIndex = idx;
                *stop = YES;
            }
        }];
        if (stageIndex >= 0) {
            [self.filterView setCurrentIndex:stageIndex forKey:stageGroup.name];
        }
}
- (void)setupUI {
    self.emptyView.title = @"没有符合条件的活动";
    self.emptyView.imageName = @"没有符合条件的课程";
    self.title = @"活动列表";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ActivityListCell class] forCellReuseIdentifier:@"ActivityListCell"];
   
    if (self.isWaitingForFilter) {
        self.filterErrorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
        WEAK_SELF
        self.filterErrorView.retryBlock = ^{
            STRONG_SELF
            [self allFilters];
        };
        [self allFilters];
    }
}
- (void)allFilters {
    [self.filterRequest stopRequest];
    self.filterRequest = [[ActivityFilterRequest alloc]init];
    self.filterRequest.projectId = [YXTrainManager sharedInstance].currentProject.pid;
    self.filterRequest.w = [YXTrainManager sharedInstance].currentProject.w;
    [self startLoading];
    WEAK_SELF
    [self.filterRequest startRequestWithRetClass:[ActivityFilterRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            self.filterErrorView.frame = self.view.bounds;
            [self.view addSubview:self.filterErrorView];
            return;
        }
        [self.filterErrorView removeFromSuperview];
        ActivityFilterRequestItem *item = (ActivityFilterRequestItem *)retItem;
        self.filterModel = [item filterModel];
        self.isWaitingForFilter = NO;
        if (self.stageID) {//因为server端无法做到"全部"时返回全部的活动,暂时解决方案:从任务跳转时默认选中"第一阶段"
            ActivityListFetcher *fetcher = (ActivityListFetcher *)self.dataFetcher;
            fetcher.stageid = self.stageID;
        } else {
            ActivityFilterGroup *stageGroup = self.filterModel.groupArray.lastObject;            ActivityFilter *filter = stageGroup.filterArray.firstObject;
            self.stageID = filter.filterID;
            ActivityListFetcher *fetcher = (ActivityListFetcher *)self.dataFetcher;
            fetcher.stageid = self.stageID;
        }
        [self firstPageFetch:YES];
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
    ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityListCell"];
    cell.activity = self.dataArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104;
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
    }
    // 学科
    NSNumber *num1 = filterArray[1];
    ActivityFilterGroup *group1 = self.filterModel.groupArray[1];
    ActivityFilter *studyItem = [[ActivityFilter alloc]init];
    if (group0.filterArray.count > 0) {
        studyItem = group1.filterArray[num1.integerValue];
    }
    // 阶段
    NSNumber *num2 = filterArray[2];
    ActivityFilterGroup *group2 = self.filterModel.groupArray[2];
    ActivityFilter *stageItem = [[ActivityFilter alloc]init];
    if (group2.filterArray.count > 0) {
        stageItem = group2.filterArray[num2.integerValue];
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
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(64);
            }];
            DDLogDebug(@"隐藏");
            self.isNavBarHidden = YES;
        }else if (point.y < 5 && self.isNavBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            self.filterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
            [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.top.mas_equalTo(44);
            }];
            DDLogDebug(@"显示");
            self.isNavBarHidden = NO;
        }
    }else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.filterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(44);
        }];
        self.isNavBarHidden = NO;
    }
}
@end

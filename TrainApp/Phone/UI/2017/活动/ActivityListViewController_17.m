//
//  ActivityListViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/19.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ActivityListViewController_17.h"
#import "ActivityListFetcher.h"
#import "ActivityListCell_17.h"
#import "ActivityFilterRequest.h"
#import "ActivityFilterModel.h"
#import "ActivityDetailViewController.h"
#import "ActivityListFilterView_17.h"
#import "ActivityListHeaderView_17.h"
@interface ActivityListViewController_17 ()
@property (nonatomic, strong) ActivityFilterRequest *filterRequest;
@property (nonatomic, strong) ActivityFilterModel *filterModel;
@property (nonatomic, strong) ActivityListFilterView_17 *filterView;
@property (nonatomic, strong) YXErrorView *filterErrorView;
@property (nonatomic, strong) ActivityListRequestItem_body_scheme *schemeItem;
@end

@implementation ActivityListViewController_17

- (void)viewDidLoad {
    [self setupFetcher];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark - setupUI
- (void)setupUI {
    self.emptyView.title = @"没有符合条件的活动";
    self.emptyView.imageName = @"没有符合条件的课程";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ActivityListCell_17 class] forCellReuseIdentifier:@"ActivityListCell_17"];
    [self.tableView registerClass:[ActivityListHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"ActivityListHeaderView_17"];
    
    if (self.isWaitingForFilter) {
        self.filterErrorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
        WEAK_SELF
        self.filterErrorView.retryBlock = ^{
            STRONG_SELF
            [self allFilters];
        };
        [self allFilters];
    }
     [self setupObservers];
}
- (void)setupObservers{
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kYXTrainParticipateActivity object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSString *aid = noti.userInfo.allKeys.firstObject;
        [self.dataArray enumerateObjectsUsingBlock:^(ActivityListRequestItem_body_activity  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ActivityListRequestItem_body_activity *activity = (ActivityListRequestItem_body_activity *)obj;
            if ([activity.aid isEqualToString:aid]) {
                if (activity.isJoin.integerValue == 0) {
                    obj.isJoin = @"1";
                    self.schemeItem.process.userFinishNum = [NSString stringWithFormat:@"%ld",self.schemeItem.process.userFinishNum.integerValue + 1];
                    ActivityListHeaderView_17 *headerView = (ActivityListHeaderView_17 *)[self.tableView headerViewForSection:0];
                    headerView.scheme = self.schemeItem;
                    [self.tableView reloadData];
                }
                *stop = YES;
            }
        }];
    }];
}
- (void)setupFetcher {
    ActivityListFetcher *fetcher = [[ActivityListFetcher alloc]init];
    fetcher.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    fetcher.stageid = self.stageID;
    fetcher.pageindex = 0;
    fetcher.pagesize = 10;
    WEAK_SELF
    fetcher.listCompleteBlock = ^(ActivityListRequestItem_body_scheme *scheme) {
        STRONG_SELF
        self.schemeItem = scheme;
        if (self.filterView == nil) {
            [self dealWithFilterModel:self.filterModel];
        }
    };
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
}
- (void)dealWithFilterModel:(ActivityFilterModel *)model {
    self.filterView = [[ActivityListFilterView_17 alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    WEAK_SELF
    self.filterView.activityListFilterSelectedBlock = ^(NSMutableArray *selectedArray) {
        STRONG_SELF
        ActivityListFetcher *fetcher = (ActivityListFetcher *)self.dataFetcher;
        fetcher.studyid = selectedArray[1];
        fetcher.segid = selectedArray[0];
        [self startLoading];
        [self firstPageFetch];        
    };
    [self.view addSubview:self.filterView];
    self.filterView.filterModel = model;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(30.0f);
    }];
}


- (void)allFilters {
    [self.filterRequest stopRequest];
    self.filterRequest = [[ActivityFilterRequest alloc]init];
    self.filterRequest.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    self.filterRequest.w = [LSTSharedInstance sharedInstance].trainManager.currentProject.w;
    [self startLoading];
    WEAK_SELF
    [self.filterRequest startRequestWithRetClass:[ActivityFilterRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self stopLoading];
            self.filterErrorView.frame = self.view.bounds;
            [self.view addSubview:self.filterErrorView];
            return;
        }
        [self.filterErrorView removeFromSuperview];
        ActivityFilterRequestItem *item = (ActivityFilterRequestItem *)retItem;
        self.filterModel = [item filterModel];
        self.isWaitingForFilter = NO;
        ActivityListFetcher *fetcher = (ActivityListFetcher *)self.dataFetcher;
        fetcher.stageid = self.stageID;
        fetcher.studyid = item.body.defaultChoose.studyId;
        fetcher.segid = item.body.defaultChoose.segmentId;
        [self startLoading];
        [self firstPageFetch];
    }];
}
- (void)firstPageFetch {
    if (self.isWaitingForFilter) {
        return;
    }
    [super firstPageFetch];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count > 0 ? 1 : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityListCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityListCell_17"];
    cell.activity = self.dataArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ActivityListHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ActivityListHeaderView_17"];
    headerView.scheme = self.schemeItem;
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ActivityListCell_17 *cell = [tableView cellForRowAtIndexPath:indexPath];
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
@end

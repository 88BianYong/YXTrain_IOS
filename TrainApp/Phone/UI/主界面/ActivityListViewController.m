//
//  ActivityListViewController.m
//  TrainApp
//
//  Created by ZLL on 2016/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityFilterView.h"
#import "ActivityListFetcher.h"
#import "ActivityListCell.h"
#import "ActivityFilterRequest.h"
#import "ActivityFilterModel.h"

@interface ActivityListViewController ()<ActivityFilterViewDelegate>
@property (nonatomic, strong) ActivityFilterView *filterView;
@property (nonatomic, strong) ActivityFilterModel *filterModel;
@property (nonatomic, strong) ActivityFilterRequest *filterRequest;
@property (nonatomic, assign) BOOL isWaitingForFilter;
@property (nonatomic, strong) YXErrorView *filterErrorView;
@property (nonatomic, assign) BOOL isNavBarHidden;
@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [self setupFetcher];
    YXEmptyView *emptyView = [[YXEmptyView alloc]init];
    emptyView.title = @"没有符合条件的活动";
    emptyView.imageName = @"没有符合条件的课程";
    self.emptyView = emptyView;
    if (self.status != ActivityFromStatus_Activity) {
        self.isWaitingForFilter = YES;
    }
    [super viewDidLoad];
    [self setupUI];
    [self getFilters];
}
- (void)setupFetcher {
    ActivityListFetcher *fetcher = [[ActivityListFetcher alloc]init];
    fetcher.pid = [YXTrainManager sharedInstance].currentProject.pid;
    fetcher.stageid = self.stageID;
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
}
- (void)setupUI {
    self.title = @"活动列表";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ActivityListCell class] forCellReuseIdentifier:@"ActivityListCell"];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(44);
    }];
    [self.emptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.right.bottom.mas_equalTo(0);
    }];
    if (self.isWaitingForFilter) {
        self.filterErrorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
        WEAK_SELF
        self.filterErrorView.retryBlock = ^{
            STRONG_SELF
            [self getFilters];
        };
        [self getFilters];
    }
}
- (void)getFilters {
    [self.filterRequest stopRequest];
    self.filterRequest = [[ActivityFilterRequest alloc]init];
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
        [self dealWithFilterModel:self.filterModel];
        self.isWaitingForFilter = NO;
        [self firstPageFetch:YES];
    }];
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

- (void)dealWithFilterModel:(ActivityFilterModel *)model {
    ActivityFilterView *filterView = [[ActivityFilterView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
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
    self.filterView = filterView;
}
- (void)setupWithCurrentFilters {
    if (self.stageID) {
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
    DDLogDebug(@"跳转到活动详情页面");
}
#pragma mark - YXCourseFilterViewDelegate
- (void)filterChanged:(NSArray *)filterArray {
    // 学段
    NSNumber *num0 = filterArray[0];
    ActivityFilterGroup *group0 = self.filterModel.groupArray[0];
    ActivityFilter *segmentItem = group0.filterArray[num0.integerValue];
    // 学科
    NSNumber *num1 = filterArray[1];
    ActivityFilterGroup *group1 = self.filterModel.groupArray[1];
    ActivityFilter *studyItem = group1.filterArray[num1.integerValue];
    // 阶段
    NSNumber *num2 = filterArray[2];
    ActivityFilterGroup *group2 = self.filterModel.groupArray[2];
    ActivityFilter *stageItem = group2.filterArray[num2.integerValue];
    
    DDLogDebug(@"Changed: 学段:%@，学科:%@，阶段:%@",segmentItem.name,studyItem.name,stageItem.name);
    ActivityListFetcher *fetcher = (ActivityListFetcher *)self.dataFetcher;
    fetcher.studyid = studyItem.filterID;
    fetcher.segid = segmentItem.filterID;
    fetcher.stageid = stageItem.filterID;
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

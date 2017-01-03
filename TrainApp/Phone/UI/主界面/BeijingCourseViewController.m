//
//  BeijingCourseViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//
#import "YXCourseFilterView.h"
#import "BeijingCourseListFetcher.h"
#import "BeijingCourseListCell.h"
#import "YXCourseDetailViewController.h"
#import "YXCourseRecordViewController.h"
#import "BeijingCourseFilterManager.h"
#import "BeijingCourseViewController.h"
static  NSString *const trackPageName = @"课程列表页面";

@interface BeijingCourseViewController ()<YXCourseFilterViewDelegate>
@property (nonatomic, strong) YXCourseFilterView *filterView;
@property (nonatomic, strong) BeijingCourseFilterModel *filterModel;
@property (nonatomic, strong) BeijingCourseFilterManager *filterRequest;
@property (nonatomic, assign) BOOL isWaitingForFilter;
@property (nonatomic, strong) YXErrorView *filterErrorView;
@property (nonatomic, strong) DataErrorView *filterDataErrorView;
@property (nonatomic, assign) BOOL isNavBarHidden;
@property (nonatomic, assign) BOOL isRefreshStudys;
@property (nonatomic, assign) NSInteger lastChooseStudys;

@property (nonatomic, assign) CGFloat oldOffsetY;
@property (nonatomic, assign) BOOL isAllowChange;
@end

@implementation BeijingCourseViewController
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    BeijingCourseListFetcher *fetcher = [[BeijingCourseListFetcher alloc]init];
    fetcher.pid = [YXTrainManager sharedInstance].currentProject.pid;
    fetcher.w = [YXTrainManager sharedInstance].currentProject.w;
    fetcher.stageid = self.stageID;
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    self.isAllowChange = YES;
    self.isWaitingForFilter = YES;
    // Do any additional setup after loading the view.
    self.emptyView.title = @"没有符合条件的课程";
    self.emptyView.imageName = @"没有符合条件的课程";
    self.title = @"课程列表";
    [self setupRightWithTitle:@"看课记录"];
    [self setupObservers];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 104.0f;
    [self.tableView registerClass:[BeijingCourseListCell class] forCellReuseIdentifier:@"BeijingCourseListCell"];
    self.filterErrorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
    WEAK_SELF
    self.filterErrorView.retryBlock = ^{
        STRONG_SELF
        [self getFilters];
    };
    self.filterDataErrorView = [[DataErrorView alloc] initWithFrame:self.view.bounds];
    self.filterDataErrorView.refreshBlock = ^ {
        STRONG_SELF
        [self getFilters];
    };
    [self getFilters];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    if (self.isNavBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getFilters{
    self.filterRequest = [[BeijingCourseFilterManager alloc] init];
    [self startLoading];
    WEAK_SELF
    [self.filterRequest startRequestCourseFilterItemWithBlock:^(BeijingCourseFilterModel *model, NSError *error) {
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
        BeijingCourseListFetcher *fetcher = (BeijingCourseListFetcher *)self.dataFetcher;
        fetcher.segid = self.filterModel.segment[0].filterID;
        fetcher.studyid = self.filterModel.study[0].filterID;
        fetcher.stageid = self.filterModel.stage[0].filterID;
        [self resetFilterConditionsStage:self.stageID];
        [self firstPageFetch];
    }];
}
- (void)resetFilterConditionsStage:(NSString *)filterId{
    if (filterId == nil) {
        return;
    }
    __block NSInteger stageIndex = -1;
    [self.filterModel.stage enumerateObjectsUsingBlock:^(BeijingCourseFilter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([filterId isEqualToString:obj.filterID]) {
            stageIndex = idx;
            *stop = YES;
        }
    }];
    if (stageIndex >= 0) {
        [self.filterView setCurrentIndex:stageIndex forKey:self.filterModel.stageName];
    }
}
- (void)dealWithFilterModel:(BeijingCourseFilterModel *)body {
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
    for (BeijingCourseFilter *filter in filters) {
        [array addObject:filter.name];
    }
    [self.filterView addFilters:array forKey:key];
    if (![array[0] isEqualToString:@"全部"]) {
        [self.filterView setCurrentIndex:0 forKey:key];
    }
}
- (void)refreshDealWithFilterModel{
    NSMutableArray *array = [NSMutableArray array];
    for (BeijingCourseFilter *filter in self.filterModel.study) {
        [array addObject:filter.name];
    }
    [self.filterView refreshStudysFilters:array forKey:self.filterModel.studyName];
}
- (void)setupObservers{
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:kRecordReportSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSString *course_id = noti.userInfo.allKeys.firstObject;
        NSString *record = noti.userInfo[course_id];
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YXCourseListRequestItem_body_module_course *course = (YXCourseListRequestItem_body_module_course *)obj;
            if ([course.courses_id isEqualToString:course_id]) {
                course.record = record;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                *stop = YES;
            }
        }];
    }];
}

- (void)naviRightAction{
    YXCourseRecordViewController *vc = [[YXCourseRecordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BeijingCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeijingCourseListCell"];
    cell.course = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"BeijingCourseListCell" configuration:^(BeijingCourseListCell *cell) {
        cell.course = self.dataArray[indexPath.row];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXCourseListRequestItem_body_module_course *course = self.dataArray[indexPath.row];
    YXCourseDetailViewController *vc = [[YXCourseDetailViewController alloc]init];
    vc.course = course;
    vc.isFromRecord = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - YXCourseFilterViewDelegate
- (void)filterChanged:(NSArray *)filterArray{
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
    BeijingCourseListFetcher *fetcher = (BeijingCourseListFetcher *)self.dataFetcher;
    //服务端数据返回空的处理:"0"-全部,即不做筛选
    if (self.filterModel.segment.count >0){
        fetcher.segid = self.filterModel.segment[num0.integerValue].filterID?:@"0";
    }
    if (self.filterModel.study.count > 0) {
        fetcher.studyid = self.filterModel.study[num1.integerValue].filterID?:@"0";
    }
    if (self.filterModel.stage.count) {
        fetcher.stageid = self.filterModel.stage[num2.integerValue].filterID?:@"0";
    }
    [self startLoading];
    [self firstPageFetch];
}
#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentSize.height >= kScreenHeight -  44 + 10.0f){
        if (scrollView.contentSize.height - self.tableView.bounds.size.height < self.oldOffsetY && self.isAllowChange) {//滚动底部一直隐藏状态栏
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
        self.isNavBarHidden = NO;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.filterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(44);
        }];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.oldOffsetY = MAX(scrollView.contentOffset.y, 0.0f);
    self.isAllowChange = YES;
}
@end

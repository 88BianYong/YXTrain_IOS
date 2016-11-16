//
//  ActivityDetailViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityDetailTableHeaderView.h"
#import "ActivityDetailTableSectionView.h"
#import "ActivityDetailStepCell.h"
#import "ActivityStepListRequest.h"
#import "ActivityStepViewController.h"
@interface ActivityDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ActivityDetailTableHeaderView *headerView;

@property (nonatomic, strong) ActivityStepListRequest *stepListRequest;
@property (nonatomic, strong) ActivityStepListRequestItem *listItem;
@end

@implementation ActivityDetailViewController
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动";
    [self setupUI];
    [self setupLayout];
    [self requestForActivityStepList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ActivityDetailTableSectionView class] forHeaderFooterViewReuseIdentifier:@"ActivityDetailTableSectionView"];
    [self.tableView registerClass:[ActivityDetailStepCell class] forCellReuseIdentifier:@"ActivityDetailStepCell"];
    self.headerView = [[ActivityDetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 355 + 300.0)];
    WEAK_SELF
    [self.headerView setActivityHtmlOpenAndCloseBlock:^(BOOL isStatus) {
        STRONG_SELF
        if (isStatus) {
            [UIView animateWithDuration:0.3 animations:^{
                self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 355.0f + self.headerView.htmlHeight);
                self.tableView.tableHeaderView = self.headerView;
                [self.headerView relayoutHtmlText];
            }];
        }else {
            [self.tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 355.0f + 300.0f);
            self.tableView.tableHeaderView = self.headerView;
            [self.headerView relayoutHtmlText];
        }
    }];
    [self.headerView setActivityHtmlHeightChangeBlock:^(BOOL height) {
        STRONG_SELF
        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 355.0f + self.headerView.htmlHeight);
        self.tableView.tableHeaderView = self.headerView;
        [self.headerView relayoutHtmlText];
    }];
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 73.0f;
    }else {
        return 15.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ActivityDetailTableSectionView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ActivityDetailTableSectionView"];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ActivityListRequestItem_Body_Activity_Steps *step = self.listItem.body.active.steps[indexPath.section];
    ActivityStepViewController *VC = [[ActivityStepViewController alloc] init];
    VC.activityStep = step;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listItem.body.active.steps.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityDetailStepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityDetailStepCell" forIndexPath:indexPath];
    cell.steps = self.listItem.body.active.steps[indexPath.section];
    return cell;
}

#pragma mark - request
- (void)requestForActivityStepList{
    if (self.stepListRequest) {
        [self.stepListRequest stopRequest];
    }
    ActivityStepListRequest *request = [[ActivityStepListRequest alloc] init];
    request.aid = self.activity.aid;
    request.source = self.activity.source;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[ActivityStepListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF;
        [self stopLoading];
        self.listItem = (ActivityStepListRequestItem *)retItem;
        self.listItem.body.active.joinUserCount = self.activity.joinUserCount;
        self.listItem.body.active.studyName = self.activity.studyName;
        self.listItem.body.active.segmentName = self.activity.segmentName;
        self.headerView.activity = self.listItem.body.active;
        self.tableView.tableHeaderView = self.headerView;
        [self.tableView reloadData];
    }];
    self.stepListRequest = request;
}
@end

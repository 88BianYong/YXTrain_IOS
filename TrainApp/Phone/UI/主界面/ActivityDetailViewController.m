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
@interface ActivityDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ActivityDetailTableHeaderView *headerView;

@property (nonatomic, strong) ActivityStepListRequest *stepListRequest;
@property (nonatomic, strong) ActivityStepListRequestItem *listItem;
@end

@implementation ActivityDetailViewController

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
    self.headerView = [[ActivityDetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 620)];
    self.headerView.activity = self.activity;
    WEAK_SELF
    [self.headerView setActivityHtmlOpenAndCloseBlock:^(BOOL isStatus) {
        STRONG_SELF
        if (isStatus) {
            [UIView animateWithDuration:0.3 animations:^{
                self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 1900);
                self.tableView.tableHeaderView = self.headerView;
                [self.headerView relayoutHtmlText];
            }];
        }else {
            [self.tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 620);
            self.tableView.tableHeaderView = self.headerView;
            [self.headerView relayoutHtmlText];
        }
    }];
    self.tableView.tableHeaderView = self.headerView;
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
    NSString *string = @"ActivityPlayViewController";
    UIViewController *VC = [[NSClassFromString(string) alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityDetailStepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityDetailStepCell" forIndexPath:indexPath];
    cell.stepContent = self.listItem.body.steps[indexPath.section];
    return cell;
}

#pragma mark - request
- (void)requestForActivityStepList{
    if (self.stepListRequest) {
        [self.stepListRequest stopRequest];
    }
    ActivityStepListRequest *request = [[ActivityStepListRequest alloc] init];
    request.aid = self.activity.aid;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[ActivityStepListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF;
        [self stopLoading];
        self.listItem = (ActivityStepListRequestItem *)retItem;
        [self.tableView reloadData];
    }];
    self.stepListRequest = request;
}
@end

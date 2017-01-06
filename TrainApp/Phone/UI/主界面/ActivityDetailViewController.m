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
#import "ActivityDetailManger.h"
#import "ActivityStepViewController.h"
@interface ActivityDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ActivityDetailTableHeaderView *headerView;

@property (nonatomic, strong) ActivityDetailManger *detailManger;
@property (nonatomic, strong) ActivityListDetailModel *detailModel;
@end

@implementation ActivityDetailViewController
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.activity.title;
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
    self.headerView = [[ActivityDetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 335 + kTableViewHeaderFixedHeight)];
    WEAK_SELF
    [self.headerView setActivityHtmlOpenAndCloseBlock:^(BOOL isStatus) {
        STRONG_SELF
        if (isStatus) {
            [UIView animateWithDuration:0.3 animations:^{
                self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kTableViewHeaderFixedHeight + self.headerView.changeHeight);
                self.tableView.tableHeaderView = self.headerView;
                [self.headerView relayoutHtmlText];
            }];
        }else {
            [self.tableView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kTableViewHeaderFixedHeight + kTableViewHeaderHtmlPlaceholdeHeight);
            self.tableView.tableHeaderView = self.headerView;
            [self.headerView relayoutHtmlText];
        }
    }];
    [self.headerView setActivityHtmlHeightChangeBlock:^(CGFloat htmlHeight, CGFloat labelHeight) {
        STRONG_SELF
        if (htmlHeight < kTableViewHeaderHtmlPlaceholdeHeight) {
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kTableViewHeaderFixedHeight - kTableViewHeaderOpenAndCloseHeight + htmlHeight + labelHeight);
        }else {
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kTableViewHeaderFixedHeight + kTableViewHeaderHtmlPlaceholdeHeight + labelHeight);
        }
        self.tableView.tableHeaderView = self.headerView;
        [self.headerView relayoutHtmlText];
    }];
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForActivityStepList];
    };
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self requestForActivityStepList];
    };
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 73.0 + 8.0f;
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
    if (self.detailModel.status.integerValue > 0) {
        ActivityStepViewController *VC = [[ActivityStepViewController alloc] init];
        VC.activityStep = self.detailModel.steps[indexPath.section];
        VC.status = self.detailModel.status;
        VC.stageId = self.detailModel.stageId;
        [self.navigationController pushViewController:VC animated:YES];
    }else {
        [self showToast:@"活动尚未开始"];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.detailModel.steps.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityDetailStepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityDetailStepCell" forIndexPath:indexPath];
    cell.steps = self.detailModel.steps[indexPath.section];
    return cell;
}

#pragma mark - request
- (void)requestForActivityStepList{
    ActivityDetailManger *request = [[ActivityDetailManger alloc] init];
    [self startLoading];
    WEAK_SELF
    [request startRequestActivityListItem:self.activity WithBlock:^(ActivityListDetailModel * model, NSError *error){
        STRONG_SELF;
        [self stopLoading];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        self.detailModel = model;
        self.headerView.model = self.detailModel;
        self.tableView.tableHeaderView = self.headerView;
        [self.tableView reloadData];
        
    }];
    self.detailManger = request;
}
@end

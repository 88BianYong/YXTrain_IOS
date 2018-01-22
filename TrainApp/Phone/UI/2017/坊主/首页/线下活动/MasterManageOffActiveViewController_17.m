//
//  MasterManageOffActiveViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManageOffActiveViewController_17.h"
#import "MasterManageOffActiveFetcher_17.h"
#import "MasterOffActiveListTableHeaderView_17.h"
#import "MasterManageOffActiveListCell_17.h"
#import "MasterManageOffActiveDetailViewController_17.h"
@interface MasterManageOffActiveViewController_17 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) MasterOffActiveListTableHeaderView_17 *headerView;

@end

@implementation MasterManageOffActiveViewController_17

- (void)viewDidLoad {
    [self setupFetcher];
    [super viewDidLoad];
    self.navigationItem.title = @"线下活动";
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:@"线下活动列表" withStatus:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:@"线下活动列表" withStatus:NO];
}
#pragma mark - setupUI
- (void)setupUI {
    self.emptyView.title = @"没有符合条件的活动";
    self.emptyView.imageName = @"没有符合条件的课程";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[MasterManageOffActiveListCell_17 class] forCellReuseIdentifier:@" MasterManageOffActiveListCell_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    self.headerView = [[MasterOffActiveListTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 198.0f)];
    WEAK_SELF
    self.headerView.masterActiveButtonBlock = ^(UIButton *sender) {
        STRONG_SELF
        CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
        [self showMarkWithOriginRect:rect explain:self.headerView.scheme.descripe?:@""];
        [YXDataStatisticsManger trackEvent:@"考核说明" label:@"线下活动" parameters:nil];
    };
    self.tableView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
}

- (void)showMarkWithOriginRect:(CGRect)rect explain:(NSString *)string {
    MasterMyExamExplainView_17 *v = [[MasterMyExamExplainView_17 alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    [v setupOriginRect:rect];
}
- (void)tableViewWillRefresh {
    self.headerView.hidden = NO;
    self.emptyView.hidden = YES;
}

- (void)setupFetcher {
    MasterManageOffActiveFetcher_17 *fetcher = [[MasterManageOffActiveFetcher_17 alloc] init];
    fetcher.pageindex = 0;
    fetcher.pagesize = 20;
    WEAK_SELF
    fetcher.masterManageOffActiveBlock = ^(MasterManagerSchemeItem *scheme) {
        STRONG_SELF
        self.headerView.scheme = scheme;
        if (scheme.score.integerValue == 0) {
            self.emptyHidden = NO;
            self.tableView.tableHeaderView = nil;
        }else {
            self.emptyHidden = YES;
            self.tableView.tableHeaderView = self.headerView;
        }
    };
    self.dataFetcher = fetcher;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterManageOffActiveListCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@" MasterManageOffActiveListCell_17" forIndexPath:indexPath];
    cell.active = self.dataArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 104.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXSectionHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        MasterManageOffActiveItem_Body_Active *active = self.dataArray[indexPath.row];
        MasterManageOffActiveDetailViewController_17 *VC = [[MasterManageOffActiveDetailViewController_17 alloc] init];
        VC.activeId = active.activeId;
        VC.titleString = active.title;
        [self.navigationController pushViewController:VC animated:YES];
}
@end

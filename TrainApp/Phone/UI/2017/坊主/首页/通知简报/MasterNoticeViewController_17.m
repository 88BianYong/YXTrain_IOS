//
//  MasterNoticeViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterNoticeViewController_17.h"
#import "MasterManageNoticeFetcher_17.h"
#import "MasterManageNoticeRequest_17.h"
#import "MasterNoticeBriefCell_17.h"
#import "NoticeAndBriefDetailViewController.h"
@interface MasterNoticeViewController_17 ()
@end

@implementation MasterNoticeViewController_17

- (void)viewDidLoad {
    self.bIsGroupedTableViewStyle = YES;
    MasterManageNoticeFetcher_17 *fetcher = [[MasterManageNoticeFetcher_17 alloc] init];
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    self.navigationItem.title = @"通知管理";
    [self startLoading];
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:@"通知列表" withStatus:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:@"通知列表" withStatus:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - setup
- (void)setupUI {
    self.emptyView.imageName = @"暂无通知";
    self.emptyView.title = @"暂无通知";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MasterNoticeBriefCell_17 class] forCellReuseIdentifier:@"MasterNoticeBriefCell_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MasterNoticeBriefCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterNoticeBriefCell_17" forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MasterNoticeBriefItem *item = self.dataArray[indexPath.row];
    NoticeAndBriefDetailViewController *VC = [[NoticeAndBriefDetailViewController alloc] init];
    VC.nbIdString = item.nbId;
    VC.titleString = item.title;
    VC.detailFlag = NoticeAndBriefFlag_Notice;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"MasterNoticeBriefCell_17" configuration:^(MasterNoticeBriefCell_17 *cell) {
        cell.item = self.dataArray[indexPath.row];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXSectionHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return headerView;
}
@end

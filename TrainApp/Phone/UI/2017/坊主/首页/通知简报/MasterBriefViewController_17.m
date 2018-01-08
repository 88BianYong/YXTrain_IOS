//
//  MasterBriefViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterBriefViewController_17.h"
#import "MasterBriefHeaderView_17.h"
#import "MasterManageBriefFetcher_17.h"
#import "MasterManageBriefRequest_17.h"
#import "MasterNoticeBriefCell_17.h"
#import "NoticeAndBriefDetailViewController.h"
@interface MasterBriefViewController_17 ()
@property (nonatomic, strong) MasterBriefHeaderView_17 *headerView;
@property (nonatomic, strong) MasterNoticeBriefScheme *scheme;
@end

@implementation MasterBriefViewController_17

- (void)viewDidLoad {
    MasterManageBriefFetcher_17 *fetcher = [[MasterManageBriefFetcher_17 alloc] init];
    WEAK_SELF
    fetcher.masterBriefSchemeBlock = ^(MasterNoticeBriefScheme *scheme) {
        STRONG_SELF
        self.headerView.scheme = scheme;
        if (scheme.score.integerValue == 0) {
            self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 5.0f);
        }else {
            self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 202);
        }
        self.tableView.tableHeaderView = self.headerView;
    };
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    self.navigationItem.title = @"简报管理";
    [self startLoading];
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:@"简报列表" withStatus:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:@"简报列表" withStatus:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - setup
- (void)setupUI {
    self.emptyView.imageName = @"暂无简报";
    self.emptyView.title = @"暂无简报";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MasterNoticeBriefCell_17 class] forCellReuseIdentifier:@"MasterNoticeBriefCell_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    self.headerView = [[MasterBriefHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 202.0f)];
    WEAK_SELF
    self.headerView.masterBriefButtonBlock = ^(UIButton *sender) {
        STRONG_SELF
               CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
         [self showMarkWithOriginRect:rect explain:self.headerView.scheme.descripe?:@""];
        [YXDataStatisticsManger trackEvent:@"考核说明" label:@"简报列表" parameters:nil];
    };
    self.headerView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
}
- (void)showMarkWithOriginRect:(CGRect)rect explain:(NSString *)string {
    MasterMyExamExplainView_17 *v = [[MasterMyExamExplainView_17 alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    [v setupOriginRect:rect];
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
    VC.detailFlag = NoticeAndBriefFlag_Brief;
   [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"MasterNoticeBriefCell_17" configuration:^(MasterNoticeBriefCell_17 *cell) {
        cell.item = self.dataArray[indexPath.row];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXSectionHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return headerView;
}
@end

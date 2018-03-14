//
//  NoticeViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeListViewController_17.h"
#import "YXNoticeListFetch.h"
#import "YXBroseWebView.h"
#import "NoticeBriefCell_17.h"
#import "NoticeAndBriefDetailViewController.h"
@interface NoticeListViewController_17 ()

@end

@implementation NoticeListViewController_17

- (void)viewDidLoad {
    self.bIsGroupedTableViewStyle = YES;
    YXNoticeListFetch *fetcher = [[YXNoticeListFetch alloc] init];
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    [self startLoading];
    [self setupUI];
    [self setupLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup
- (void)setupUI {
    self.emptyView.imageName = @"暂无通知";
    self.emptyView.title = @"暂无通知";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NoticeBriefCell_17 class] forCellReuseIdentifier:@"NoticeBriefCell_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10.0f)];
    self.tableView.tableFooterView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
}
- (void)setupLayout {
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count > 0 ? 1 : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeBriefCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeBriefCell_17" forIndexPath:indexPath];
    BOOL isFirstOne = indexPath.row == 0 ?YES :NO;
    BOOL isLastOne = indexPath.row == self.dataArray.count -1 ?YES :NO;
    [cell configUIwithItem:self.dataArray[indexPath.row] isFirstOne:isFirstOne isLastOne:isLastOne];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXNoticeAndBulletinItem *item = self.dataArray[indexPath.row];
    if (item.isExtendUrl.boolValue) {
        YXNoticeAndBulletinItem *item = self.dataArray[indexPath.row];
        YXBroseWebView *webView = [[YXBroseWebView alloc] init];
        webView.urlString = item.url;
        webView.titleString = item.title;
        webView.sourceControllerTitile = self.title;
        [self.navigationController pushViewController:webView animated:YES];
    }else {
        NoticeAndBriefDetailViewController *VC = [[NoticeAndBriefDetailViewController alloc] init];
        VC.nbIdString = item.nbID;
        VC.titleString = item.title;
        VC.detailFlag = NoticeAndBriefFlag_Notice;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXSectionHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    footerView.contentView.backgroundColor = [UIColor whiteColor];
    return footerView;
}

@end

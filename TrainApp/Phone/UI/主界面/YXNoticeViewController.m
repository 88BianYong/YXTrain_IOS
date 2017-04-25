//
//  YXNoticeViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/22.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXNoticeViewController.h"
#import "YXNoticeAndBulletinTableViewCell.h"
#import "YXNoticeListFetch.h"
#import "YXBriefListFetch.h"
#import "YXBroseWebView.h"
#import "NoticeAndBriefDetailViewController.h"
static  NSString *const trackNoticePageName = @"通知列表页面";
static  NSString *const trackBulletinPageName = @"简报列表页面";
@interface YXNoticeViewController ()
@property (nonatomic,assign) BOOL  isSelected;
@end

@implementation YXNoticeViewController

- (void)viewDidLoad {
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    if (self.flag == YXFlag_Notice) {
        self.emptyView.imageName = @"暂无通知";
        self.emptyView.title = @"暂无通知";
    }
    if (self.flag == YXFlag_Bulletin) {
        self.emptyView.imageName = @"暂无简报";
        self.emptyView.title = @"暂无简报";
    }
    if (self.flag == YXFlag_Notice) {
        self.title = @"通知";
        YXNoticeListFetch *fetcher = [[YXNoticeListFetch alloc] init];
        self.dataFetcher = fetcher;
    }
    if (self.flag == YXFlag_Bulletin) {
        self.title = @"简报";
        YXBriefListFetch *fetcher = [[YXBriefListFetch alloc] init];
        self.dataFetcher = fetcher;
    }
    self.isSelected = NO;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXNoticeAndBulletinTableViewCell class] forCellReuseIdentifier:@"YXNoticeAndBulletinTableViewCell"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.tableHeaderView = headerView;
    [self startLoading];
    [self firstPageFetch];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isSelected) {
        if (self.flag == YXFlag_Notice) {
            [YXDataStatisticsManger trackPage:trackNoticePageName withStatus:YES];
        }
        if (self.flag == YXFlag_Bulletin) {
            [YXDataStatisticsManger trackPage:trackBulletinPageName withStatus:YES];
        }
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isSelected) {
        if (self.flag == YXFlag_Notice) {
            [YXDataStatisticsManger trackPage:trackNoticePageName withStatus:NO];
        }
        if (self.flag == YXFlag_Bulletin) {
            [YXDataStatisticsManger trackPage:trackBulletinPageName withStatus:NO];
        }
    }
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXNoticeAndBulletinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXNoticeAndBulletinTableViewCell" forIndexPath:indexPath];
    BOOL isFirstOne = indexPath.section == 0 ?YES :NO;
    BOOL isLastOne = indexPath.section == self.dataArray.count -1 ?YES :NO;
    [cell configUIwithItem:self.dataArray[indexPath.section] isFirstOne:isFirstOne isLastOne:isLastOne];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
      YXNoticeAndBulletinItem *item = self.dataArray[indexPath.section];
    if (item.isExtendUrl.boolValue) {
        YXNoticeAndBulletinItem *item = self.dataArray[indexPath.section];
        YXBroseWebView *webView = [[YXBroseWebView alloc] init];
        webView.urlString = item.url;
        webView.titleString = item.title;
        webView.sourceControllerTitile = self.title;
        [self.navigationController pushViewController:webView animated:YES];
    }else {
        NoticeAndBriefDetailViewController *VC = [[NoticeAndBriefDetailViewController alloc] init];
        VC.nbIdString = item.nbID;
        VC.title = item.title;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 5.0f;
    }
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.dataArray.count -1 ) {
        return 40;
    }
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    } else {
        return [UIView new];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.dataArray.count - 1) {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    } else {
        return [UIView new];
    }
}
- (void)report:(BOOL)status{
    if (status) {
        self.isSelected = YES;
    }else{
        self.isSelected = NO;
    }
    if (self.flag == YXFlag_Notice) {
        [YXDataStatisticsManger trackPage:trackNoticePageName withStatus:status];
    }
    if (self.flag == YXFlag_Bulletin) {
        [YXDataStatisticsManger trackPage:trackBulletinPageName withStatus:status];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

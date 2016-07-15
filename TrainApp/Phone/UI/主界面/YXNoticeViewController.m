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

@interface YXNoticeViewController ()

@end

@implementation YXNoticeViewController

- (void)viewDidLoad {
    self.bIsGroupedTableViewStyle = YES;
    YXEmptyView *emptyView = [[YXEmptyView alloc]init];
    if (self.flag == YXFlag_Notice) {
        emptyView.imageName = @"暂无通知";
        emptyView.title = @"暂无通知";
    }
    if (self.flag == YXFlag_Bulletin) {
        emptyView.imageName = @"暂无简报";
        emptyView.title = @"暂无简报";
    }
    self.emptyView = emptyView;
    [super viewDidLoad];
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
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXNoticeAndBulletinTableViewCell class] forCellReuseIdentifier:@"YXNoticeAndBulletinTableViewCell"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.tableHeaderView = headerView;
    [self firstPageFetch];
    // Do any additional setup after loading the view.
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
    [cell configUIwithItem:self.dataArray[indexPath.section] isLastOne:indexPath.section == self.dataArray.count -1 ?YES :NO];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXNoticeAndBulletinItem *item = self.dataArray[indexPath.section];
    YXBroseWebView *webView = [[YXBroseWebView alloc] init];
    webView.urlString = item.url;
    webView.titleString = item.title;
    [self.navigationController pushViewController:webView animated:NO];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 5.0f;
    }
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.dataArray.count -1 ) {
        return 40;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];

        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
        [headerView addSubview:lineView];

        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(2);
            make.left.mas_equalTo(31);
        }];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MasterOffActiveParticipantViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOffActiveParticipantViewController_17.h"
#import "MasterOffActiveJoinUsersFetcher_17.h"
#import "MasterOffActiveJoinUsersRequest_17.h"
#import "MasterOffActiveParticipantCell_17.h"
@interface MasterOffActiveParticipantViewController_17 ()

@end

@implementation MasterOffActiveParticipantViewController_17


- (void)viewDidLoad {
    self.bIsGroupedTableViewStyle = YES;
    MasterOffActiveJoinUsersFetcher_17 *fetcher = [[MasterOffActiveJoinUsersFetcher_17 alloc] init];
    fetcher.aId = self.aId;
    self.dataFetcher = fetcher;
    [super viewDidLoad];
    [self startLoading];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - setup
- (void)setupUI {
    self.emptyView.title = @"暂无参与人";
    self.emptyView.imageName = @"没有符合条件的课程";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MasterOffActiveParticipantCell_17 class] forCellReuseIdentifier:@"MasterOffActiveParticipantCell_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
}
- (void)tableViewWillRefresh {
    NSString *string = @"参与人";
    if (self.total > 0) {
        string = [NSString stringWithFormat:@"参与人 (%ld)",(long)self.total];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadParticipantButton" object:string];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MasterOffActiveParticipantCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterOffActiveParticipantCell_17" forIndexPath:indexPath];
    cell.joinUser = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
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

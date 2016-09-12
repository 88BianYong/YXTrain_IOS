//
//  YXHotspotViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHotspotViewController.h"
#import "YXHotspotWordsCell.h"
#import "YXHotspotPictureCell.h"
#import "YXRotateListRequest.h"
#import "YXWebViewController.h"
#import "YXHotspotDatumFetch.h"
@interface YXHotspotViewController ()

@end

@implementation YXHotspotViewController

- (void)viewDidLoad {
    YXHotspotDatumFetch *fetcher = [[YXHotspotDatumFetch alloc] init];
    fetcher.pagesize = 10;
    self.dataFetcher = fetcher;
    YXEmptyView *emptyView = [[YXEmptyView alloc]init];
//    emptyView.title = @"暂无资源";
//    emptyView.imageName = @"暂无资源";
    self.emptyView = emptyView;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    self.title = @"热点";
    [self setupUI];
    [self layoutInterface];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"getRotateList_mock" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        NSError *error;
        YXRotateListRequestItem *requestItem = [[YXRotateListRequestItem alloc] initWithData:data error:&error];
        [self.dataArray addObjectsFromArray:requestItem.rotates];
        [self.tableView reloadData];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - setupUI
- (void)setupUI{
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.estimatedRowHeight = 30.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXHotspotWordsCell class] forCellReuseIdentifier:@"YXHotspotWordsCell"];
    [self.tableView registerClass:[YXHotspotPictureCell class] forCellReuseIdentifier:@"YXHotspotPictureCell"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5.0f)];
    self.tableView.tableHeaderView = headerView;
}

- (void)layoutInterface{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXRotateListRequestItem_Rotates *rotate = self.dataArray[indexPath.row];
    if (indexPath.row % 2 == 0) {
        YXHotspotWordsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHotspotWordsCell" forIndexPath:indexPath];
        cell.rotate = rotate;
        return cell;
    } else {
        YXHotspotPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHotspotPictureCell" forIndexPath:indexPath];
        cell.rotate = rotate;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YXRotateListRequestItem_Rotates *model = self.dataArray[indexPath.row];
    YXWebViewController *webView = [[YXWebViewController alloc] init];
    webView.urlString = model.typelink;
    webView.titleString = model.name;
    [self.navigationController pushViewController:webView animated:YES];
}
@end

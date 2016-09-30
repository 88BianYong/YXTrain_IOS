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
#import "YXWebViewController.h"
#import "YXHotspotDatumFetch.h"
#import "YXHotReadedRequest.h"
static  NSString *const trackPageName = @"热点列表页面";
@interface YXHotspotViewController ()
@property (nonatomic, strong) YXHotReadedRequest *readedRequest;
@property (nonatomic, assign) CGPoint contentPoint;
@end

@implementation YXHotspotViewController

- (void)viewDidLoad {
    YXHotspotDatumFetch *fetcher = [[YXHotspotDatumFetch alloc] init];
    fetcher.pagesize = 10;
    self.dataFetcher = fetcher;
    YXEmptyView *emptyView = [[YXEmptyView alloc]init];
    self.emptyView = emptyView;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    self.contentPoint = CGPointMake(0, 0);
    self.title = @"热点";
    [self setupUI];
    [self layoutInterface];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    DDLogDebug(@"%@",NSStringFromCGPoint(self.tableView.contentOffset));
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self.tableView setContentOffset:self.contentPoint animated:NO];
    DDLogDebug(@"%@",NSStringFromCGPoint(self.tableView.contentOffset));

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
    DDLogDebug(@"%@",NSStringFromCGPoint(self.tableView.contentOffset));
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    DDLogDebug(@"%@",NSStringFromCGPoint(self.tableView.contentOffset));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - setupUI
- (void)setupUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
//    self.tableView.estimatedRowHeight = 44.0f;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXHotspotWordsCell class] forCellReuseIdentifier:@"YXHotspotWordsCell"];
    [self.tableView registerClass:[YXHotspotPictureCell class] forCellReuseIdentifier:@"YXHotspotPictureCell"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5.0f)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.tableHeaderView = headerView;
}

- (void)layoutInterface{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count > 0 ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHotspotRequestItem_Data *data = self.dataArray[indexPath.row];
    if (isEmpty(data.picUrl)) {
        YXHotspotWordsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHotspotWordsCell" forIndexPath:indexPath];
        cell.data = data;
        return cell;
    } else {
        YXHotspotPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHotspotPictureCell" forIndexPath:indexPath];
        cell.data = data;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHotspotRequestItem_Data *data = self.dataArray[indexPath.row];
    if (isEmpty(data.picUrl)) {
        return [tableView fd_heightForCellWithIdentifier:@"YXHotspotWordsCell" configuration:^(YXHotspotWordsCell *cell) {
            cell.data = data;
        }];
    } else {
        return [tableView fd_heightForCellWithIdentifier:@"YXHotspotPictureCell" configuration:^(YXHotspotPictureCell *cell) {
            cell.data = data;
        }];
    }
}
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
    YXHotspotRequestItem_Data *data = self.dataArray[indexPath.row];
//    if (data.status.integerValue == 0) {
//        [self requestForHotspotReaded:data.hotspotId];
//    }
    YXWebViewController *webView = [[YXWebViewController alloc] init];
    webView.urlString = data.linkUrl;
    webView.titleString = data.title;
    [self.navigationController pushViewController:webView animated:YES];
    self.contentPoint = tableView.contentOffset;
}

#pragma mark - request
- (void)requestForHotspotReaded:(NSString *)hotspotId{
    if (self.readedRequest) {
        [self.readedRequest stopRequest];
    }
    YXHotReadedRequest *request = [[YXHotReadedRequest alloc] init];
    request.hotspotId = hotspotId;
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (!error) {
            HttpBaseRequestItem *item = retItem;
            if (item.code.integerValue == 0) {
                DDLogDebug(@"上报成功");
            }
        }
    }];
    self.readedRequest = request;
}
@end

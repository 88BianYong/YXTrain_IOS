//
//  YXDynamicViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXDynamicViewController.h"
#import "YXDynamicCell.h"
#import "YXDynamicDatumFetch.h"
#import "YXMsgReadedRequest.h"
#import "YXBroseWebView.h"
#import "YXHomeworkInfoViewController.h"
#import "YXHomeworkInfoRequest.h"
@interface YXDynamicViewController ()
@property (nonatomic, strong) YXMsgReadedRequest *readedRequest;
@end

@implementation YXDynamicViewController

- (void)viewDidLoad {
    YXDynamicDatumFetch *fetcher = [[YXDynamicDatumFetch alloc] init];
    fetcher.pagesize = 10;
    self.dataFetcher = fetcher;
    YXEmptyView *emptyView = [[YXEmptyView alloc]init];
    self.emptyView = emptyView;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    self.title = @"动态";
    [self setupUI];
    [self layoutInterface];
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
    [self.tableView registerClass:[YXDynamicCell class] forCellReuseIdentifier:@"YXDynamicCell"];
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
    YXDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXDynamicCell" forIndexPath:indexPath];
    YXDynamicRequestItem_Data *data = self.dataArray[indexPath.row];
    cell.data = data;
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
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
    YXDynamicRequestItem_Data *data = self.dataArray[indexPath.row];
    if (data.status.integerValue == 0) {
        [self requestForMagReaded:data.masgId andIndexPatch:indexPath];
    }
    switch (data.type.integerValue) {//1-通知  2-简报  3-打分  4-推优  5-任务到期提醒
        case 1:
        {
            YXBroseWebView *webView = [[YXBroseWebView alloc] init];
            webView.urlString = data.linkUrl;
            webView.titleString = data.projectName;
            [self.navigationController pushViewController:webView animated:NO];
        }
            break;
        case 2:
        {
            YXBroseWebView *webView = [[YXBroseWebView alloc] init];
            webView.urlString = data.linkUrl;
            webView.titleString = data.projectName;
            [self.navigationController pushViewController:webView animated:NO];
        }
            break;
        case 3:
        {
            YXHomeworkInfoRequestItem_Body *itemBody = [[YXHomeworkInfoRequestItem_Body alloc] init];
            itemBody.type = @"4";
            itemBody.requireId = @"";
            itemBody.homeworkid = data.objectId;
            itemBody.title = data.projectName;
            YXHomeworkInfoViewController *VC = [[YXHomeworkInfoViewController alloc] init];
            VC.itemBody = itemBody;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 4:
        {
            YXHomeworkInfoRequestItem_Body *itemBody = [[YXHomeworkInfoRequestItem_Body alloc] init];
            itemBody.type = @"4";
            itemBody.requireId = @"";
            itemBody.homeworkid = data.objectId;
            itemBody.title = data.projectName;
            YXHomeworkInfoViewController *VC = [[YXHomeworkInfoViewController alloc] init];
            VC.itemBody = itemBody;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 5:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainCurrentProjectIndex object:data.objectId];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - request
- (void)requestForMagReaded:(NSString *)masgId andIndexPatch:(NSIndexPath *)indexPath{
    if (self.readedRequest) {
        [self.readedRequest stopRequest];
    }
    YXMsgReadedRequest *request = [[YXMsgReadedRequest alloc] init];
    request.masgId = masgId;
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (!error) {
            HttpBaseRequestItem *item = retItem;
            if (item.code.integerValue == 0) {
                YXDynamicRequestItem_Data *data = self.dataArray[indexPath.row];
                data.status = @"1";
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
                DDLogDebug(@"上报成功");
            }
        }
    }];
    self.readedRequest = request;
}
@end

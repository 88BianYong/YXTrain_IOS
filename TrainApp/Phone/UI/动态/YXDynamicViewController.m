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
#import "NoticeAndBriefDetailViewController.h"
#import "TrainRedPointManger.h"
static  NSString *const trackPageName = @"消息动态列表页面";
@interface YXDynamicViewController ()
@property (nonatomic, strong) YXMsgReadedRequest *readedRequest;
@end

@implementation YXDynamicViewController

- (void)viewDidLoad {
    YXDynamicDatumFetch *fetcher = [[YXDynamicDatumFetch alloc] init];
    fetcher.pagesize = 10;
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.title = @"消息动态";
    [self setupUI];
    [self layoutInterface];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
}
- (void)naviLeftAction {
    [TrainRedPointManger sharedInstance].dynamicInteger = -1;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - setupUI
- (void)setupUI{
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
//    self.tableView.estimatedRowHeight = 30.0f;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXDynamicCell class] forCellReuseIdentifier:@"YXDynamicCell"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5.0f)];
    self.tableView.tableHeaderView = headerView;
}

- (void)layoutInterface{
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXDynamicRequestItem_Data *data = self.dataArray[indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:@"YXDynamicCell" configuration:^(YXDynamicCell *cell) {
        cell.data = data;
    }];
}
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
    [YXDataStatisticsManger trackEvent:@"消息动态跳转" label:@"点击消息成功跳转" parameters:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YXDynamicRequestItem_Data *data = self.dataArray[indexPath.row];
    if (data.status.integerValue == 0) {
        [self requestForMagReaded:data andIndexPatch:indexPath];
    }
    switch (data.type.integerValue) {//1-通知  2-简报  3-打分  4-推优  5-任务到期提醒
        case 1:
        {
            [self pushNextViewController:data];
        }
            break;
        case 2:
        {
            [self pushNextViewController:data];
        }
            break;
        case 3:
        {
            YXHomeworkInfoRequestItem_Body *itemBody = [[YXHomeworkInfoRequestItem_Body alloc] init];
            itemBody.type = @"4";
            itemBody.requireId = @"";
            itemBody.homeworkid = data.objectId;
            itemBody.title = data.projectName;
            itemBody.pid = data.projectId;
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
            itemBody.pid = data.projectId;
            YXHomeworkInfoViewController *VC = [[YXHomeworkInfoViewController alloc] init];
            VC.itemBody = itemBody;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 5:
        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainCurrentProjectIndex object:data.projectId];
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 6:
        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainCurrentProjectIndex object:data.projectId];
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)pushNextViewController:(YXDynamicRequestItem_Data *)data{
    if (data.isExtendUrl.boolValue) {
        YXBroseWebView *webView = [[YXBroseWebView alloc] init];
        webView.urlString = data.linkUrl;
        webView.titleString = data.projectName;
        webView.sourceControllerTitile = data.type.integerValue == 1 ? @"通知" : @"简报";
        [self.navigationController pushViewController:webView animated:YES];
    }else {
        NoticeAndBriefDetailViewController *VC = [[NoticeAndBriefDetailViewController alloc] init];
        VC.nbIdString = data.objectId;
        VC.titleString = data.title;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

#pragma mark - request
- (void)requestForMagReaded:(YXDynamicRequestItem_Data *)data andIndexPatch:(NSIndexPath *)indexPath{
    if (self.readedRequest) {
        [self.readedRequest stopRequest];
    }
    YXMsgReadedRequest *request = [[YXMsgReadedRequest alloc] init];
    request.msgId = data.msgId;
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (!error) {
            HttpBaseRequestItem *item = retItem;
            if (item.code.integerValue == 0 && data.type.integerValue != 5) {
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

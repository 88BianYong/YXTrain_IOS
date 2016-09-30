//
//  YXWorkshopViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopViewController.h"
#import "YXWorkshopCell.h"
#import "YXWorkshopDetailViewController.h"
#import "YXWorkshopListRequest.h"
static  NSString *const trackPageName = @"我的工作坊列表页面";
@interface YXWorkshopViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    YXErrorView *_errorView;
    YXEmptyView *_emptyView;
    
    NSMutableArray *_dataMutableArray;
    
    YXWorkshopListRequest *_listRequest;

}
@end

@implementation YXWorkshopViewController
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的工作坊";
    _dataMutableArray = [[NSMutableArray alloc] initWithCapacity:10];
    [self setupUI];
    [self layoutInterface];
    [self requestForWorkshopList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupUI{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 66, 0, 10);
    _tableView.separatorColor = [UIColor colorWithHexString:@"eceef2"];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    _tableView.layoutMargins = UIEdgeInsetsZero;
    [_tableView registerClass:[YXWorkshopCell class] forCellReuseIdentifier:@"YXWorkshopCell"];
    [self.view addSubview:_tableView];
    
    WEAK_SELF
    _errorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
    _errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForWorkshopList];
    };
    _emptyView = [[YXEmptyView alloc]initWithFrame:self.view.bounds];
    _emptyView.title = @"暂无内容";
    _emptyView.imageName = @"无内容";
}
- (void)layoutInterface{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0.0f);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YXWorkshopDetailViewController *detailVC = [[YXWorkshopDetailViewController alloc] init];
    YXWorkshopListRequestItem_group *group = _dataMutableArray[indexPath.row];
    detailVC.baridString = group.barid;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXWorkshopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXWorkshopCell"
                                                           forIndexPath:indexPath];
    YXWorkshopListRequestItem_group *group = _dataMutableArray[indexPath.row];
    [cell reloadWithText:group.gname imageUrl:@""];
    return cell;
}
#pragma mark - request
- (void)requestForWorkshopList{
    if (_listRequest) {
        [_listRequest stopRequest];
    }
    YXWorkshopListRequest *request = [[YXWorkshopListRequest alloc] init];
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXWorkshopListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            if (error.code == -2) {
                self->_emptyView.frame = self.view.bounds;
                self->_emptyView.imageName = @"数据错误";
                self->_emptyView.title = @"数据错误";
                [self.view addSubview:self->_emptyView];
            }
            else{
                self ->_errorView.frame = self.view.bounds;
                [self.view addSubview:self ->_errorView];
            }
        }
        else{
            YXWorkshopListRequestItem *item = (YXWorkshopListRequestItem *)retItem;
            if (item.group.count > 0) {
                [self -> _dataMutableArray addObjectsFromArray:item.group];
                [self -> _tableView reloadData];
                [self -> _emptyView removeFromSuperview];
                [self -> _errorView removeFromSuperview];
            }
            else{
                self ->_emptyView.frame = self.view.bounds;
                [self.view addSubview:self ->_emptyView];
            }
        }
    }];
    _listRequest = request;
}

@end

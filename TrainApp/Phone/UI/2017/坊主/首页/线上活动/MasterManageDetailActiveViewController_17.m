//
//  MasterManageDetailActiveViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManageDetailActiveViewController_17.h"
#import "MasterDetailActiveTableHeaderView_17.h"
#import "MasterCountActiveRequest_17.h"
#import "MasterDetailActiveToolCell_17.h"
#import "MasterDetailActiveMemeberCell_17.h"
#import "MasterDetailActiveMemeberHeaderView_17.h"
#import "MJRefresh.h"
@interface MasterManageDetailActiveViewController_17 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MasterDetailActiveTableHeaderView_17 *headerView;
@property (nonatomic, strong) MasterCountActiveRequest_17 *activeRequest;
@property (nonatomic, strong) MasterCountActiveItem_Body *detailItem;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, assign) MasterManageActiveType activeType;

@end

@implementation MasterManageDetailActiveViewController_17
- (void)dealloc{
    [self.header free];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.titleString;
    self.activeType = MasterManageActiveType_Tool;
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForActiveDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - set
- (void)setDetailItem:(MasterCountActiveItem_Body *)detailItem {
    _detailItem = detailItem;
    self.activeType = MasterManageActiveType_Tool;
    self.headerView.frame = CGRectMake(0 , 0 , kScreenWidth, [self.headerView relodDetailActiveHeader:_detailItem.active.desc?:@"" withMySelf:self.isMySelfBool]);
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self.tableView registerClass:[MasterDetailActiveMemeberHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"MasterDetailActiveMemeberHeaderView_17"];
    [self.tableView registerClass:[MasterDetailActiveMemeberCell_17 class] forCellReuseIdentifier:@"MasterDetailActiveMemeberCell_17"];
    [self.tableView registerClass:[MasterDetailActiveToolCell_17 class] forCellReuseIdentifier:@"MasterDetailActiveToolCell_17"];
    
    self.headerView = [[MasterDetailActiveTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 255.0f)];
    WEAK_SELF
    self.headerView.masterDetailActiveBlock = ^(MasterManageActiveType type) {
        STRONG_SELF
        self.activeType = type;
        [self.tableView reloadData];
    };
    self.tableView.hidden = YES;
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self requestForActiveDetail];
    };
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForActiveDetail];
    };
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForActiveDetail];
    };
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.isMySelfBool) {
        return 0;
    }
    if (self.activeType == MasterManageActiveType_Tool) {
        return self.detailItem.countTool.count;
    }else {
        return self.detailItem.countMemeber.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.activeType == MasterManageActiveType_Tool) {
        return 1;
    }else {
        MasterCountActiveItem_Body_CountMemeber *memeber = self.detailItem.countMemeber[section];
        return memeber.totalArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.activeType == MasterManageActiveType_Tool) {
        MasterDetailActiveToolCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterDetailActiveToolCell_17" forIndexPath:indexPath];
        cell.tool = self.detailItem.countTool[indexPath.section];
        return cell;
    }else {
        MasterDetailActiveMemeberCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterDetailActiveMemeberCell_17" forIndexPath:indexPath];
        MasterCountActiveItem_Body_CountMemeber *memeber = self.detailItem.countMemeber[indexPath.section];
        cell.total = memeber.totalArray[indexPath.row];
        return cell;
    }
}
#pragma mark - UITableViewDataScore
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.activeType == MasterManageActiveType_Tool) {
        return 0.00001f;
    }else {
        return 45.0f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.activeType == MasterManageActiveType_Tool) {
        YXSectionHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
        return header;
    }else {
        MasterDetailActiveMemeberHeaderView_17 *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MasterDetailActiveMemeberHeaderView_17"];
        MasterCountActiveItem_Body_CountMemeber *memeber = self.detailItem.countMemeber[section];
        header.nameLabel.text = memeber.userName;
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.activeType == MasterManageActiveType_Tool) {
        return 1.0f;
    }else {
        return 5.0f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footer;
}


#pragma mark - request
- (void)requestForActiveDetail {
    MasterCountActiveRequest_17 *request = [[MasterCountActiveRequest_17  alloc] init];
    request.aId = self.activeId;
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterCountActiveItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        [self.header endRefreshing];
        UnhandledRequestData *data = [[UnhandledRequestData alloc] init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        MasterCountActiveItem *item = retItem;
        self.detailItem = item.body;
    }];
    self.activeRequest = request;
}
@end

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
@interface MasterManageDetailActiveViewController_17 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MasterDetailActiveTableHeaderView_17 *headerView;
@property (nonatomic, strong) MasterCountActiveRequest_17 *activeRequest;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, assign) MasterManageActiveType activeType;

@property (nonatomic, strong) MasterFilterEmptyFooterView_17 *footerView;
@property (nonatomic, strong) NSMutableArray *toolMutableArray;
@property (nonatomic, strong) NSMutableArray *memeberMutableArray;
@property (nonatomic, assign) NSInteger startPage;
@property (nonatomic, assign) BOOL hasNextPage;
@end

@implementation MasterManageDetailActiveViewController_17
- (void)dealloc{
}
#pragma mark - set
- (void)setActiveType:(MasterManageActiveType)activeType {
    _activeType = activeType;
    if (!self.isMySelfBool) {
        self.tableView.tableFooterView = nil;
        return;
    }
    if (_activeType == MasterManageActiveType_Tool) {
        if (self.toolMutableArray.count == 0) {
            self.tableView.tableFooterView = self.footerView;
        }else {
            self.tableView.tableFooterView = nil;
        }
        self.tableView.mj_footer.hidden = YES;
    }else {
        if (self.memeberMutableArray.count == 0) {
            self.tableView.tableFooterView = self.footerView;
            self.tableView.mj_footer.hidden = YES;
        }else {
            self.tableView.mj_footer.hidden = !self.hasNextPage;
            self.tableView.tableFooterView = nil;
        }
    }
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.startPage = 1;
    self.memeberMutableArray = [[NSMutableArray alloc] init];
    self.toolMutableArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = self.titleString;
    _activeType = MasterManageActiveType_Tool;
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForActiveDetail];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:@"线上活动详情" withStatus:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:@"线上活动详情" withStatus:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self.tableView registerClass:[MasterDetailActiveMemeberHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"MasterDetailActiveMemeberHeaderView_17"];
    [self.tableView registerClass:[MasterDetailActiveMemeberCell_17 class] forCellReuseIdentifier:@"MasterDetailActiveMemeberCell_17"];
    [self.tableView registerClass:[MasterDetailActiveToolCell_17 class] forCellReuseIdentifier:@"MasterDetailActiveToolCell_17"];
    self.headerView = [[MasterDetailActiveTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 255.0f)];
    self.footerView = [[MasterFilterEmptyFooterView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 255.0f - 64.0f)];
    WEAK_SELF
    self.headerView.masterDetailActiveBlock = ^(MasterManageActiveType type) {
        STRONG_SELF
        self.activeType = type;
    };
    self.tableView.hidden = YES;
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        STRONG_SELF
        self.startPage = 1;
        [self requestForActiveDetail];
    }];
    if (self.isMySelfBool) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            STRONG_SELF
            self.startPage ++;
            [self requestForActiveDetail];
        }];
    }

    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        self.startPage = 1;
        [self requestForActiveDetail];
    };
    self.errorView.hidden = YES;
    [self.view addSubview:self.errorView];
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        self.startPage = 1;
        [self requestForActiveDetail];
    };
    self.dataErrorView.hidden = YES;
    [self.view addSubview:self.dataErrorView];
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.dataErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.isMySelfBool) {
        return 0;
    }
    if (self.activeType == MasterManageActiveType_Tool) {
        return self.toolMutableArray.count;
    }else {
        return self.memeberMutableArray.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.activeType == MasterManageActiveType_Tool) {
        return 1;
    }else {
        MasterCountActiveItem_Body_CountMemeber *memeber = self.memeberMutableArray[section];
        return memeber.totalArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.activeType == MasterManageActiveType_Tool) {
        MasterDetailActiveToolCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterDetailActiveToolCell_17" forIndexPath:indexPath];
        cell.tool = self.toolMutableArray[indexPath.section];
        return cell;
    }else {
        MasterDetailActiveMemeberCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterDetailActiveMemeberCell_17" forIndexPath:indexPath];
        MasterCountActiveItem_Body_CountMemeber *memeber = self.memeberMutableArray[indexPath.section];
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
        MasterCountActiveItem_Body_CountMemeber *memeber = self.memeberMutableArray[section];
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
    request.page = [NSString stringWithFormat:@"%ld",(long)self.startPage];
    request.pageSize = @"5";
    WEAK_SELF
    [request startRequestWithRetClass:[MasterCountActiveItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (error) {
            if (self.startPage == 1) {
                if (error.code == ASIConnectionFailureErrorType || error.code == ASIRequestTimedOutErrorType) {//网络错误/请求超时
                    self.errorView.hidden = NO;
                    self.dataErrorView.hidden = YES;
                }else {
                    self.errorView.hidden = YES;
                    self.dataErrorView.hidden = NO;
                }
            }else {
                self.startPage--;
                [self showToast:error.localizedDescription];
            }
        }else {
            MasterCountActiveItem *item = retItem;
            self.hasNextPage = item.body.hasNextPage.boolValue;
            if (self.toolMutableArray.count == 0) {
                [self.toolMutableArray addObjectsFromArray:item.body.countTool];
            }
            if (self.startPage == 1) {
                [self.memeberMutableArray removeAllObjects];
                self.headerView.frame = CGRectMake(0 , 0 , kScreenWidth, [self.headerView relodDetailActiveHeader:item.body.active.desc?:@"" withMySelf:self.isMySelfBool]);
                self.tableView.tableHeaderView = self.headerView;
                self.tableView.hidden = NO;
                self.activeType = MasterManageActiveType_Tool;
                [self.memeberMutableArray addObjectsFromArray:item.body.countMemeber];
                [self.tableView reloadData];
            }else {
                self.activeType = self.activeType;
                [self.memeberMutableArray addObjectsFromArray:item.body.countMemeber];
                [self.tableView reloadData];
            }
        }
    }];
    self.activeRequest = request;
}
@end

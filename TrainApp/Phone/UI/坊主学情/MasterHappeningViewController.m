//
//  MasterHappeningViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHappeningViewController.h"
#import "MasterStatRequest.h"
#import "MasterHappeningTableHeaderView.h"
#import "YXExamBlankHeaderFooterView.h"
#import "MasterHappeningHeaderView.h"
#import "MasterHappeningCell.h"
#import "BeijingExamExplainView.h"
#import "MJRefresh.h"
@interface MasterHappeningViewController ()<UITableViewDelegate, UITableViewDataSource>;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MasterHappeningTableHeaderView *headerView;
@property (nonatomic, strong) MasterStatRequestItem_Body *masterBody;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) MasterStatRequest *masterStatrequest;
@end

@implementation MasterHappeningViewController
- (void)dealloc{
    [self.header free];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学情";
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForMasterStat];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.headerView = [[MasterHappeningTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 170.0f)];
    self.headerView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView registerClass:[MasterHappeningCell class] forCellReuseIdentifier:@"MasterHappeningCell"];
    [self.tableView registerClass:[MasterHappeningHeaderView class] forHeaderFooterViewReuseIdentifier:@"MasterHappeningHeaderView"];
    [self.tableView registerClass:[YXExamBlankHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXExamBlankHeaderFooterView"];
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    WEAK_SELF
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self requestForMasterStat];
    };
    
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)showMarkWithOriginRect:(CGRect)rect explain:(NSString *)string {
    BeijingExamExplainView *v = [[BeijingExamExplainView alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    v.originRect = rect;
    
}
#pragma mark - UITableViewDelegate 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MasterStatRequestItem_Body_Type *type = self.masterBody.types[section];
    MasterHappeningHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MasterHappeningHeaderView"];
    header.powerInteger = type.power.integerValue;
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YXExamBlankHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXExamBlankHeaderFooterView"];
    return footer;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.masterBody.types.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MasterStatRequestItem_Body_Type *type = self.masterBody.types[section];
    return type.details.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterStatRequestItem_Body_Type *type = self.masterBody.types[indexPath.section];
    MasterStatRequestItem_Body_Type_Detail *detail = type.details[indexPath.row];
    MasterHappeningCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterHappeningCell" forIndexPath:indexPath];
    cell.detail = detail;
     WEAK_SELF
    [cell setMasterHappeningCellButtonBlock:^(UIButton *sender) {
       STRONG_SELF
        CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
        [self showMarkWithOriginRect:rect explain:detail.descripe];

    }];
    return cell;
}
#pragma mark - request
- (void)requestForMasterStat {
    MasterStatRequest *request = [[MasterStatRequest alloc] init];
    request.projectId = [YXTrainManager sharedInstance].currentProject.pid;
    request.roleId =[YXTrainManager sharedInstance].currentProject.role;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterStatRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        [self.header endRefreshing];
        MasterStatRequestItem *item = retItem;
        UnhandledRequestData *data = [[UnhandledRequestData alloc] init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        self.masterBody = item.body;
        self.headerView.hidden = NO;
        self.headerView.totalString = item.body.total;
        [self.tableView reloadData];
    }];
    self.masterStatrequest = request;
}

@end

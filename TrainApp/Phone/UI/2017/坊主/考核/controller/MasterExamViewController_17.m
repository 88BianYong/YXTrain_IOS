//
//  MasterExamViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterExamViewController_17.h"
#import "MasterIndexRequest_17.h"
#import "MasterHappeningTableHeaderView.h"
#import "YXExamBlankHeaderFooterView.h"
#import "MasterHappeningHeaderView.h"
#import "MasterHappeningCell_17.h"
#import "BeijingExamExplainView.h"
#import "MJRefresh.h"
@interface MasterExamViewController_17 ()<UITableViewDelegate, UITableViewDataSource>;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MasterHappeningTableHeaderView *headerView;
@property (nonatomic, strong) MasterIndexRequestItem_Body_MyExamine *masterBody;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) MasterIndexRequest_17 *masterStatrequest;
@end

@implementation MasterExamViewController_17
- (void)dealloc{
    [self.header free];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考核";
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForMasterStat];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - set
- (void)setMasterBody:(MasterIndexRequestItem_Body_MyExamine *)masterBody {
    _masterBody = masterBody;
    self.headerView.hidden = NO;
    self.headerView.totalString = _masterBody.total;
    [self.tableView reloadData];
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
    
    [self.tableView registerClass:[MasterHappeningCell_17 class] forCellReuseIdentifier:@"MasterHappeningCell_17"];
    [self.tableView registerClass:[MasterHappeningHeaderView class] forHeaderFooterViewReuseIdentifier:@"MasterHappeningHeaderView"];
    [self.tableView registerClass:[YXExamBlankHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXExamBlankHeaderFooterView"];
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    WEAK_SELF
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self requestForMasterStat];
    };
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForMasterStat];
    };
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForMasterStat];
    };
    
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)showMarkWithOriginRect:(CGRect)rect explain:(NSString *)string {
    MasterMyExamExplainView_17 *v = [[MasterMyExamExplainView_17 alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    [v setupOriginRect:rect];
    
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
    MasterIndexRequestItem_Body_MyExamine_Types *type = self.masterBody.types[section];
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
    MasterIndexRequestItem_Body_MyExamine_Types *type = self.masterBody.types[section];
    return type.details.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterIndexRequestItem_Body_MyExamine_Types *type = self.masterBody.types[indexPath.section];
    MasterIndexRequestItem_Body_MyExamine_Types_Detail *detail = type.details[indexPath.row];
    MasterHappeningCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterHappeningCell_17" forIndexPath:indexPath];
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
    MasterIndexRequest_17 *request = [[MasterIndexRequest_17 alloc] init];
    request.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    WEAK_SELF
    [request startRequestWithRetClass:[MasterIndexRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
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
        MasterIndexRequestItem *item = retItem;
        self.masterBody = item.body.myExamine;
    }];
    self.masterStatrequest = request;
}

@end

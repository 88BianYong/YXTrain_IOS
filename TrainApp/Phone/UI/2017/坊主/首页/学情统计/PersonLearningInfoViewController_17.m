//
//  PersonLearningInfoViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PersonLearningInfoViewController_17.h"
#import "PersonLearningInfoRequest_17.h"
#import "YXMyLearningScoreTableHeaderView_17.h"
#import "YXMyLearningScoreHeaderView_17.h"
#import "MasterMyLearningScoreCell_17.h"
#import "YXMyExamExplainHelp_17.h"
#import "PersonLearningInfoRequest_17.h"
#import "PersonTableHeaderView_17.h"
@interface PersonLearningInfoViewController_17 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) PersonTableHeaderView_17 *headerView;
@property (nonatomic, strong) PersonLearningInfoRequest_17 *learningInfoRequest;
@property (nonatomic, strong) ExamineDetailRequest_17Item_Examine *examine;
@property (nonatomic, assign) NSInteger showMarkHeight;
@property (nonatomic, assign) BOOL isShowChoose;
@end

@implementation PersonLearningInfoViewController_17
- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForLearningInfo];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:@"学员考核" withStatus:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:@"学员考核" withStatus:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setExamine:(ExamineDetailRequest_17Item_Examine *)examine {
    _examine = examine;
    self.headerView.hidden = NO;
    [self.headerView reloadPersonLearningInfo:self.learningInfo withScore:self.examine.userGetScore withPass:self.examine.isPass];
    [self.tableView reloadData];
}
#pragma mark - setupUI
- (void)setupUI {
    self.navigationItem.title = @"考核详情";
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[YXMyLearningScoreHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"YXMyLearningScoreHeaderView_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self.tableView registerClass:[MasterMyLearningScoreCell_17 class] forCellReuseIdentifier:@"MasterMyLearningScoreCell_17"];
    self.headerView = [[PersonTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 210.0f)];
    self.headerView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
    self.errorView = [[YXErrorView alloc] init];
    WEAK_SELF
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForLearningInfo];
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForLearningInfo];
    };
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        STRONG_SELF
        [self requestForLearningInfo];
    }];
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
    ExamineDetailRequest_17Item_Examine_Process *process = self.examine.process[indexPath.section];
    return  ceil((double)process.toolExamineVoList.count/4.0f) * 80.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXMyLearningScoreHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXMyLearningScoreHeaderView_17"];
    headerView.process = self.examine.process[section];
    WEAK_SELF
    headerView.myLearningScoreButtonBlock = ^(UIButton *sender) {
        STRONG_SELF
        ExamineDetailRequest_17Item_Examine_Process *process = self.examine.process[section];
        CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
        [self showMarkWithOriginRect:rect explain:process.descr?:@""];
    };
    return headerView;
}
#pragma mark - UITableViewDataSorce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.examine.process.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterMyLearningScoreCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterMyLearningScoreCell_17" forIndexPath:indexPath];
    cell.process = self.examine.process[indexPath.section];
    return cell;
}
#pragma mark - request
- (void)requestForLearningInfo {
    PersonLearningInfoRequest_17 *request = [[PersonLearningInfoRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.userId = self.learningInfo.userId;
    WEAK_SELF
    [request startRequestWithRetClass:[ExamineDetailRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        [self.tableView.mj_header endRefreshing];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        ExamineDetailRequest_17Item *item = retItem;
        self.examine = item.examine;
    }];
    self.learningInfoRequest = request;
}
@end

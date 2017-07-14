//
//  YXMyLearningScoreViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXMyLearningScoreViewController.h"
#import "YXMyLearningScoreTableHeaderView_17.h"
#import "YXMyLearningScoreHeaderView_17.h"
#import "YXMyLearningScoreCell_17.h"
#import "PersonalExamineRequest_17.h"
#import "YXMyExamExplainView_17.h"
#import "YXMyExamExplainHelp_17.h"
@interface YXMyLearningScoreViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) YXMyLearningScoreTableHeaderView_17 *headerView;

@property (nonatomic, strong) PersonalExamineRequest_17 *examineScoreRequest;

@property (nonatomic, strong) PersonalExamineRequest_17Item *examineScoreItem;
@end

@implementation YXMyLearningScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForExamineScore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - set
- (void)setExamineScoreItem:(PersonalExamineRequest_17Item *)examineScoreItem {
    _examineScoreItem = examineScoreItem;
    self.headerView.isPassBool = NO;
    self.headerView.scoreString = @"44";
    self.headerView.hidden = NO;
    [self.tableView reloadData];
}
#pragma mark - setupUI
- (void)setupUI {
    self.navigationItem.title = @"我的成绩";
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[YXMyLearningScoreHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"YXMyLearningScoreHeaderView_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self.tableView registerClass:[YXMyLearningScoreCell_17 class] forCellReuseIdentifier:@"YXMyLearningScoreCell_17"];
    self.headerView = [[YXMyLearningScoreTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110.0f)];
    self.headerView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
    self.errorView = [[YXErrorView alloc] init];
    WEAK_SELF
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForExamineScore];
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self requestForExamineScore];
    };
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)showMarkWithOriginRect:(CGRect)rect explain:(NSString *)string {
    YXMyExamExplainView_17 *v = [[YXMyExamExplainView_17 alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    v.originRect = rect;
    
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalExamineRequest_17Item_Examine_Process *process = self.examineScoreItem.examine.process[indexPath.section];
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
    headerView.process = self.examineScoreItem.examine.process[section];
    WEAK_SELF
    headerView.myLearningScoreButtonBlock = ^(UIButton *sender) {
        STRONG_SELF
        CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
        [self showMarkWithOriginRect:rect explain:[self showExamExplain:self.examineScoreItem.examine.process[section]]];

    };
    return headerView;
}
#pragma mark - UITableViewDataSorce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.examineScoreItem.examine.process.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXMyLearningScoreCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"YXMyLearningScoreCell_17" forIndexPath:indexPath];
    cell.process = self.examineScoreItem.examine.process[indexPath.section];
    return cell;
}
#pragma mark - request
- (void)requestForExamineScore {
    PersonalExamineRequest_17 *request = [[PersonalExamineRequest_17 alloc] init];
    request.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.role = [LSTSharedInstance sharedInstance].trainManager.currentProject.role;
    WEAK_SELF
    [request startRequestWithRetClass:[PersonalExamineRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF;
        [self stopLoading];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        self.examineScoreItem = retItem;
    }];
    self.examineScoreRequest = request;
}
#pragma mark - dataFormat
- (NSString *)showExamExplain:(PersonalExamineRequest_17Item_Examine_Process *)process{
    NSMutableArray<NSString *> *mutableArray = [[NSMutableArray<NSString *> alloc] initWithCapacity:4];
    [process.toolExamineVoList enumerateObjectsUsingBlock:^(PersonalExamineRequest_17Item_Examine_Process_ToolExamineVoList *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXMyExamExplainHelp_17 *help = [[YXMyExamExplainHelp_17 alloc] init];
        help.toolName = obj.name;
        help.toolID = obj.toolID;
        help.finishNum = obj.finishNum;
        help.finishScore = obj.userScore;
        help.totalNum = obj.totalNum;
        help.totalScore = obj.totalScore;
        [mutableArray addObject:[help toolCompleteStatusExplain]];
    }];
    NSString *string = [mutableArray componentsJoinedByString:@"\n"];
    return string;
}
@end

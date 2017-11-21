//
//  YXMyLearningScoreViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXMyLearningScoreViewController_17.h"
#import "YXMyLearningScoreTableHeaderView_17.h"
#import "YXMyLearningScoreHeaderView_17.h"
#import "YXMyLearningScoreCell_17.h"
#import "YXMyExamExplainView_17.h"
#import "YXMyExamExplainHelp_17.h"
@interface YXMyLearningScoreViewController_17 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) YXMyLearningScoreTableHeaderView_17 *headerView;

@property (nonatomic, assign) NSInteger showMarkHeight;
@property (nonatomic, assign) BOOL isShowChoose;
@end

@implementation YXMyLearningScoreViewController_17

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.headerView.isPassInteger = self.examine.isPass.integerValue;
    self.headerView.scoreString = [NSString stringWithFormat:@"%0.2f",[self.examine.userGetScore floatValue]];
    self.tableView.tableHeaderView = self.headerView;
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)showMarkWithOriginRect:(CGRect)rect explain:(NSString *)string {
    YXMyExamExplainView_17 *v = [[YXMyExamExplainView_17 alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    [v setupOriginRect:rect withToTop:(rect.origin.y - [YXMyExamExplainView_17 heightForDescription:string] - 30 > 0) ? YES : NO];
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
         [self showMarkWithOriginRect:rect explain:process.descr];
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
    YXMyLearningScoreCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"YXMyLearningScoreCell_17" forIndexPath:indexPath];
    cell.process = self.examine.process[indexPath.section];
    return cell;
}
@end

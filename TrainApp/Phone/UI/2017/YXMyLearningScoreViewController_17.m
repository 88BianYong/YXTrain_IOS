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
#pragma mark - set
- (void)setExamine:(ExamineDetailRequest_17Item_Examine *)examine {
    _examine = examine;
    NSMutableArray<ExamineDetailRequest_17Item_Examine_Process> *process = [[NSMutableArray<ExamineDetailRequest_17Item_Examine_Process> alloc] init];
    [_examine.process enumerateObjectsUsingBlock:^(ExamineDetailRequest_17Item_Examine_Process *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSMutableArray<ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList> *list = [[NSMutableArray<ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList> alloc] init];
        //任何工具总分、完成标准都为0时不显示该工具
        //工具总分： passtotalscore + totalscore
        //完成标准totalNum
         __block BOOL isFilterBool = YES;
        [obj.toolExamineVoList enumerateObjectsUsingBlock:^(ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList *exa, NSUInteger idx, BOOL * _Nonnull stop) {
            if (exa.totalScore.integerValue != 0.0f || exa.passTotalScore.integerValue != 0.0f || exa.totalNum.integerValue != 0) {
                isFilterBool = NO;
                [list addObject:exa];
            }
            if (exa.toolID.integerValue == 201) {
                [exa.toolExamineVoList enumerateObjectsUsingBlock:^(ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList *next, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (next.toolID.integerValue == 223) {
                        self.isShowChoose = YES;
                    }
                }];
            }
        }];
        obj.toolExamineVoList = list;
        if (!isFilterBool) {
            [process addObject:obj];
        }
    }];
    _examine.process = process;
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
    [v setupOriginRect:rect withToTop:(rect.origin.y - self.showMarkHeight - 20 > 0) ? YES : NO];
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
        CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
         [self showMarkWithOriginRect:rect explain:[self showExamExplain:self.examine.process[section]]];
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
#pragma mark - dataFormat
- (NSString *)showExamExplain:(ExamineDetailRequest_17Item_Examine_Process *)process {
    self.showMarkHeight = 20;
    NSMutableArray<NSString *> *mutableArray = [[NSMutableArray<NSString *> alloc] initWithCapacity:4];
    [process.toolExamineVoList enumerateObjectsUsingBlock:^(ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isExistsNext.boolValue) {
            YXMyExamExplainHelp_17 *help = [[YXMyExamExplainHelp_17 alloc] init];
            help.toolName = obj.name;
            help.toolID = obj.toolID;
            help.type = obj.type;
            help.finishNum = obj.finishNum;
            help.finishScore = obj.passFinishScore;
            help.totalNum = obj.totalNum;
            help.totalScore = obj.totalScore;
            help.passTotalScore = obj.passTotalScore;
            help.passScore = obj.passScore;
            help.isExamPass = self.examine.isExamPass;
            help.isShowChoose = self.isShowChoose;
            NSString *helpString = [help toolCompleteStatusExplain];
            if (!isEmpty(helpString)) {
                [mutableArray addObject:helpString];
                self.showMarkHeight += 23;
            }
            
        }else {
            [obj.toolExamineVoList enumerateObjectsUsingBlock:^(ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList *next, NSUInteger idx, BOOL * _Nonnull stop) {
                YXMyExamExplainHelp_17 *help = [[YXMyExamExplainHelp_17 alloc] init];
                help.toolName = next.name;
                help.toolID = next.toolID;
                help.type = next.type;
                help.finishNum = next.finishNum;
                help.finishScore = next.userScore;
                help.totalNum = next.totalNum;
                help.totalScore = next.totalScore;
                help.passTotalScore = next.passTotalScore;
                help.passScore = next.passScore;
                help.isExamPass = self.examine.isExamPass;
                help.isShowChoose = self.isShowChoose;
                self.showMarkHeight += 23;
                NSString *helpString = [help toolCompleteStatusExplain];
                if (!isEmpty(helpString)) {
                    [mutableArray addObject:helpString];
                    self.showMarkHeight += 23;
                }
            }];
        }
    }];
    NSString *string = [mutableArray componentsJoinedByString:@"\n"];
    return string;
}
@end

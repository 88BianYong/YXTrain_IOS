//
//  BeijingExamViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingExamViewController.h"
#import "BeijingExamineRequest.h"
#import "MJRefresh.h"
#import "YXScoreViewController.h"
#import "YXExamMarkView.h"
#import "BeijingCourseViewController.h"
#import "ActivityListViewController.h"
#import "BeijingExamGenreCell.h"
#import "BeijingExamGenreDefaultHeaderView.h"
#import "BeijingExamGenreExplainHeaderView.h"
#import "BeijingExamTableHeaderView.h"
#import "BeijingExamExplainView.h"
#import "YXExamBlankHeaderFooterView.h"
#import "BeijingActivityListViewController.h"
#import "YXHomeworkInfoRequest.h"
#import "YXHomeworkInfoViewController.h"
#import "BeijingExamTipCell.h"
static  NSString *const trackPageName = @"考核页面";
static  NSString *const trackLabelOfJumpFromExeam = @"考核跳转";
@interface BeijingExamViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BeijingExamineRequest *request;
@property (nonatomic, strong) BeijingExamineRequestItem *examineItem;
@property (nonatomic, strong) NSMutableDictionary *foldStatusDic;
@property (nonatomic, strong) MJRefreshHeaderView *header;

@property (nonatomic,strong) UIView *waveView;
@property (nonatomic,assign) BOOL  isSelected;


@property (nonatomic, strong) BeijingExamTableHeaderView *headerView;

@end

@implementation BeijingExamViewController

- (void)dealloc{
    [self.header free];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isSelected) {
        [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isSelected) {
        [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"考核";
    self.isSelected = YES;
    self.foldStatusDic = [NSMutableDictionary dictionary];
    [self setupUI];
    [self setupLayout];
    [self getDataShowLoading:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.headerView = [[BeijingExamTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeightScale(160.0f))];
    self.headerView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registerClass:[BeijingExamGenreCell class] forCellReuseIdentifier:@"BeijingExamGenreCell"];
    [self.tableView registerClass:[BeijingExamTipCell class] forCellReuseIdentifier:@"BeijingExamTipCell"];
    [self.tableView registerClass:[BeijingExamGenreDefaultHeaderView class] forHeaderFooterViewReuseIdentifier:@"BeijingExamGenreDefaultHeaderView"];
    [self.tableView registerClass:[BeijingExamGenreExplainHeaderView class] forHeaderFooterViewReuseIdentifier:@"BeijingExamGenreExplainHeaderView"];
    [self.tableView registerClass:[YXExamBlankHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXExamBlankHeaderFooterView"];
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    
    WEAK_SELF
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self getDataShowLoading:NO];
    };
    self.errorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self getDataShowLoading:YES];
    };
    
}

- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)getDataShowLoading:(BOOL)isShow{
    [self.request stopRequest];
    self.request = [[BeijingExamineRequest alloc]init];
    self.request.projectid = [YXTrainManager sharedInstance].currentProject.pid;
    self.request.w = [YXTrainManager sharedInstance].currentProject.w;
    if (isShow) {
        [self startLoading];
    }
    WEAK_SELF
    [self.request startRequestWithRetClass:[BeijingExamineRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        [self.header endRefreshing];
        if (error) {
            self.errorView.frame = self.view.bounds;
            [self.view addSubview:self.errorView];
            return;
        }
        [self.errorView removeFromSuperview];
        [self dealWithRetItem:retItem];
    }];
}

- (void)dealWithRetItem:(BeijingExamineRequestItem *)retItem{
    self.examineItem = retItem;
    self.headerView.item = retItem;
    [YXTrainManager sharedInstance].requireId = @"845";
    self.headerView.hidden = NO;
    [self.tableView reloadData];
}

- (void)showMarkWithOriginRect:(CGRect)rect explain:(NSString *)string {
    BeijingExamExplainView *v = [[BeijingExamExplainView alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    v.originRect = rect;

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.examineItem.examineVoList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        BeijingExamineRequestItem_ExamineVoList *list = self.examineItem.examineVoList[section];
        return list.toolExamineVoList.count;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BeijingExamineRequestItem_ExamineVoList *list = self.examineItem.examineVoList[indexPath.section];
    BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *toolExamine = list.toolExamineVoList[indexPath.row];
    if (toolExamine.toolid.integerValue == 2176 || toolExamine.toolid.integerValue == 2180) {
        BeijingExamTipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeijingExamTipCell" forIndexPath:indexPath];
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.toolExamineVo = toolExamine;
        if (toolExamine.toolid.integerValue == 2176) {//技术素养类
            cell.tipLabelContent = @"课程(17课时)";
        }
        if (toolExamine.toolid.integerValue == 2180) {//案例
            cell.tipLabelContent = @"案例(3课时)";
        }
        WEAK_SELF
        [cell setBeijingExamTipButtonBlock:^(UIButton *sender) {
            STRONG_SELF
            CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
            if (toolExamine.toolid.integerValue == 2176) {
                [self showMarkWithOriginRect:rect explain:@"本类课程最多获得6学时的成绩,超出部分不计入学时"];
            }else if (toolExamine.toolid.integerValue == 2180) {
                [self showMarkWithOriginRect:rect explain:@"要求至少学习3学时"];
            }
        }];
        return cell;
    }else {
        BeijingExamGenreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeijingExamGenreCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.toolExamineVo = toolExamine;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        WEAK_SELF
        BeijingExamGenreDefaultHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BeijingExamGenreDefaultHeaderView"];
        [header setBeijingExamGenreDefaultButtonBlock:^(UIButton *sender) {
            STRONG_SELF
            CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
            [self showMarkWithOriginRect:rect explain:@"课程17学时,案例3学时"];
        }];
        return header;
    }else {
        BeijingExamGenreExplainHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BeijingExamGenreExplainHeaderView"];
        BeijingExamineRequestItem_ExamineVoList *list = self.examineItem.examineVoList[section];
        BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *toolExamine = list.toolExamineVoList[0];
        header.toolExamineVo = toolExamine;
        WEAK_SELF
        [header setBeijingExamGenreExplainButtonBlock:^(UIButton *sender) {
             STRONG_SELF
            CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
            if (toolExamine.toolid.integerValue == 205 ) {
                [self showMarkWithOriginRect:rect explain:@"作业质量由区级辅导教师评定，作业成绩显示合格视为通过"];
            }else if (toolExamine.toolid.integerValue == 206) {
                [self showMarkWithOriginRect:rect explain:@"校本实践需线下完成,成绩由校级管理员综合评定"];
            }
        }];
        [header setBeijingExamGenreExplainNextBlock:^(BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *tool) {
            STRONG_SELF
            if (tool.toolid.integerValue == 202) {
                BeijingActivityListViewController *VC = [[BeijingActivityListViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }else if (tool.toolid.integerValue == 205) {
                YXHomeworkInfoRequestItem_Body *itemBody = [[YXHomeworkInfoRequestItem_Body alloc] init];
                itemBody.type = @"4";
                itemBody.requireId = @"845";
                itemBody.homeworkid = @"";
                itemBody.pid = [YXTrainManager sharedInstance].currentProject.pid;
                YXHomeworkInfoViewController *VC = [[YXHomeworkInfoViewController alloc] init];
                VC.itemBody = itemBody;
                [self.navigationController pushViewController:VC animated:YES];
            }

        }];
        return header;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YXExamBlankHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXExamBlankHeaderFooterView"];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 4) {
        return 125.0f;
    }
    return 70.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BeijingCourseViewController *vc = [[BeijingCourseViewController alloc]init];
    BeijingExamineRequestItem_ExamineVoList *list = self.examineItem.examineVoList[indexPath.section];
    BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *toolExamine = list.toolExamineVoList[indexPath.row];
    vc.stageID = toolExamine.toolid;
    [self.navigationController pushViewController:vc animated:YES];
    [YXDataStatisticsManger trackEvent:@"课程列表" label:trackLabelOfJumpFromExeam parameters:nil];
}
- (void)report:(BOOL)status{
    if (status) {
        self.isSelected = YES;
    }else{
        self.isSelected = NO;
    }
    [YXDataStatisticsManger trackPage:trackPageName withStatus:status];
}

@end

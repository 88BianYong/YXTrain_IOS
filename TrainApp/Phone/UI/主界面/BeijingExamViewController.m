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
#import "YXCourseViewController.h"
#import "ActivityListViewController.h"
#import "BeijingExamGenreCell.h"
#import "BeijingExamGenreDefaultHeaderView.h"
#import "BeijingExamGenreExplainHeaderView.h"
#import "BeijingExamTableHeaderView.h"
#import "BeijingExamExplainView.h"
#import "YXExamBlankHeaderFooterView.h"

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
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registerClass:[BeijingExamGenreCell class] forCellReuseIdentifier:@"BeijingExamGenreCell"];
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
    [self startLoading];
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
    BeijingExamGenreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeijingExamGenreCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BeijingExamineRequestItem_ExamineVoList *list = self.examineItem.examineVoList[indexPath.section];
    BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *toolExamine = list.toolExamineVoList[indexPath.row];
    cell.toolExamineVo = toolExamine;
    WEAK_SELF
    [cell setBeijingExamGenreButtonBlock:^(UIButton *sender) {
        STRONG_SELF
        CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
        if (toolExamine.toolid.integerValue == 2176) {
            [self showMarkWithOriginRect:rect explain:@"本类课程最多获得6学时的成绩,超出部分不计入学时"];
        }else if (toolExamine.toolid.integerValue == 2180) {
            [self showMarkWithOriginRect:rect explain:@"要求至少学习3学时"];
        }
        
    }];
    return cell;
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
        return header;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YXExamBlankHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXExamBlankHeaderFooterView"];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return;
//    if (indexPath.section == 100) {
//        YXScoreViewController *vc = [[YXScoreViewController alloc]init];
//        vc.data = self.examineItem.body;
//        vc.waveView = self.waveView;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if (indexPath.section <= self.examineItem.body.leadingVoList.count){
//        YXExamineRequestItem_body_leadingVo *vo = self.examineItem.body.leadingVoList[indexPath.section-1];
//        if (indexPath.row>0 && indexPath.row<=vo.toolExamineVoList.count) {
//            YXExamineRequestItem_body_toolExamineVo *data = vo.toolExamineVoList[indexPath.row-1];
//            if ([data.toolid isEqualToString:@"201"]) { // 课程
//                YXCourseViewController *vc = [[YXCourseViewController alloc]init];
//                vc.stageID = vo.voID;
//                vc.status = YXCourseFromStatus_Stage;
//                [self.navigationController pushViewController:vc animated:YES];
//                [YXDataStatisticsManger trackEvent:@"课程列表" label:trackLabelOfJumpFromExeam parameters:nil];
//            }else if ([data.toolid isEqualToString:@"203"] || [data.toolid isEqualToString:@"303"]){//作业
//                NSString *string = @"YXHomeworkListViewController";
//                UIViewController *VC = [[NSClassFromString(string) alloc] init];
//                [self.navigationController pushViewController:VC animated:YES];
//                [YXDataStatisticsManger trackEvent:@"作业列表" label:trackLabelOfJumpFromExeam parameters:nil];
//            }else if ([data.toolid isEqualToString:@"205"] || [data.toolid isEqualToString:@"305"]){//研修总结
//                NSString *string = @"YXHomeworkListViewController";
//                UIViewController *VC = [[NSClassFromString(string) alloc] init];
//                [self.navigationController pushViewController:VC animated:YES];
//                [YXDataStatisticsManger trackEvent:@"作业列表" label:trackLabelOfJumpFromExeam parameters:nil];
//            }else if ([data.toolid isEqualToString:@"216"] || [data.toolid isEqualToString:@"316"]){//小组作业
//                NSString *string = @"YXHomeworkListViewController";
//                UIViewController *VC = [[NSClassFromString(string) alloc] init];
//                [self.navigationController pushViewController:VC animated:YES];
//                [YXDataStatisticsManger trackEvent:@"作业列表" label:trackLabelOfJumpFromExeam parameters:nil];
//            }else if ([data.toolid isEqualToString:@"202"] || [data.toolid isEqualToString:@"302"]){//活动
//                ActivityListViewController *VC = [[ActivityListViewController alloc] init];
//                [self.navigationController pushViewController:VC animated:YES];
//                VC.stageID = vo.voID;
//            }else{
//                [self showToast:@"相关功能暂未开放"];
//            }
//        }
//    }
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

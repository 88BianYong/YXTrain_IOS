//
//  YXExamViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamViewController.h"
#import "YXExamEndDateCell.h"
#import "YXExamProgressCell.h"
#import "YXExamTotalScoreCell.h"
#import "YXExamPhaseShadowCell.h"
#import "YXExamPhaseHeaderView.h"
#import "YXExamBlankHeaderFooterView.h"
#import "YXExamTaskProgressHeaderView.h"
#import "YXExamineRequest.h"
#import "YXScoreViewController.h"
#import "YXExamMarkView.h"
#import "YXCourseViewController.h"
#import "ActivityListViewController.h"
#import "StudentExamTipsView.h"
static  NSString *const trackPageName = @"考核页面";
static  NSString *const trackLabelOfJumpFromExeam = @"考核跳转";
@interface YXExamViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXExamineRequest *examineRequest;
@property (nonatomic, strong) YXExamineRequestItem *examineItem;
@property (nonatomic, strong) NSMutableDictionary *foldStatusDic;

@property (nonatomic, strong) StudentExamTipsView *tipsView;

@property (nonatomic,strong) UIView *waveView;
@property (nonatomic,assign) BOOL  isSelected;
@end

@implementation YXExamViewController


- (void)dealloc{
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startAnimation];
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
    [self hiddenTipsView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"考核";
    self.isSelected = YES;
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForExamineContent];
    };
    
    self.foldStatusDic = [NSMutableDictionary dictionary];
    [self setupUI];
    [self startLoading];
    [self requestForExamineContent];
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
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[YXExamEndDateCell class]
           forCellReuseIdentifier:@"YXExamEndDateCell"];
    [self.tableView registerClass:[YXExamProgressCell class]
           forCellReuseIdentifier:@"YXExamProgressCell"];
    [self.tableView registerClass:[YXExamTotalScoreCell class] forCellReuseIdentifier:@"YXExamTotalScoreCell"];
    [self.tableView registerClass:[YXExamPhaseShadowCell class] forCellReuseIdentifier:@"YXExamPhaseShadowCell"];
    [self.tableView registerClass:[YXExamPhaseHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXExamPhaseHeaderView"];
    [self.tableView registerClass:[YXExamBlankHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXExamBlankHeaderFooterView"];
    [self.tableView registerClass:[YXExamTaskProgressHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXExamTaskProgressHeaderView"];
    
        [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    WEAK_SELF
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        STRONG_SELF
        [self requestForExamineContent];
    }];
    if (![LSTSharedInstance sharedInstance].trainManager.currentProject.isContainsTeacher.boolValue &&
        [LSTSharedInstance sharedInstance].trainManager.currentProject.isDoubel.boolValue) {
        self.tipsView = [[StudentExamTipsView alloc] init];
        [self.tipsView setStudentExamTipsOpenCloseBlock:^(UIButton *sender) {
            STRONG_SELF
            if (sender.selected) {
                [UIView animateWithDuration:0.3f animations:^{
                    [self.tipsView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.view.mas_left).offset(15.0f);
                    }];
                    [self.view layoutIfNeeded];
                }];
            }else {
                [self hiddenTipsView];
            }
        }];
        [self.view addSubview:self.tipsView];
        BOOL containsBool = [[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainContainsTeacher];
        self.tipsView.openCloseButton.selected = !containsBool;
        [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {//只有初次提醒为显示状态
            make.left.equalTo(self.view.mas_left).offset(containsBool ? (-kScreenWidth + 30.0f + 38.0f) :15.0f);
            make.width.mas_offset(kScreenWidth - 30.0f);
            make.top.equalTo(self.view.mas_top).offset(18.0f);
        }];
    }
}

- (void)requestForExamineContent {
    if (self.examineRequest) {
        [self.examineRequest stopRequest];
    }
    YXExamineRequest *request = [[YXExamineRequest alloc]init];
    request.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.w = [LSTSharedInstance sharedInstance].trainManager.currentProject.w;
    WEAK_SELF
    [request startRequestWithRetClass:[YXExamineRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        [self.tableView.mj_header endRefreshing];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = retItem != nil;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        [self dealWithRetItem:retItem];
    }];
    self.examineRequest = request;
    
}
- (void)dealWithRetItem:(YXExamineRequestItem *)retItem{
    self.examineItem = retItem;
    for (YXExamineRequestItem_body_leadingVo *vo in retItem.body.leadingVoList) {
        [self.foldStatusDic setValue:@(vo.isfinish.boolValue) forKey:vo.voID];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)showMarkWithOriginRect:(CGRect)rect{
    YXExamMarkView *v = [[YXExamMarkView alloc]init];
    v.originRect = rect;
    [v showInView:self.view];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.examineItem) {
        return 0;
    }
    return self.examineItem.body.leadingVoList.count + self.examineItem.body.bounsVoList.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section <= self.examineItem.body.leadingVoList.count){
        YXExamineRequestItem_body_leadingVo *vo = self.examineItem.body.leadingVoList[section-1];
        NSNumber *status = [self.foldStatusDic valueForKey:vo.voID];
        if (status.boolValue) {
            return 0;
        }
        return vo.toolExamineVoList.count+2;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YXExamTotalScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXExamTotalScoreCell"];
        cell.totalScore = self.examineItem.body.totalscore;
        cell.totalPoint = self.examineItem.body.bounstotal;
        [cell startAnimation];
        return cell;
    }else if (indexPath.section <= self.examineItem.body.leadingVoList.count){
        YXExamineRequestItem_body_leadingVo *vo = self.examineItem.body.leadingVoList[indexPath.section-1];
        if (indexPath.row == 0) {
            YXExamPhaseShadowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXExamPhaseShadowCell"];
            return cell;
        }else if (indexPath.row == vo.toolExamineVoList.count+1) {
            YXExamEndDateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXExamEndDateCell"];
            cell.date = vo.enddate;
            return cell;
        }else{
            YXExamProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXExamProgressCell"];
            cell.item = vo.toolExamineVoList[indexPath.row-1];
            WEAK_SELF
            cell.markAction = ^(UIButton *b){
                STRONG_SELF
                CGRect rect = [b convertRect:b.bounds toView:self.view];
                [self showMarkWithOriginRect:rect];
            };
            return cell;
        }
    }else{
        return nil;
    }
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        YXExamBlankHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXExamBlankHeaderFooterView"];
        return header;
    }else if (section <= self.examineItem.body.leadingVoList.count){
        YXExamineRequestItem_body_leadingVo *vo = self.examineItem.body.leadingVoList[section-1];
        NSNumber *status = [self.foldStatusDic valueForKey:vo.voID];
        YXExamPhaseHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXExamPhaseHeaderView"];
        header.title = vo.name;
        header.isFold = status.boolValue;
        header.isFinished = vo.isfinish.boolValue;
        WEAK_SELF
        header.actionBlock = ^{
            STRONG_SELF
            [self.foldStatusDic setValue:@(!status.boolValue) forKey:vo.voID];
            [tableView beginUpdates];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            [tableView endUpdates];
        };
        return header;
    }else{
        NSInteger index = section-1-self.examineItem.body.leadingVoList.count;
        YXExamineRequestItem_body_bounsVoData *data = self.examineItem.body.bounsVoList[index];
        YXExamTaskProgressHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXExamTaskProgressHeaderView"];
        header.data = data;
        WEAK_SELF
        header.markAction = ^(UIButton *b){
            STRONG_SELF
            CGRect rect = [b convertRect:b.bounds toView:self.view];
            [self showMarkWithOriginRect:rect];
        };
        header.clickAction = ^{
            if ([data.toolid isEqualToString:@"315"]||[data.toolid isEqualToString:@"215"]) { // 课程超市
                YXCourseViewController *vc = [[YXCourseViewController alloc]init];
                vc.status = YXCourseFromStatus_Market;
                [YXDataStatisticsManger trackEvent:@"课程列表" label:trackLabelOfJumpFromExeam parameters:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([data.toolid isEqualToString:@"201"]||[data.toolid isEqualToString:@"301"]) { // 课程
                YXCourseViewController *vc = [[YXCourseViewController alloc]init];
                vc.status = YXCourseFromStatus_Course;
                [self.navigationController pushViewController:vc animated:YES];
                [YXDataStatisticsManger trackEvent:@"课程列表" label:trackLabelOfJumpFromExeam parameters:nil];
            }else if ([data.toolid isEqualToString:@"217"]||[data.toolid isEqualToString:@"317"]) { //本地课程
                YXCourseViewController *vc = [[YXCourseViewController alloc]init];
                vc.status = YXCourseFromStatus_Local;
                [self.navigationController pushViewController:vc animated:YES];
                [YXDataStatisticsManger trackEvent:@"课程列表" label:trackLabelOfJumpFromExeam parameters:nil];
            }else if ([data.toolid isEqualToString:@"203"] || [data.toolid isEqualToString:@"303"]){//作业
                NSString *string = @"YXHomeworkListViewController";
                UIViewController *VC = [[NSClassFromString(string) alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
                [YXDataStatisticsManger trackEvent:@"作业列表" label:trackLabelOfJumpFromExeam parameters:nil];
            }else if ([data.toolid isEqualToString:@"205"] || [data.toolid isEqualToString:@"305"]){//研修总结
                NSString *string = @"YXHomeworkListViewController";
                UIViewController *VC = [[NSClassFromString(string) alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
                [YXDataStatisticsManger trackEvent:@"作业列表" label:trackLabelOfJumpFromExeam parameters:nil];
            }else if ([data.toolid isEqualToString:@"216"] || [data.toolid isEqualToString:@"316"]){//小组作业
                NSString *string = @"YXHomeworkListViewController";
                UIViewController *VC = [[NSClassFromString(string) alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
                [YXDataStatisticsManger trackEvent:@"作业列表" label:trackLabelOfJumpFromExeam parameters:nil];
            }else if ([data.toolid isEqualToString:@"202"] || [data.toolid isEqualToString:@"302"]){//活动
                ActivityListViewController *VC = [[ActivityListViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }else {
                [self showToast:@"相关功能暂未开放"];
            }
        };
        return header;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YXSectionHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat h = 115.f;
        if ([UIScreen mainScreen].bounds.size.width > 375) {
            h += 30.f;
        }
        return h;
    }else{
        YXExamineRequestItem_body_leadingVo *vo = self.examineItem.body.leadingVoList[indexPath.section-1];
        if (indexPath.row == vo.toolExamineVoList.count+1){
            return 44;
        }else if (indexPath.row == 0){
            return 0.1f;
        }
        return 76;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 101.0f;
    }
    if (section <= self.examineItem.body.leadingVoList.count){
        YXExamineRequestItem_body_leadingVo *vo = self.examineItem.body.leadingVoList[section-1];
        NSNumber *status = [self.foldStatusDic valueForKey:vo.voID];
        if (status.boolValue) {
            return 45;
        }
        else{
            return 45 + 25.0f;
        }
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YXExamTotalScoreCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.waveView =  [cell.waveView snapshotViewAfterScreenUpdates:NO];
        YXScoreViewController *vc = [[YXScoreViewController alloc]init];
        vc.data = self.examineItem.body;
        vc.title = @"成绩详情";
        vc.waveView = self.waveView;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section <= self.examineItem.body.leadingVoList.count){
        YXExamineRequestItem_body_leadingVo *vo = self.examineItem.body.leadingVoList[indexPath.section-1];
        if (indexPath.row>0 && indexPath.row<=vo.toolExamineVoList.count) {
            YXExamineRequestItem_body_toolExamineVo *data = vo.toolExamineVoList[indexPath.row-1];
            if ([data.toolid isEqualToString:@"201"]) { // 课程
                YXCourseViewController *vc = [[YXCourseViewController alloc]init];
                vc.stageID = vo.voID;
                vc.status = YXCourseFromStatus_Stage;
                [self.navigationController pushViewController:vc animated:YES];
                [YXDataStatisticsManger trackEvent:@"课程列表" label:trackLabelOfJumpFromExeam parameters:nil];
            }else if ([data.toolid isEqualToString:@"203"] || [data.toolid isEqualToString:@"303"]){//作业
                NSString *string = @"YXHomeworkListViewController";
                UIViewController *VC = [[NSClassFromString(string) alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
                [YXDataStatisticsManger trackEvent:@"作业列表" label:trackLabelOfJumpFromExeam parameters:nil];
            }else if ([data.toolid isEqualToString:@"205"] || [data.toolid isEqualToString:@"305"]){//研修总结
                NSString *string = @"YXHomeworkListViewController";
                UIViewController *VC = [[NSClassFromString(string) alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
                [YXDataStatisticsManger trackEvent:@"作业列表" label:trackLabelOfJumpFromExeam parameters:nil];
            }else if ([data.toolid isEqualToString:@"216"] || [data.toolid isEqualToString:@"316"]){//小组作业
                NSString *string = @"YXHomeworkListViewController";
                UIViewController *VC = [[NSClassFromString(string) alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
                [YXDataStatisticsManger trackEvent:@"作业列表" label:trackLabelOfJumpFromExeam parameters:nil];
            }else if ([data.toolid isEqualToString:@"202"] || [data.toolid isEqualToString:@"302"]){//活动
                ActivityListViewController *VC = [[ActivityListViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
                VC.stageID = vo.voID;
            }else if ([data.toolid isEqualToString:@"221"] || [data.toolid isEqualToString:@"321"]){//随堂练
                YXCourseViewController *vc = [[YXCourseViewController alloc]init];
                vc.stageID = vo.voID;
                vc.status = YXCourseFromStatus_Stage;
                [self.navigationController pushViewController:vc animated:YES];
                [YXDataStatisticsManger trackEvent:@"课程列表" label:trackLabelOfJumpFromExeam parameters:nil];
            }else{
                [self showToast:@"相关功能暂未开放"];
            }
        }
    }
}
- (void)startAnimation{
    YXExamTotalScoreCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell) {
        [cell startAnimation];
    }
}
- (void)report:(BOOL)status{
    if (status) {
        self.isSelected = YES;
    }else{
        self.isSelected = NO;
        [self hiddenTipsView];//借用上报规则
    }
    [YXDataStatisticsManger trackPage:trackPageName withStatus:status];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hiddenTipsView];
}
- (void)hiddenTipsView {
    self.tipsView.openCloseButton.selected = NO;
    [UIView animateWithDuration:0.3f animations:^{
        [self.tipsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(-kScreenWidth + 30.0f + 38.0f);
        }];
        [self.view layoutIfNeeded];
    }];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainContainsTeacher];

}
@end

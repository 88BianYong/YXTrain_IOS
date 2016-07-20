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
#import "MJRefresh.h"
#import "YXScoreViewController.h"
#import "YXExamMarkView.h"
#import "YXCourseViewController.h"

@interface YXExamViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXExamineRequest *request;
@property (nonatomic, strong) YXExamineRequestItem *examineItem;
@property (nonatomic, strong) NSMutableDictionary *foldStatusDic;
@property (nonatomic, strong) MJRefreshHeaderView *header;

@property (nonatomic, strong) YXErrorView *errorView;
@end

@implementation YXExamViewController

- (void)dealloc{
    [self.header free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"考核";
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self getData];
    };
    
    self.foldStatusDic = [NSMutableDictionary dictionary];
    [self setupUI];
    [self getData];
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
    [self.tableView registerClass:[YXExamEndDateCell class] forCellReuseIdentifier:@"YXExamEndDateCell"];
    [self.tableView registerClass:[YXExamProgressCell class] forCellReuseIdentifier:@"YXExamProgressCell"];
    [self.tableView registerClass:[YXExamTotalScoreCell class] forCellReuseIdentifier:@"YXExamTotalScoreCell"];
    [self.tableView registerClass:[YXExamPhaseShadowCell class] forCellReuseIdentifier:@"YXExamPhaseShadowCell"];
    [self.tableView registerClass:[YXExamPhaseHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXExamPhaseHeaderView"];
    [self.tableView registerClass:[YXExamBlankHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXExamBlankHeaderFooterView"];
    [self.tableView registerClass:[YXExamTaskProgressHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXExamTaskProgressHeaderView"];
    
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    WEAK_SELF
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self getData];
    };
}

- (void)getData{
    [self.request stopRequest];
    self.request = [[YXExamineRequest alloc]init];
    self.request.pid = [YXTrainManager sharedInstance].currentProject.pid;
    self.request.w = [YXTrainManager sharedInstance].currentProject.w;
    [self startLoading];
    WEAK_SELF
    [self.request startRequestWithRetClass:[YXExamineRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
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

- (void)dealWithRetItem:(YXExamineRequestItem *)retItem{
    self.examineItem = retItem;
    for (YXExamineRequestItem_body_leadingVo *vo in retItem.body.leadingVoList) {
        [self.foldStatusDic setValue:@(vo.isfinish.boolValue) forKey:vo.voID];
    }
    [self.tableView reloadData];
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
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
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
                vc.fromCourseMarket = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([data.toolid isEqualToString:@"201"]||[data.toolid isEqualToString:@"301"]) { // 课程
                YXCourseViewController *vc = [[YXCourseViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self showToast:@"相关功能暂未开放"];
            }
        };
        return header;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YXExamBlankHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXExamBlankHeaderFooterView"];
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
            return 25;
        }
        return 76;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
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
        YXScoreViewController *vc = [[YXScoreViewController alloc]init];
        vc.data = self.examineItem.body;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section <= self.examineItem.body.leadingVoList.count){
        YXExamineRequestItem_body_leadingVo *vo = self.examineItem.body.leadingVoList[indexPath.section-1];
        if (indexPath.row>0 && indexPath.row<=vo.toolExamineVoList.count) {
            YXExamineRequestItem_body_toolExamineVo *data = vo.toolExamineVoList[indexPath.row-1];
            if ([data.toolid isEqualToString:@"201"]) { // 课程
                YXCourseViewController *vc = [[YXCourseViewController alloc]init];
                vc.stageID = vo.voID;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self showToast:@"相关功能暂未开放"];
            }
        }
    }
}



@end

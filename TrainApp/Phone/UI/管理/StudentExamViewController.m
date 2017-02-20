//
//  StudentExamViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StudentExamViewController.h"
#import "YXExamProgressCell.h"
#import "YXExamTotalScoreCell.h"
#import "YXExamPhaseShadowCell.h"
#import "StudentExamPhaseHeaderView.h"
#import "YXExamBlankHeaderFooterView.h"
#import "StudentExamHeaderView.h"
#import "YXExamineRequest.h"
#import "MJRefresh.h"
#import "YXScoreViewController.h"
#import "YXExamMarkView.h"
#import "YXCourseViewController.h"
#import "ActivityListViewController.h"
@interface StudentExamViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXExamineRequest *request;
@property (nonatomic, strong) YXExamineRequestItem *examineItem;
@property (nonatomic, strong) NSMutableDictionary *foldStatusDic;
@property (nonatomic, strong) MJRefreshHeaderView *header;

@property (nonatomic,strong) UIView *waveView;
@property (nonatomic,assign) BOOL  isSelected;
@end

@implementation StudentExamViewController

- (void)dealloc{
    [self.header free];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isSelected = YES;
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForExamine];
    };
    
    self.foldStatusDic = [NSMutableDictionary dictionary];
    [self setupUI];
    [self startLoading];
    [self requestForExamine];
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
    [self.tableView registerClass:[YXExamProgressCell class] forCellReuseIdentifier:@"YXExamProgressCell"];
    [self.tableView registerClass:[YXExamTotalScoreCell class] forCellReuseIdentifier:@"YXExamTotalScoreCell"];
    [self.tableView registerClass:[YXExamPhaseShadowCell class] forCellReuseIdentifier:@"YXExamPhaseShadowCell"];
    [self.tableView registerClass:[StudentExamPhaseHeaderView class] forHeaderFooterViewReuseIdentifier:@"StudentExamPhaseHeaderView"];
    [self.tableView registerClass:[YXExamBlankHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXExamBlankHeaderFooterView"];
    [self.tableView registerClass:[StudentExamHeaderView class] forHeaderFooterViewReuseIdentifier:@"StudentExamHeaderView"];
    
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    WEAK_SELF
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self requestForExamine];
    };
}

- (void)requestForExamine{
    self.request = [[YXExamineRequest alloc]init];
    self.request.pid = [YXTrainManager sharedInstance].currentProject.pid;
    self.request.w = [YXTrainManager sharedInstance].currentProject.w;
    self.request.userId = self.userId;
    WEAK_SELF
    [self.request startRequestWithRetClass:[YXExamineRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        [self.header endRefreshing];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = retItem != nil;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
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
        return vo.toolExamineVoList.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YXExamTotalScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXExamTotalScoreCell"];
        cell.totalScore = self.examineItem.body.totalscore;
        cell.totalPoint = self.examineItem.body.bounstotal;
        return cell;
    }else if (indexPath.section <= self.examineItem.body.leadingVoList.count){
        YXExamineRequestItem_body_leadingVo *vo = self.examineItem.body.leadingVoList[indexPath.section-1];
        YXExamProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXExamProgressCell"];
        cell.item = vo.toolExamineVoList[indexPath.row];
        return cell;
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
        StudentExamPhaseHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"StudentExamPhaseHeaderView"];
        header.title = vo.name;
        header.isFinished = vo.isfinish.boolValue;
        return header;
    }else{
        NSInteger index = section-1-self.examineItem.body.leadingVoList.count;
        YXExamineRequestItem_body_bounsVoData *data = self.examineItem.body.bounsVoList[index];
        StudentExamHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"StudentExamHeaderView"];
        header.data = data;
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
        YXExamTotalScoreCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.waveView =  [cell.waveView snapshotViewAfterScreenUpdates:NO];
        YXScoreViewController *vc = [[YXScoreViewController alloc]init];
        vc.data = self.examineItem.body;
        vc.waveView = self.waveView;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end

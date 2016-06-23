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


@interface YXExamViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXExamineRequest *request;
@property (nonatomic, strong) YXExamineRequestItem *examineItem;
@property (nonatomic, strong) NSMutableDictionary *foldStatusDic;
@end

@implementation YXExamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"考核";
    self.foldStatusDic = [NSMutableDictionary dictionary];
    [self setupUI];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData{
    [self.request stopRequest];
    self.request = [[YXExamineRequest alloc]init];
    [self startLoading];
    WEAK_SELF
    [self.request startRequestWithRetClass:[YXExamineRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            [self showToast:error.localizedDescription];
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
        YXExamPhaseHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXExamPhaseHeaderView"];
        header.title = vo.name;
        WEAK_SELF
        header.actionBlock = ^{
            STRONG_SELF
            NSNumber *status = [self.foldStatusDic valueForKey:vo.voID];
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
        return header;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YXExamBlankHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXExamBlankHeaderFooterView"];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 115;
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
    
}

@end

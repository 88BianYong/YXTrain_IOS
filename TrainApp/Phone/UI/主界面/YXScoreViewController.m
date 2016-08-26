//
//  YXScoreViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXScoreViewController.h"
#import "YXScoreTotalScoreCell.h"
#import "YXScoreTypeCell.h"
#import "YXScorePhaseHeaderView.h"
#import "YXScoreBlankCell.h"
#import "YXScoreLeadScoreCell.h"
#import "YXScoreTaskScoreHeaderView.h"
#import "YXScoreExpHeaderView.h"
#import "YXScoreExpScoreCell.h"
#import "YXExamBlankHeaderFooterView.h"

@interface YXExpSubItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *score;
@end
@implementation YXExpSubItem
@end

@interface YXExpItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSArray *subItemArray;
@end
@implementation YXExpItem
@end

@interface YXScoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *expItemArray;
@end

@implementation YXScoreViewController

- (void)setData:(YXExamineRequestItem_body *)data{
    _data = data;
    self.expItemArray = [NSMutableArray array];
    // 贡献积分
    YXExpSubItem *item1 = [self expSubItemWithName:@"传资料" score:data.bounsVo.uploadRes];
    YXExpSubItem *item2 = [self expSubItemWithName:@"写日志" score:data.bounsVo.publishBlog];
    YXExpSubItem *item3 = [self expSubItemWithName:@"发问题" score:data.bounsVo.publishWenda];
    YXExpItem *expItem1 = [[YXExpItem alloc]init];
    expItem1.name = @"贡献积分";
    expItem1.score = data.bounsVo.bouns1;
    expItem1.subItemArray = @[item1,item2,item3];
    [self.expItemArray addObject:expItem1];
    // 活跃积分
    YXExpSubItem *item4 = [self expSubItemWithName:@"评论" score:data.bounsVo.comment];
    YXExpSubItem *item5 = [self expSubItemWithName:@"评分" score:data.bounsVo.mark];
    YXExpSubItem *item6 = [self expSubItemWithName:@"参与活动" score:data.bounsVo.joinActive];
    YXExpItem *expItem2 = [[YXExpItem alloc]init];
    expItem2.name = @"活跃积分";
    expItem2.score = data.bounsVo.bouns2;
    expItem2.subItemArray = @[item4,item5,item6];
    [self.expItemArray addObject:expItem2];
    // 魅力积分
    YXExpSubItem *item7 = [self expSubItemWithName:@"作业被推荐" score:data.bounsVo.tuiyouEdHomework];
    YXExpSubItem *item8 = [self expSubItemWithName:@"资源被下载" score:data.bounsVo.downloadEdRes];
    YXExpSubItem *item9 = [self expSubItemWithName:@"作业、日志被评论" score:data.bounsVo.commentEd];
    YXExpSubItem *item10 = [self expSubItemWithName:@"资源被推优" score:data.bounsVo.tuiyouEdResource];
    YXExpItem *expItem3 = [[YXExpItem alloc]init];
    expItem3.name = @"魅力积分";
    expItem3.score = data.bounsVo.bouns3;
    expItem3.subItemArray = @[item7,item8,item9,item10];
    [self.expItemArray addObject:expItem3];
}

- (YXExpSubItem *)expSubItemWithName:(NSString *)name score:(NSString *)score{
    YXExpSubItem *item = [[YXExpSubItem alloc]init];
    item.name = name;
    item.score = score;
    return item;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"成绩详情";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)setupUI{
    YXScoreTotalScoreCell *totalCell = [[YXScoreTotalScoreCell alloc]init];
    totalCell.data = self.data;
    [self.view addSubview:totalCell];
    [totalCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(190);
    }];
    [totalCell addSubview:self.waveView];
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalCell.mas_left);
        make.right.equalTo(totalCell.mas_right);
        make.bottom.equalTo(totalCell.mas_bottom);
        make.height.mas_equalTo(self.waveView.frame.size.height);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(totalCell.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [self.tableView registerClass:[YXScoreTotalScoreCell class] forCellReuseIdentifier:@"YXScoreTotalScoreCell"];
    [self.tableView registerClass:[YXScoreTypeCell class] forCellReuseIdentifier:@"YXScoreTypeCell"];
    [self.tableView registerClass:[YXScoreBlankCell class] forCellReuseIdentifier:@"YXScoreBlankCell"];
    [self.tableView registerClass:[YXScoreLeadScoreCell class] forCellReuseIdentifier:@"YXScoreLeadScoreCell"];
    [self.tableView registerClass:[YXScoreExpScoreCell class] forCellReuseIdentifier:@"YXScoreExpScoreCell"];
    [self.tableView registerClass:[YXScorePhaseHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXScorePhaseHeaderView"];
    [self.tableView registerClass:[YXScoreTaskScoreHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXScoreTaskScoreHeaderView"];
    [self.tableView registerClass:[YXScoreExpHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXScoreExpHeaderView"];
    [self.tableView registerClass:[YXExamBlankHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXExamBlankHeaderFooterView"];
    

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.leadingVoList.count + self.data.bounsVoList.count + 2 + self.expItemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section < self.data.leadingVoList.count+1){
        YXExamineRequestItem_body_leadingVo *vo = self.data.leadingVoList[section-1];
        return vo.toolExamineVoList.count+2;
    }else if (section < self.data.leadingVoList.count+1+self.data.bounsVoList.count){
        return 0;
    }else if (section < self.data.leadingVoList.count+2+self.data.bounsVoList.count){
        return 1;
    }else{
        NSInteger index = section-(self.data.leadingVoList.count+2+self.data.bounsVoList.count);
        YXExpItem *item = self.expItemArray[index];
        return item.subItemArray.count+2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YXScoreTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXScoreTypeCell"];
        cell.type = YXScoreCellType_Lead;
        return cell;
    }else if (indexPath.section < self.data.leadingVoList.count+1){
        YXExamineRequestItem_body_leadingVo *vo = self.data.leadingVoList[indexPath.section-1];
        if (indexPath.row == 0 || indexPath.row == vo.toolExamineVoList.count+1) {
            YXScoreBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXScoreBlankCell"];
            return cell;
        }else{
            YXScoreLeadScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXScoreLeadScoreCell"];
            cell.data = vo.toolExamineVoList[indexPath.row-1];
            return cell;
        }
    }else if (indexPath.section < self.data.leadingVoList.count+1+self.data.bounsVoList.count){
        return nil;
    }else if (indexPath.section < self.data.leadingVoList.count+2+self.data.bounsVoList.count){
        YXScoreTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXScoreTypeCell"];
        cell.type = YXScoreCellType_Exp;
        return cell;
    }else{
        YXExpItem *item = self.expItemArray[indexPath.section-(self.data.leadingVoList.count+2+self.data.bounsVoList.count)];
        if (indexPath.row == 0 || indexPath.row == item.subItemArray.count+1) {
            YXScoreBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXScoreBlankCell"];
            return cell;
        }else{
            YXScoreExpScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXScoreExpScoreCell"];
            YXExpSubItem *subItem = item.subItemArray[indexPath.row-1];
            cell.title = subItem.name;
            cell.score = subItem.score;
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else if (section < self.data.leadingVoList.count+1){
        YXScorePhaseHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXScorePhaseHeaderView"];
        YXExamineRequestItem_body_leadingVo *vo = self.data.leadingVoList[section-1];
        header.data = vo;
        return header;
    }else if (section < self.data.leadingVoList.count+1+self.data.bounsVoList.count){
        YXScoreTaskScoreHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXScoreTaskScoreHeaderView"];
        YXExamineRequestItem_body_bounsVoData *vo = self.data.bounsVoList[section-1-self.data.leadingVoList.count];
        header.data = vo;
        return header;
    }else if (section < self.data.leadingVoList.count+2+self.data.bounsVoList.count){
        return nil;
    }else {
        YXExpItem *item = self.expItemArray[section-(self.data.leadingVoList.count+2+self.data.bounsVoList.count)];
        YXScoreExpHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXScoreExpHeaderView"];
        header.title = item.name;
        header.score = item.score;
        return header;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else if (section < self.data.leadingVoList.count+1+self.data.bounsVoList.count){
        if (section == self.data.leadingVoList.count+1+self.data.bounsVoList.count-1) {
            return nil;
        }else{
            YXExamBlankHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXExamBlankHeaderFooterView"];
            return footer;
        }
    }else if (section < self.data.leadingVoList.count+2+self.data.bounsVoList.count){
        return nil;
    }else {
        YXExamBlankHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXExamBlankHeaderFooterView"];
        return footer;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 55;
    }else if (indexPath.section < self.data.leadingVoList.count+1){
        YXExamineRequestItem_body_leadingVo *vo = self.data.leadingVoList[indexPath.section-1];
        if (indexPath.row == 0 || indexPath.row == vo.toolExamineVoList.count+1) {
            return 8;
        }else{
            return 30;
        }
    }else if (indexPath.section < self.data.leadingVoList.count+1+self.data.bounsVoList.count){
        return 0;
    }else if (indexPath.section < self.data.leadingVoList.count+2+self.data.bounsVoList.count){
        return 55;
    }else{
        YXExpItem *item = self.expItemArray[indexPath.section-(self.data.leadingVoList.count+2+self.data.bounsVoList.count)];
        if (indexPath.row == 0 || indexPath.row == item.subItemArray.count+1) {
            return 8;
        }else{
            return 30;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else if (section < self.data.leadingVoList.count+1+self.data.bounsVoList.count){
        return 37;
    }else if (section < self.data.leadingVoList.count+2+self.data.bounsVoList.count){
        return 0.1;
    }else{
        return 37;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else if (section < self.data.leadingVoList.count+1+self.data.bounsVoList.count){
        if (section == self.data.leadingVoList.count+1+self.data.bounsVoList.count-1) {
            return 0.1;
        }else{
            return 5;
        }
    }else if (section < self.data.leadingVoList.count+2+self.data.bounsVoList.count){
        return 0.1;
    }else{
        return 5;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end

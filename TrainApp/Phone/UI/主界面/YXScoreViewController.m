//
//  YXScoreViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXScoreViewController.h"
#import "YXScoreTotalScoreHeaderView.h"
#import "YXScoreTypeHeaderView.h"

#import "YXScoreBlankCell.h"
#import "YXScoreBounsScoreCell.h"
#import "YXExamBlankHeaderFooterView.h"
#import "YXScoreLeadingGroupCell.h"
#import "YXScoreExpGroupCell.h"

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
    [self.tableView reloadData];
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
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
        self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
}

- (void)setupUI{
    YXScoreTotalScoreHeaderView *totalHeaderView = [[YXScoreTotalScoreHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190.0f)];
    totalHeaderView.data = self.data;
    [totalHeaderView addSubview:self.waveView];
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalHeaderView.mas_left);
        make.right.equalTo(totalHeaderView.mas_right);
        make.bottom.equalTo(totalHeaderView.mas_bottom);
        make.height.mas_equalTo(self.waveView.frame.size.height);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = totalHeaderView;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView registerClass:[YXScoreTypeHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXScoreTypeHeaderView"];
    [self.tableView registerClass:[YXScoreLeadingGroupCell class] forCellReuseIdentifier:@"YXScoreLeadingGroupCell"];
    [self.tableView registerClass:[YXScoreBounsScoreCell class] forCellReuseIdentifier:@"YXScoreBounsScoreCell"];
    [self.tableView registerClass:[YXScoreExpGroupCell class] forCellReuseIdentifier:@"YXScoreExpGroupCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger number = 1;
    if (self.data.leadingVoList.count + self.data.bounsVoList.count > 0) {
        number ++ ;
    }
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 && (self.data.leadingVoList.count + self.data.bounsVoList.count) > 0) {
        return self.data.leadingVoList.count + self.data.bounsVoList.count;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0  && (self.data.leadingVoList.count + self.data.bounsVoList.count) > 0) {
        if (indexPath.row < self.data.leadingVoList.count) {
            YXScoreLeadingGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXScoreLeadingGroupCell"];
            cell.data = self.data.leadingVoList[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            YXScoreBounsScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXScoreBounsScoreCell"];
            cell.data = self.data.bounsVoList[indexPath.row - self.data.leadingVoList.count];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else{
        YXScoreExpGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXScoreExpGroupCell"];
        cell.data = self.expItemArray[indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YXScoreTypeHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXScoreTypeHeaderView"];
    if (section == 0  && (self.data.leadingVoList.count + self.data.bounsVoList.count) > 0){
        headerView.type = YXScoreHeaderViewType_Lead;
    }
    else{
        headerView.type = YXScoreHeaderViewType_Exp;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0  && (self.data.leadingVoList.count + self.data.bounsVoList.count) > 0) {
        if (indexPath.row < self.data.leadingVoList.count) {
            YXExamineRequestItem_body_leadingVo *list = self.data.leadingVoList[indexPath.row];
            return 37.0f + list.toolExamineVoList.count * 30.0f + 5.0f;
        }else{
            return 35.0f;
        }
    }else{
        YXExpItem *item = self.expItemArray[indexPath.section];
        return 37.0f + item.subItemArray.count * 30.0f + 5.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end

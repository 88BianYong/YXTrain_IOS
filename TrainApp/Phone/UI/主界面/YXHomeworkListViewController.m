//
//  YXHomeworkListViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHomeworkListViewController.h"
#import "YXHomeworkListRequest.h"
#import "YXHomeworkListCell.h"
#import "YXHomeworkListHeaderView.h"
#import "YXHomeworkPromptView.h"
#import "YXHomeworkInfoViewController.h"
@interface YXHomeworkListViewController ()
<
  UITableViewDelegate,
  UITableViewDataSource
>
{
    UITableView * _tableView;
    YXHomeworkPromptView *_promptView;
    
    YXHomeworkListRequestItem *_listItem;
    
    YXHomeworkListRequest *_listRequest;
    
}
@end

@implementation YXHomeworkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.title = @"作业列表";
    [self setupUI];
    [self layoutInterface];
    [self requestForHomeworkList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI

- (void)setupUI{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[YXHomeworkListCell class] forCellReuseIdentifier:@"YXHomeworkListCell"];
    [_tableView registerClass:[YXHomeworkListHeaderView class] forHeaderFooterViewReuseIdentifier:@"YXHomeworkListHeaderView"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10.0f)];
    _tableView.tableHeaderView = headerView;
    [self.view addSubview:_tableView];
    
    _promptView = [[YXHomeworkPromptView alloc] init];
    _promptView.hidden = YES;
    [self.view addSubview:_promptView];
    
}

- (void)layoutInterface{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(5.0f);
        make.right.equalTo(self.view.mas_right).offset(-5.0f);
    }];
    
    [_promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YXHomeworkListHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXHomeworkListHeaderView"];
    YXHomeworkListRequestItem_Body_Stages *stages = (YXHomeworkListRequestItem_Body_Stages *)_listItem.body.stages[section];
    view.titleString = stages.subject;
    view.isLast = stages.homeworks.count == 0 ? YES : NO;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YXHomeworkListRequestItem_Body_Stages *stages = (YXHomeworkListRequestItem_Body_Stages *)_listItem.body.stages[indexPath.section];
    YXHomeworkListRequestItem_Body_Stages_Homeworks *homework = stages.homeworks[indexPath.row];
    YXHomeworkInfoViewController *VC = [[YXHomeworkInfoViewController alloc] init];
    VC.requireid =  homework.requireId;
    VC.hwid = homework.homeworkid;
    VC.titleString = homework.title;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listItem.body.stages.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YXHomeworkListRequestItem_Body_Stages *stages = (YXHomeworkListRequestItem_Body_Stages *)_listItem.body.stages[section];
    return stages.homeworks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHomeworkListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeworkListCell" forIndexPath:indexPath];
    YXHomeworkListRequestItem_Body_Stages *stages = (YXHomeworkListRequestItem_Body_Stages *)_listItem.body.stages[indexPath.section];
    cell.homework = stages.homeworks[indexPath.row];
    cell.isLast = indexPath.row == (stages.homeworks.count - 1) ? YES : NO;
    return cell;
}


#pragma mark - request
- (void)requestForHomeworkList{
    YXHomeworkListRequest *request = [[YXHomeworkListRequest alloc] init];
    request.pid = [YXTrainManager sharedInstance].currentProject.pid;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXHomeworkListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            
        }else{
            YXHomeworkListRequestItem *item = retItem;
            self -> _listItem = item;
            [_tableView reloadData];
        }
    }];
    _listRequest = request;
}
@end

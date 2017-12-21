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
#import "YXHomeworkInfoViewController.h"
static  NSString *const trackPageName = @"作业列表页面";
@interface YXHomeworkListViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView * _tableView;
    
    YXHomeworkListRequestItem *_listItem;
    
    YXHomeworkListRequest *_listRequest;
    
}
@end

@implementation YXHomeworkListViewController
- (void)dealloc{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.title = @"作业列表";
    if ([self isJudgmentChooseCourse]) {
        [self setupUI];
        [self layoutInterface];
        [self startLoading];
        [self requestForHomeworkList];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (BOOL)isJudgmentChooseCourse{
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.isOpenTheme.boolValue) {
        self.emptyView = [[YXEmptyView alloc]init];
        self.emptyView.title = @"请先等待主题选学";
        self.emptyView.imageName = @"没选课";
        [self.view addSubview:self.emptyView];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        return NO;
    }else {
        return YES;
    }
}

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
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForHomeworkList];
    };
    _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        STRONG_SELF
        [self requestForHomeworkList];
    }];
}

- (void)layoutInterface{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(5.0f);
        make.right.equalTo(self.view.mas_right).offset(-5.0f);
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
    view.titleString = stages.name;
    view.isLast = stages.homeworks.count == 0 ? YES : NO;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YXHomeworkListRequestItem_Body_Stages *stages = (YXHomeworkListRequestItem_Body_Stages *)_listItem.body.stages[indexPath.section];
    if (stages.homeworks.count > 0) {
        YXHomeworkInfoRequestItem_Body *homework = stages.homeworks[indexPath.row];
        homework.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
        YXHomeworkInfoViewController *VC = [[YXHomeworkInfoViewController alloc] init];
        VC.itemBody = homework;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listItem.body.stages.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    YXHomeworkListRequestItem_Body_Stages *stages = (YXHomeworkListRequestItem_Body_Stages *)_listItem.body.stages[section];
    return MAX(stages.homeworks.count, 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXHomeworkListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeworkListCell" forIndexPath:indexPath];
    YXHomeworkListRequestItem_Body_Stages *stages = (YXHomeworkListRequestItem_Body_Stages *)_listItem.body.stages[indexPath.section];
    if (stages.homeworks.count == 0) {
        cell.homework = nil;
        cell.isLast = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.homework = stages.homeworks[indexPath.row];
        cell.isLast = indexPath.row == (stages.homeworks.count - 1) ? YES : NO;
        cell.isFirst = indexPath.row == 0 ? YES : NO;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return cell;
}


#pragma mark - request
- (void)requestForHomeworkList{
    YXHomeworkListRequest *request = [[YXHomeworkListRequest alloc] init];
    request.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;

    WEAK_SELF
    [request startRequestWithRetClass:[YXHomeworkListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        [self->_tableView.mj_header endRefreshing];
        
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = retItem != nil;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        YXHomeworkListRequestItem *item = retItem;
        self -> _listItem = item;
        [self ->_tableView reloadData];
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainFirstGoInHomeworkList]) {
            static NSString * staticString = @"YXHomeworkPromptView";
            UIView *promptView = [[NSClassFromString(staticString) alloc] init];
            [self.view addSubview:promptView];
            [promptView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainFirstGoInHomeworkList];
        }
    }];
    _listRequest = request;
}
@end

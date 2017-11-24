//
//  YXTaskViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTaskViewController.h"
#import "YXCourseViewController.h"
#import "YXTaskCell.h"
#import "YXTaskListRequest.h"
#import "ActivityListViewController.h"
#import "YXHomeworkInfoRequest.h"
#import "YXHomeworkInfoViewController.h"
#import "BeijingActivityListViewController.h"
#import "BeijingCourseViewController.h"
static  NSString *const trackPageName = @"任务列表页面";
static  NSString *const trackLabelOfJumpFromTaskList = @"任务跳转";
@interface YXTaskViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXTaskListRequest *request;
@property (nonatomic, strong) YXTaskListRequestItem *tasklistItem;
@property (nonatomic,assign) BOOL  isSelected;
@end

@implementation YXTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"任务";
    self.isSelected = NO;
    
    [self loadCache];
    [self setupUI];
    [self getData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isSelected) {
        [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor colorWithHexString:@"334466"], NSForegroundColorAttributeName,
                                                                     [UIFont boldSystemFontOfSize:17], NSFontAttributeName,
                                                                     nil]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isSelected) {
        [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor colorWithHexString:@"334466"], NSForegroundColorAttributeName,
                                                                     [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                                     nil]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.rowHeight = 53;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[YXTaskCell class] forCellReuseIdentifier:@"YXTaskCell"];
   [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self getData];
    };
    self.emptyView = [[YXEmptyView alloc]init];
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self getData];
    };
}

- (void)getData{
    [self.request stopRequest];
    self.request = [[YXTaskListRequest alloc]init];
    self.request.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    self.request.w = [LSTSharedInstance sharedInstance].trainManager.currentProject.w;
    [self startLoading];
    WEAK_SELF
    [self.request startRequestWithRetClass:[YXTaskListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        YXTaskListRequestItem *item = (YXTaskListRequestItem *)retItem;
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = item.body.tasks.count != 0;
        data.localDataExist = self.tasklistItem.body.tasks.count != 0;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        
        self.tasklistItem = retItem;
        [self.tableView reloadData];
        [self saveToCache];
    }];
}

#pragma mark - Cache
- (void)loadCache{
    NSString *json = [[NSUserDefaults standardUserDefaults]valueForKey:@"kTaskListKey"];
    if (json) {
        YXTaskListRequestItem *item = [[YXTaskListRequestItem alloc]initWithString:json error:nil];
        self.tasklistItem = item;
    }
}

- (void)saveToCache{
    [[NSUserDefaults standardUserDefaults]setValue:[self.tasklistItem toJSONString] forKey:@"kTaskListKey"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tasklistItem.body.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXTaskCell"];
    YXTaskListRequestItem_body_task *task = self.tasklistItem.body.tasks[indexPath.row];
    cell.task = task;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXSectionHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXTaskListRequestItem_body_task *task = self.tasklistItem.body.tasks[indexPath.row];
    if (task.toolid.integerValue == 201) {
        [[LSTSharedInstance sharedInstance].trainManager.trainHelper courseInterfaceSkip:self];
    }else if ([task.toolid isEqualToString:@"203"] || [task.toolid isEqualToString:@"303"]){//作业
        [[LSTSharedInstance sharedInstance].trainManager.trainHelper workshopInterfaceSkip:self];
    }else if ([task.toolid isEqualToString:@"205"] || [task.toolid isEqualToString:@"305"]){//研修总结
        NSString *string = @"YXHomeworkListViewController";
        UIViewController *VC = [[NSClassFromString(string) alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        [YXDataStatisticsManger trackEvent:@"作业列表" label:trackLabelOfJumpFromTaskList parameters:nil];
    }else if ([task.toolid isEqualToString:@"202"] || [task.toolid isEqualToString:@"302"]){//活动
        [[LSTSharedInstance sharedInstance].trainManager.trainHelper activityInterfaceSkip:self];
    }else{
        [self showToast:@"相关功能暂未开放"];
    }
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

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
static  NSString *const trackPageName = @"任务列表页面";
@interface YXTaskViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXTaskListRequest *request;
@property (nonatomic, strong) YXTaskListRequestItem *tasklistItem;

@property (nonatomic, strong) YXErrorView *errorView;
@property (nonatomic, strong) YXEmptyView *emptyView;
@end

@implementation YXTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"任务";
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self getData];
    };
    self.emptyView = [[YXEmptyView alloc]initWithFrame:self.view.bounds];
    
    [self loadCache];
    [self setupUI];
    [self getData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor colorWithHexString:@"334466"], NSForegroundColorAttributeName,
                                                          [UIFont boldSystemFontOfSize:17], NSFontAttributeName,
                                                          nil]];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor colorWithHexString:@"334466"], NSForegroundColorAttributeName,
                                                                     [UIFont systemFontOfSize:17], NSFontAttributeName,
                                                                     nil]];
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
}

- (void)getData{
    [self.request stopRequest];
    self.request = [[YXTaskListRequest alloc]init];
    self.request.pid = [YXTrainManager sharedInstance].currentProject.pid;
    self.request.w = [YXTrainManager sharedInstance].currentProject.w;
    [self startLoading];
    WEAK_SELF
    [self.request startRequestWithRetClass:[YXTaskListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            if (error.code == -2) {
                self.emptyView.frame = self.view.bounds;
                self.emptyView.imageName = @"数据错误";
                self.emptyView.title = @"数据错误";
                [self.view addSubview:self->_emptyView];
            }else if (self.tasklistItem.body.tasks.count == 0) {
                self.errorView.frame = self.view.bounds;
                [self.view addSubview:self.errorView];
            }else{
                [self showToast:error.localizedDescription];
            }
            return;
        }
        YXTaskListRequestItem *item = (YXTaskListRequestItem *)retItem;
        if (item.body.tasks.count == 0) {
            self.emptyView.frame = self.view.bounds;
            [self.view addSubview:self.emptyView];
            return;
        }
        [self.errorView removeFromSuperview];
        [self.emptyView removeFromSuperview];
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXTaskListRequestItem_body_task *task = self.tasklistItem.body.tasks[indexPath.row];
    if (task.toolid.integerValue == 201) {
        YXCourseViewController *vc = [[YXCourseViewController alloc]init];
        vc.status = YXCourseFromStatus_Course;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([task.toolid isEqualToString:@"203"] || [task.toolid isEqualToString:@"303"]){//作业
        NSString *string = @"YXHomeworkListViewController";
        UIViewController *VC = [[NSClassFromString(string) alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if ([task.toolid isEqualToString:@"205"] || [task.toolid isEqualToString:@"305"]){//研修总结
        NSString *string = @"YXHomeworkListViewController";
        UIViewController *VC = [[NSClassFromString(string) alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        [self showToast:@"相关功能暂未开放"];
    }
}

@end

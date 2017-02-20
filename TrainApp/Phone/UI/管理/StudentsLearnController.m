//
//  StudentsLearnController.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "StudentsLearnController.h"
#import "StudentsLearnSwipeCell.h"
#import "StudentsLearnTableHeaderView.h"
#import "StudentsLearnFilterView.h"
#import "MasterManageListRequest.h"
#import "LearningInfoListFetcher.h"
#import "StudentExamViewController.h"
#import "MasterRemindStudyRequest.h"
@interface StudentsLearnController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) StudentsLearnTableHeaderView *headerView;
@property (nonatomic, strong) StudentsLearnFilterView *filterView;
@property (nonatomic, strong) YXErrorView *filterErrorView;
@property (nonatomic, strong) DataErrorView *filterDataErrorView;
@property (nonatomic, strong) MasterManageListRequest *listRequest;
@property (nonatomic, strong) MasterRemindStudyRequest *studyRequest;
@property (nonatomic, strong) UIButton *batchButton;
@property (nonatomic, strong) NSMutableSet *userIdSet;

@property (nonatomic, assign) BOOL isWaitingForFilter;
@property (nonatomic, assign) BOOL isBatchBool;
@property (nonatomic, assign) UIButton *remindButton;
@end

@implementation StudentsLearnController
- (void)dealloc {
    
}

- (void)viewDidLoad {
    [self setupFetcher];
    self.isWaitingForFilter = YES;
    [super viewDidLoad];
    self.userIdSet = [[NSMutableSet alloc] init];
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.title = @"管理";
    [self setupUI];
    [self setupLayout];
    [self requestForLearningInfo];
}
- (void)setupFetcher {
    LearningInfoListFetcher *fetcher = [[LearningInfoListFetcher alloc]init];
    fetcher.projectId = [YXTrainManager sharedInstance].currentProject.pid;
    fetcher.pageindex = 1;
    WEAK_SELF
    [fetcher setLearningInfoListFetcherBlock:^(MasterLearningInfoListRequestItem_Body *body) {
        STRONG_SELF
        self.headerView.body = body;
        self.headerView.hidden = NO;
    }];
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setup UI
- (void)setupUI {
    self.filterView = [[StudentsLearnFilterView alloc] init];
    self.filterView.backgroundColor =[UIColor whiteColor];
    self.filterView.hidden = YES;
    WEAK_SELF
    [self.filterView setStudentsLearnFilterSchoolBlock:^(NSString *baridString) {
        STRONG_SELF
        LearningInfoListFetcher *fetcher = (LearningInfoListFetcher *)self.dataFetcher;
        fetcher.barId = baridString;
        [self startLoading];
        [self firstPageFetch];
    }];
    [self.filterView setStudentsLearnFilterConditionBlock:^(NSDictionary *dictionary) {
        STRONG_SELF
        LearningInfoListFetcher *fetcher = (LearningInfoListFetcher *)self.dataFetcher;
        fetcher.ifhg = dictionary[@"ifhg"];
        fetcher.ifcx = dictionary[@"ifcx"];
        fetcher.ifxx = dictionary[@"ifxx"];
        [self startLoading];
        [self firstPageFetch];
    }];
    [self.view addSubview:self.filterView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.tableView registerClass:[StudentsLearnSwipeCell class] forCellReuseIdentifier:@"StudentsLearnSwipeCell"];
    self.headerView = [[StudentsLearnTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150.0f)];
    self.headerView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
    self.remindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.remindButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateNormal];
    [self.remindButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f3f7fa"]] forState:UIControlStateDisabled];
    [self.remindButton setTitle:@"提醒学习" forState:UIControlStateNormal];
    self.remindButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.remindButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.remindButton setTitleColor:[UIColor colorWithHexString:@"a1a7ae"]
                            forState:UIControlStateDisabled];
    self.remindButton.enabled = NO;
    self.remindButton.hidden = YES;
    [[self.remindButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self requestForRemindStudy];
    }];
    [self.view addSubview:self.remindButton];
    self.batchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.batchButton setImage:[UIImage imageNamed:@"批量操作icon"] forState:UIControlStateNormal];
    [self.batchButton setImage:[UIImage imageNamed:@"批量操作icon"] forState:UIControlStateHighlighted];
    [self.batchButton addTarget:self action:@selector(buttonBatchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.batchButton];
    self.filterErrorView = [[YXErrorView alloc]initWithFrame:self.view.bounds];
    self.filterErrorView.retryBlock = ^{
        STRONG_SELF
        [self requestForLearningInfo];
    };
    self.filterDataErrorView = [[DataErrorView alloc] initWithFrame:self.view.bounds];
    self.filterDataErrorView.refreshBlock = ^ {
        STRONG_SELF
        [self requestForLearningInfo];
    };
    self.emptyView.title = @"没有符合条件的内容";
    self.emptyView.imageName = @"没有符合条件的课程";
    
}
- (void)setupLayout {
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_offset(44.0f);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(44.0f);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.batchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-5.0f);
        make.bottom.equalTo(self.view.mas_bottom).offset(-25.0f);
        make.size.mas_offset(CGSizeMake(95.0f, 50.0f));
    }];
    
    [self.remindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(44.0f);
    }];
}
- (void)tableViewWillRefresh {
    self.headerView.hidden = NO;
}
- (void)setIsBatchBool:(BOOL)isBatchBool {
    _isBatchBool = isBatchBool;
    if (_isBatchBool) {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        self.batchButton.hidden = YES;
        self.filterView.hidden = YES;
        self.remindButton.hidden = NO;
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom).offset(-44.0f);
        }];
    }else {
        [self setupLeftBack];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(44.0f);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        self.tableView.tableHeaderView = self.headerView;
        self.batchButton.hidden = NO;
        self.filterView.hidden = NO;
        self.remindButton.hidden = YES;
        self.tableView.tableFooterView = nil;
    }
    for (StudentsLearnSwipeCell *cell in [self.tableView visibleCells]) {
        [cell setupModeEditable:self.isBatchBool];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentsLearnSwipeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentsLearnSwipeCell" forIndexPath:indexPath];
    cell.learningInfo = self.dataArray[indexPath.row];
    [cell setupModeEditable:self.isBatchBool];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  @"提醒学";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterLearningInfoListRequestItem_Body_LearningInfoList *info = self.dataArray[indexPath.row];
    [self.userIdSet addObject:info.userid];
    [self requestForRemindStudy];
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.editing) {
        return UITableViewCellEditingStyleDelete;
    }else {
        return UITableViewCellEditingStyleNone;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterLearningInfoListRequestItem_Body_LearningInfoList *info = self.dataArray[indexPath.row];
    if (self.isBatchBool) {
        StudentsLearnSwipeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.isChooseBool = !cell.isChooseBool;
        if (cell.isChooseBool) {
            [self.userIdSet addObject:info.userid];
        }else {
            [self.userIdSet removeObject:info.userid];
        }
        self.remindButton.enabled = self.userIdSet.count > 0;
    }else  {
        StudentExamViewController *VC = [[StudentExamViewController alloc] init];
        VC.userId = info.userid;
        VC.title = info.realname;
        [self.navigationController pushViewController:VC animated:YES];
    }
}
#pragma mark - button Action
- (void)buttonBatchAction:(UIButton *)sender {
    self.isBatchBool = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.frame = CGRectMake(0, 0, 50.0f, 30.0f);
    WEAK_SELF
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        self.isBatchBool = NO;
    }];
    [self setupLeftWithCustomView:button];

}
#pragma mark - request
- (void)requestForLearningInfo {
    self.listRequest = [[MasterManageListRequest alloc] init];
    self.listRequest.projectId = [YXTrainManager sharedInstance].currentProject.pid;
    [self startLoading];
    WEAK_SELF
    [self.listRequest startRequestWithRetClass:[MasterManageListRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self stopLoading];
            if (error.code == 2) {
                self.filterDataErrorView.frame = self.view.bounds;
                [self.view addSubview:self.filterDataErrorView];
            }else {
                self.filterErrorView.frame = self.view.bounds;
                [self.view addSubview:self.filterErrorView];
            }
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            return;
        }
        self.filterView.hidden = NO;
        [self.filterErrorView removeFromSuperview];
        [self.filterDataErrorView removeFromSuperview];
        MasterManageListRequestItem *item = retItem;
        self.filterView.groups = item.body.groups;
        self.isWaitingForFilter = NO;
        LearningInfoListFetcher *fetcher = (LearningInfoListFetcher *)self.dataFetcher;
        fetcher.ifhg = @"0";
        fetcher.ifcx = @"0";
        fetcher.ifxx = @"0";
        MasterManageListRequestItem_Body_Group *grop = item.body.groups[0];
        fetcher.barId = grop.barid;
        [self firstPageFetch];
    }];
}
- (void)requestForRemindStudy {
    MasterRemindStudyRequest *request = [[MasterRemindStudyRequest alloc] init];
    request.projectId = [YXTrainManager sharedInstance].currentProject.pid;
    request.userIds = [[self.userIdSet allObjects] componentsJoinedByString:@","];
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = YES;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        for (MasterLearningInfoListRequestItem_Body_LearningInfoList *info in self.dataArray) {
            info.isChoose = @"0";
        }
        [self.userIdSet removeAllObjects];
        self.isBatchBool = NO;
        [self.tableView reloadData];
        [self showToast:@"发送成功"];
    }];
    self.studyRequest = request;
}
- (void)firstPageFetch {
    if (self.isWaitingForFilter) {
        return;
    }
    [super firstPageFetch];
}
@end

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
@interface StudentsLearnController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) StudentsLearnTableHeaderView *headerView;
@property (nonatomic, strong) StudentsLearnFilterView *filterView;
@property (nonatomic, strong) YXErrorView *filterErrorView;
@property (nonatomic, strong) DataErrorView *filterDataErrorView;
@property (nonatomic, strong) MasterManageListRequest *listRequest;
@property (nonatomic, strong) UIButton *batchButton;
@property (nonatomic, assign) BOOL isWaitingForFilter;
@end

@implementation StudentsLearnController
- (void)dealloc {
    
}

- (void)viewDidLoad {
    [self setupFetcher];
    self.isWaitingForFilter = YES;
    [super viewDidLoad];
    self.title = @"管理";
    [self setupUI];
    [self setupLayout];
    [self requestForLearningInfo];
}
- (void)setupFetcher {
    LearningInfoListFetcher *fetcher = [[LearningInfoListFetcher alloc]init];
    fetcher.projectId = [YXTrainManager sharedInstance].currentProject.pid;
    WEAK_SELF
    [fetcher setLearningInfoListFetcherBlock:^(MasterLearningInfoListRequestItem_Body *body) {
        STRONG_SELF
        self.headerView.body = body;
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
    self.tableView.tableHeaderView = self.headerView;
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
    self.emptyView.title = @"没有符合条件的活动";
    self.emptyView.imageName = @"没有符合条件的课程";
    
}
- (void)setupLayout {
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_offset(44.0f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(44.0f);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.batchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-5.0f);
        make.bottom.equalTo(self.view.mas_bottom).offset(-25.0f);
        make.size.mas_offset(CGSizeMake(90.0f, 50.0f));
    }];
    [self stopLoading];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
        }];
        self.tableView.tableHeaderView = nil;
        self.batchButton.hidden = YES;
        self.filterView.hidden = YES;
    }else {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(44.0f);
        }];
        self.tableView.tableHeaderView = self.headerView;
        self.batchButton.hidden = NO;
        self.filterView.hidden = NO;
    }
    [self.tableView reloadData];
    
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
    [cell setupModeEditable:self.editing];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86.0f;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  @"提醒学习";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    self.editing = YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.editing) {
        return UITableViewCellEditingStyleDelete;
    }else {
        return UITableViewCellEditingStyleNone;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentsLearnSwipeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isChooseBool = !cell.isChooseBool;
}
#pragma mark - button Action
- (void)buttonBatchAction:(UIButton *)sender {
    self.editing = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"334466"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.frame = CGRectMake(0, 0, 50.0f, 30.0f);
    WEAK_SELF
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        self.editing = NO;
        [self setupLeftBack];
    }];
    [self setupLeftWithCustomView:button];

}
#pragma mark - request
- (void)requestForLearningInfo {
    self.listRequest = [[MasterManageListRequest alloc] init];
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
@end

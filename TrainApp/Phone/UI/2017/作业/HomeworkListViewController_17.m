//
//  HomeworkListViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "HomeworkListViewController_17.h"
#import "HomeworkListRequest_17.h"
#import "YXHomeworkListCell.h"
#import "HomeworkListDefaultCell_17.h"
#import "YXHomeworkInfoViewController.h"
#import "HomeworkListHeaderView_17.h"
#import "HomeworkListClaimCell_17.h"
#import "HomeworkListVideoDefaultCell_17.h"
#import "HomeworkListFooterView_17.h"
#import "YXHomeworkInfoRequest.h"
#import "HomeworkFloatingView_17.h"
#import "YXMyExamExplainView_17.h"
#import "HomeworkListGroupCell_17.h"
#import "HomeworkListVideoSpecialCell_17.h"
#import "MJRefresh.h"
@interface HomeworkListViewController_17 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) HomeworkListRequest_17 *listRequest;
@property (nonatomic, strong) HomeworkListRequest_17Item *listItem;
@end

@implementation HomeworkListViewController_17

- (void)dealloc{
    [_header free];
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
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - set
- (void)setListItem:(HomeworkListRequest_17Item *)listItem {
    _listItem = listItem;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kYXTrainFirstGoInHomeworkList_17]) {
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        HomeworkFloatingView_17 *floatingView = [[HomeworkFloatingView_17 alloc] init];
        [window addSubview:floatingView];
        [floatingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(window);
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kYXTrainFirstGoInHomeworkList_17];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
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
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[HomeworkListDefaultCell_17 class] forCellReuseIdentifier:@"HomeworkListDefaultCell_17"];
    [self.tableView registerClass:[HomeworkListClaimCell_17 class] forCellReuseIdentifier:@"HomeworkListClaimCell_17"];
    [self.tableView registerClass:[HomeworkListVideoDefaultCell_17 class] forCellReuseIdentifier:@"HomeworkListVideoDefaultCell_17"];
    [self.tableView registerClass:[HomeworkListHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"HomeworkListHeaderView_17"];
    [self.tableView registerClass:[HomeworkListFooterView_17 class] forHeaderFooterViewReuseIdentifier:@"HomeworkListFooterView_17"];
    [self.tableView registerClass:[HomeworkListGroupCell_17 class] forCellReuseIdentifier:@"HomeworkListGroupCell_17"];
    [self.tableView registerClass:[HomeworkListVideoSpecialCell_17 class] forCellReuseIdentifier:@"HomeworkListVideoSpecialCell_17"];
    [self.view addSubview:self.tableView];
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForHomeworkList];
    };
    
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForHomeworkList];
    };
    
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableView;
    _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        STRONG_SELF
        [self requestForHomeworkList];
    };
}

- (void)layoutInterface{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HomeworkListHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HomeworkListHeaderView_17"];
    if (section == 0) {
        headerView.titleString = @"考核要求";
    }else {
        headerView.titleString = @"作业";
    }
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60.0f;
    }else {
        HomeworkListRequest_17Item_Homeworks *homework = self.listItem.homeworks[indexPath.row];
        if (homework.toolID.integerValue == 218 || homework.toolID.integerValue == 318) {
            return 45.0f;
        }else if (homework.templateID.integerValue == 324) {
            return [tableView fd_heightForCellWithIdentifier:@"HomeworkListDefaultCell_17" cacheByIndexPath:indexPath configuration:^(HomeworkListDefaultCell_17 *cell) {
                cell.homework = self.listItem.homeworks[indexPath.row];
            }];
        }else if (homework.templateID.integerValue == 379 || homework.homeworkID.integerValue == 0) {
            return 45.0f;
        }else{
            return [tableView fd_heightForCellWithIdentifier:@"HomeworkListVideoSpecialCell_17" cacheByIndexPath:indexPath configuration:^(HomeworkListVideoSpecialCell_17 *cell) {
                cell.homework = self.listItem.homeworks[indexPath.row];
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 15.0f;
    }else {
        return 0.0001f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        HomeworkListFooterView_17 *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HomeworkListFooterView_17"];
        return footerView;
    }else {
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0){
        return;
    }
    HomeworkListRequest_17Item_Homeworks *homework = self.listItem.homeworks[indexPath.row];
    if (homework.templateID.integerValue == 379) {
        HomeworkListRequest_17Item_Homeworks *homework = self.listItem.homeworks[indexPath.row];
        YXHomeworkInfoRequestItem_Body *body = [[YXHomeworkInfoRequestItem_Body alloc] init];
        body.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
        body.requireId = homework.rID;
        body.homeworkid = homework.homeworkID;
        YXHomeworkInfoViewController *VC = [[YXHomeworkInfoViewController alloc] init];
        VC.itemBody = body;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.listItem.scheme.count;
    }else {
        return self.listItem.homeworks.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeworkListClaimCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkListClaimCell_17" forIndexPath:indexPath];
        cell.scheme = self.listItem.scheme[indexPath.row];
        WEAK_SELF
        cell.homeworkListClaimButtonBlock = ^(UIButton *sender) {
            STRONG_SELF
            YXMyExamExplainView_17 *v = [[YXMyExamExplainView_17 alloc]init];
            CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
            [v showInView:self.navigationController.view examExplain:@"小组作业线下完成,由组长线上提交"];
            [v setupOriginRect:rect withToTop:YES]; 
        };
        return cell;
    }else {
        HomeworkListRequest_17Item_Homeworks *homework = self.listItem.homeworks[indexPath.row];
        if (homework.toolID.integerValue == 218 || homework.toolID.integerValue == 318) {
            HomeworkListGroupCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkListGroupCell_17" forIndexPath:indexPath];
            return cell;
            
        }else if (homework.templateID.integerValue == 324) {
            HomeworkListDefaultCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkListDefaultCell_17" forIndexPath:indexPath];
            cell.homework = self.listItem.homeworks[indexPath.row];
            return cell;
        }else if (homework.templateID.integerValue == 379 || homework.homeworkID.integerValue == 0) {
            HomeworkListVideoDefaultCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkListVideoDefaultCell_17" forIndexPath:indexPath];
            cell.homework = self.listItem.homeworks[indexPath.row];
            return cell;
        }else{
            HomeworkListVideoSpecialCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkListVideoSpecialCell_17" forIndexPath:indexPath];
            cell.homework = self.listItem.homeworks[indexPath.row];
            return cell;
        }
    }
}


#pragma mark - request
- (void)requestForHomeworkList{
    HomeworkListRequest_17 *request = [[HomeworkListRequest_17 alloc] init];
    request.stageID = self.stageString;
    request.toolID = self.toolString;
    WEAK_SELF
    [request startRequestWithRetClass:[HomeworkListRequest_17Item class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        [self->_header endRefreshing];
        
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = retItem != nil;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
        HomeworkListRequest_17Item *item = retItem;
        self.listItem = item;
    }];
    self.listRequest = request;
}
@end

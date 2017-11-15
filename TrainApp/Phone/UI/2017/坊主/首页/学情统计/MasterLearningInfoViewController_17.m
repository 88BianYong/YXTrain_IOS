//
//  MasterLearningInfoViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterLearningInfoViewController_17.h"
#import "MasterLearningInfoFetcher_17.h"
#import "MasterLearningInfoCell_17.h"
#import "MasterLearningInfoTableHeaderView_17.h"
#import "YXSectionHeaderFooterView.h"
#import "MasterExamTopicCell_17.h"
@interface MasterLearningInfoViewController_17 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) MasterLearningInfoTableHeaderView_17 *headerView;
@end

@implementation MasterLearningInfoViewController_17

- (void)viewDidLoad {
    [self setupFetcher];
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    self.navigationItem.title = @"学情统计";
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark - setupUI
- (void)setupUI {
    self.emptyView.title = @"没有符合条件的学员";
    self.emptyView.imageName = @"没有符合条件的课程";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[MasterLearningInfoCell_17 class] forCellReuseIdentifier:@"MasterLearningInfoCell_17"];
    [self.tableView registerClass:[MasterExamTopicCell_17 class] forCellReuseIdentifier:@"MasterExamTopicCell_17"];
    
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    
    self.headerView = [[MasterLearningInfoTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.0f)];
    self.tableView.tableHeaderView = self.headerView;
    [self setupSuperviseLearningRightView];
}
- (void)setupSuperviseLearningRightView {
    UIButton *superviseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [superviseButton setTitle:@"督促学习" forState:UIControlStateNormal];
    [superviseButton setTitleColor:[UIColor colorWithHexString:@"0070c9"] forState:UIControlStateNormal];
    superviseButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    superviseButton.frame = CGRectMake(0, 0, 80.0f, 30.0f);
    superviseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20.0f, 0.0f, -20.0f);
    WEAK_SELF
    [[superviseButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
    }];
    [self setupRightWithCustomView:superviseButton];
}
- (void)firstPageFetch {
    [self stopLoading];
    [self stopAnimation];
    self.tableView.hidden = NO;
}
- (void)tableViewWillRefresh {
    self.headerView.hidden = NO;
    self.emptyView.hidden = YES;
}

- (void)setupFetcher {
    MasterLearningInfoFetcher_17 *fetcher = [[MasterLearningInfoFetcher_17 alloc] init];
    fetcher.status = @"0";
    fetcher.barId = @"0";
    fetcher.pageindex = 0;
    fetcher.pagesize = 20;
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return 10;
        return self.dataArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MasterExamTopicCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterExamTopicCell_17" forIndexPath:indexPath];
        return cell;
    }else {
            MasterLearningInfoCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterLearningInfoCell_17"];
        //cell.learningInfo = self.dataArray[indexPath.row];

        return cell;
        
    }

    
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 193.0f;
    }else {
      return 51.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXSectionHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

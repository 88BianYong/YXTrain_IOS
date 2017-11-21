//
//  MasterHomeworkViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkViewController_17.h"
#import "MasterHomeworkFetcher_17.h"
#import "MasterHomeworkTableHeaderView_17.h"
#import "MasterHomeworkHeaderView_17.h"
#import "MasterHomeworkCell_17.h"
#import "LSTCollectionFilterDefaultView.h"
#import "MasterHomeworkDetailViewController_17.h"
#import "YXMyExamExplainView_17.h"
@interface MasterHomeworkViewController_17 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray<LSTCollectionFilterDefaultModel *> *filterModel;
@property (nonatomic, strong) MasterHomeworkTableHeaderView_17 *headerView;
@property (nonatomic, strong) AlertView *alert;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) CGPoint contentPoint;

@end

@implementation MasterHomeworkViewController_17

#pragma mark - set
- (AlertView *)alert {
    if (_alert == nil) {
        _alert = [[AlertView alloc]init];
        _alert.hideWhenMaskClicked = YES;
    }
    return _alert;
}
- (void)viewDidLoad {
    [self setupFetcher];
    [super viewDidLoad];
    self.contentPoint = CGPointZero;
    self.navigationItem.title = @"作业管理";
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
    [self.tableView registerClass:[MasterHomeworkCell_17 class] forCellReuseIdentifier:@"MasterHomeworkCell_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self.tableView registerClass:[MasterHomeworkHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"MasterHomeworkHeaderView_17"];
    self.headerView = [[MasterHomeworkTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 198.0f)];
    WEAK_SELF
    self.headerView.masterHomeworkButtonBlock = ^(UIButton *sender) {
        STRONG_SELF
        CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
        [self showMarkWithOriginRect:rect explain:self.headerView.descripe];
    };
    self.tableView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.hidden = YES;
    [self.view addSubview:_bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(30.0f);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)showMarkWithOriginRect:(CGRect)rect explain:(NSString *)string {
    YXMyExamExplainView_17 *v = [[YXMyExamExplainView_17 alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    [v setupOriginRect:rect withToTop:(rect.origin.y - [YXMyExamExplainView_17 heightForDescription:string] - 30 > 0) ? YES : NO];
}
- (void)tableViewWillRefresh {
    self.headerView.hidden = NO;
    self.emptyView.hidden = YES;
}

- (void)setupFetcher {
    MasterHomeworkFetcher_17 *fetcher = [[MasterHomeworkFetcher_17 alloc] init];
    fetcher.barId = @"0";
    fetcher.recommendStatus = @"0";
    fetcher.readStatus = @"0";
    fetcher.commendStatus = @"0";
    fetcher.pageindex = 0;
    fetcher.pagesize = 20;
    WEAK_SELF
    fetcher.masterHomeworkBlock = ^(NSArray *model, NSArray<MasterManagerSchemeItem *> *schemes) {
        STRONG_SELF
        if (self.filterModel == nil) {
            self.filterModel = model;
        }
        self.headerView.schemes = schemes;
    };
    self.dataFetcher = fetcher;
}
- (void)showSelectionView {
    __block LSTCollectionFilterDefaultView *selectionView = [[LSTCollectionFilterDefaultView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    selectionView.filterModel = self.filterModel;
    self.alert.contentView = selectionView;
    WEAK_SELF
    [self.alert setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3 animations:^{
            [selectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left);
                make.right.equalTo(view.mas_right);
                make.top.equalTo(view.mas_top);
                make.height.mas_offset(5.0f);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [selectionView cancleUserSelection];
            self.bgView.hidden = YES;
            self.alert.contentView = nil;
            [selectionView removeFromSuperview];
            selectionView = nil;
            [view removeFromSuperview];
        }];
    }];
    [self.alert showInView:self.bgView withFrame:^(AlertView *view) {
        STRONG_SELF
        self.bgView.hidden = NO;
        selectionView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, 0.0f);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25f animations:^{
                selectionView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, selectionView.collectionSize.height);
            }];
        });
    }];
    selectionView.filterSelectedBlock = ^(BOOL isChange) {
        STRONG_SELF
        [self.alert hide];
        if (isChange) {
            if (self.filterModel.count != 4) {
                return;
            }
            MasterHomeworkFetcher_17 *fetcher = (MasterHomeworkFetcher_17 *)self.dataFetcher;
            fetcher.barId = self.filterModel[0].defaultSelectedID;
            fetcher.recommendStatus = self.filterModel[1].defaultSelectedID;
            fetcher.readStatus = self.filterModel[2].defaultSelectedID;
            fetcher.commendStatus = self.filterModel[3].defaultSelectedID;
            [self startLoading];
            [self firstPageFetch];
        }
    };
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterHomeworkCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterHomeworkCell_17" forIndexPath:indexPath];
    cell.homework = self.dataArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"MasterHomeworkCell_17" cacheByIndexPath:indexPath configuration:^(MasterHomeworkCell_17 *cell) {
        cell.homework = self.dataArray[indexPath.row];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MasterHomeworkHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MasterHomeworkHeaderView_17"];
    headerView.filterModel = self.filterModel;
    WEAK_SELF
    headerView.masterHomeworkFilterButtonBlock = ^{
        STRONG_SELF
        if (self.bgView.hidden) {
            self.contentPoint = self.tableView.contentOffset;
            if (self.contentPoint.y < 198.0f) {
                [self.tableView setContentOffset:CGPointMake(0, 198.0f) animated:YES];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showSelectionView];
            });
        }else {
            [self.alert hide];
        }
    };
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MasterHomeworkDetailViewController_17 *VC = [[MasterHomeworkDetailViewController_17 alloc] init];
    MasterHomeworkListItem_Body_Homework *homework = self.dataArray[indexPath.row];
    VC.homeworkId = homework.homeworkId;
    VC.titleString = homework.title;
    [self.navigationController pushViewController:VC animated:YES];
}
@end

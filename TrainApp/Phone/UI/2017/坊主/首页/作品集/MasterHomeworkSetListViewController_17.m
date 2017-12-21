//
//  MasterHomeworkSetListViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkSetListViewController_17.h"
#import "MasterHomeworkSetListFetcher_17.h"
#import "MasterHomeworkSetListTableHeaderView_17.h"
#import "MasterHomeworkHeaderView_17.h"
#import "MasterHomeworkSetListCell_17.h"
#import "LSTCollectionFilterDefaultView.h"
#import "MasterHomeworkSetListDetailViewController_17.h"
@interface MasterHomeworkSetListViewController_17 ()
@property (nonatomic, strong) NSArray<LSTCollectionFilterDefaultModel *> *filterModel;
@property (nonatomic, strong) MasterHomeworkSetListTableHeaderView_17 *headerView;
@property (nonatomic, strong) NSArray<MasterManagerSchemeItem*> *schemes;
@property (nonatomic, strong) AlertView *alert;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) CGFloat headerHeight;
@end

@implementation MasterHomeworkSetListViewController_17
- (void)dealloc {
    DDLogDebug(@"======>>%@",NSStringFromClass([self class]));
}
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
    self.headerHeight = 198.0f;
    self.navigationItem.title = @"作品集管理";
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:@"作品集管理列表" withStatus:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:@"作品集管理列表" withStatus:NO];
}
#pragma mark - setupUI
- (void)setupUI {
    self.emptyView.title = @"没有符合条件的作品集";
    self.emptyView.imageName = @"没有符合条件的课程";
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[MasterHomeworkSetListCell_17 class] forCellReuseIdentifier:@"MasterHomeworkSetListCell_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self.tableView registerClass:[MasterHomeworkHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"MasterHomeworkHeaderView_17"];
    [self.tableView registerClass:[MasterFilterEmptyFooterView_17 class] forHeaderFooterViewReuseIdentifier:@"MasterFilterEmptyFooterView_17"];
    self.headerView = [[MasterHomeworkSetListTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50.0f)];
    WEAK_SELF
    self.headerView.masterHomeworkButtonBlock = ^(UIButton *sender) {
        STRONG_SELF
        CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
        __block NSString *string = @"";
        [self.schemes enumerateObjectsUsingBlock:^(MasterManagerSchemeItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            string = [string stringByAppendingString:obj.descripe];
        }];
        [self showMarkWithOriginRect:rect explain:string];
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
    MasterMyExamExplainView_17 *v = [[MasterMyExamExplainView_17 alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    [v setupOriginRect:rect];
}
- (void)tableViewWillRefresh {
    self.headerView.hidden = NO;
}

- (void)setupFetcher {
    MasterHomeworkSetListFetcher_17 *fetcher = [[MasterHomeworkSetListFetcher_17 alloc] init];
    fetcher.barId = @"0";
    fetcher.recommendStatus = @"0";
    fetcher.readStatus = @"2";
    fetcher.commendStatus = @"0";
    fetcher.pageindex = 0;
    fetcher.pagesize = 20;
    WEAK_SELF
    fetcher.masterHomeworkBlock = ^(NSArray *model, NSArray<MasterManagerSchemeItem *> *schemes) {
        STRONG_SELF
        if (self.filterModel == nil) {
            self.filterModel = model;
        }
        __block NSString *string = @"";
        [self.schemes enumerateObjectsUsingBlock:^(MasterManagerSchemeItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            string = [string stringByAppendingString:obj.descripe];
        }];
        if ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
            self.headerView.explainButton.hidden = NO;
        }else {
            self.headerView.explainButton.hidden = YES;
        }
        if (schemes.count == 0) {
            self.headerHeight = 0.0f;
            self.tableView.tableHeaderView = nil;
        }else {
            self.headerHeight = 198.0f;
            self.tableView.tableHeaderView = self.headerView;
        }
        self.schemes = schemes;
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
            MasterHomeworkSetListFetcher_17 *fetcher = (MasterHomeworkSetListFetcher_17 *)self.dataFetcher;
            fetcher.barId = self.filterModel[0].defaultSelectedID;
            fetcher.readStatus = self.filterModel[1].defaultSelectedID;
            fetcher.commendStatus = self.filterModel[2].defaultSelectedID;
            fetcher.recommendStatus = self.filterModel[3].defaultSelectedID;
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
    MasterHomeworkSetListCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterHomeworkSetListCell_17" forIndexPath:indexPath];
    cell.homework = self.dataArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"MasterHomeworkSetListCell_17" cacheByIndexPath:indexPath configuration:^(MasterHomeworkSetListCell_17 *cell) {
        cell.homework = self.dataArray[indexPath.row];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MasterHomeworkHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MasterHomeworkHeaderView_17"];
    headerView.filterModel = self.filterModel;
    WEAK_SELF
    headerView.masterHomeworkFilterButtonBlock = ^{
        STRONG_SELF
        if (self.bgView.hidden) {
            if (self.tableView.contentOffset.y < self.headerHeight && self.headerHeight == 198.0f) {
                [self.tableView setContentOffset:CGPointMake(0, self.headerHeight) animated:YES];
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return kScreenHeight - 198.0f - 64.0f;
    }else {
        return 0.00001f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        MasterFilterEmptyFooterView_17 *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MasterFilterEmptyFooterView_17"];
//        footerView.titleLabel.text = @"无符合条件的作品集";
        return footerView;
    }else {
        YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
        return footerView;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MasterHomeworkSetListDetailViewController_17 *VC = [[MasterHomeworkSetListDetailViewController_17 alloc] init];
    MasterHomeworkSetListItem_Body_Homework *homework = self.dataArray[indexPath.row];
    VC.homeworkSetId = homework.homeworkSetId;
    VC.titleString = homework.title;
    WEAK_SELF
    VC.masterHomeworkSetRecommendBlock = ^(BOOL recommend) {
        STRONG_SELF
        homework.isMasterRecommend = [NSString stringWithFormat:@"%d",recommend];
        [self.tableView reloadData];
    };
    VC.masterHomeworkSetCommendBlock = ^{
        STRONG_SELF
        homework.isMasterComment = @"1";
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - request
- (void)firstPageFetch {
    if (!self.dataFetcher) {
        return;
    }
    
    [self.dataFetcher stop];
    self.dataFetcher.pageindex = 0;
    if (!self.dataFetcher.pagesize) {
        self.dataFetcher.pagesize = 20;
    }
    WEAK_SELF
    [self.dataFetcher startWithBlock:^(NSInteger total, NSArray *retItemArray, NSError *error) {
        STRONG_SELF
        self.tableView.tableHeaderView.hidden = NO;
        self.tableView.hidden = NO;
        [self stopLoading];
        [self stopAnimation];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = self.dataArray.count != 0;
        data.error = error;
        if ([self handleRequestData:data inView:self.contentView]) {
            return;
        }
        self.total = total;
        [self tableViewWillRefresh];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:retItemArray];
        [self checkHasMore];
        [self.dataFetcher saveToCache];
        [self.tableView reloadData];
    }];
}
@end

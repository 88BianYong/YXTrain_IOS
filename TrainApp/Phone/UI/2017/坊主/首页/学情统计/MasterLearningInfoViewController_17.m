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
#import "LSTCollectionFilterDefaultView.h"
#import "PersonLearningInfoViewController_17.h"
#import "MasterRemindStudyRequest.h"
@interface MasterLearningInfoViewController_17 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) MasterLearningInfoTableHeaderView_17 *headerView;
@property (nonatomic, strong) NSArray<LSTCollectionFilterDefaultModel *> *filterModel;
@property (nonatomic, strong) MasterLearningInfoRequestItem_Body *itemBody;
@property (nonatomic, strong) MasterRemindStudyRequest *studyRequest;
@property (nonatomic, strong) UIButton *superviseButton;

@property (nonatomic, strong) AlertView *alert;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation MasterLearningInfoViewController_17

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
    self.bIsGroupedTableViewStyle = YES;
    [super viewDidLoad];
    self.navigationItem.title = @"学情统计";
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:@"学情统计" withStatus:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:@"学情统计" withStatus:NO];
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
    [self.tableView registerClass:[MasterFilterEmptyFooterView_17 class] forHeaderFooterViewReuseIdentifier:@"MasterFilterEmptyFooterView_17"];
    
    self.headerView = [[MasterLearningInfoTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.0f)];
    WEAK_SELF
    self.headerView.masterLearningInfoButtonBlock = ^(BOOL isOpen) {
        STRONG_SELF
        if (self.bgView.hidden) {
            [YXDataStatisticsManger trackEvent:@"筛选" label:@"学情统计" parameters:nil];
            [self showSelectionView];
        }else {
            [self.alert hide];
        }
    };
    self.tableView.hidden = YES;
    self.tableView.tableHeaderView = self.headerView;
    [self setupSuperviseLearningRightView];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.hidden = YES;
    [self.view addSubview:_bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(44.0f);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (void)setupSuperviseLearningRightView {
    self.superviseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.superviseButton setTitle:@"督促学习" forState:UIControlStateNormal];
    [self.superviseButton setTitleColor:[UIColor colorWithHexString:@"0070c9"] forState:UIControlStateNormal];
    self.superviseButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.superviseButton.frame = CGRectMake(0, 0, 80.0f, 30.0f);
    self.superviseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20.0f, 0.0f, -20.0f);
    self.superviseButton.hidden = YES;
    WEAK_SELF
    [[self.superviseButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self requestForRemindStudy];
        [YXDataStatisticsManger trackEvent:@"一键督促学情" label:@"学情统计" parameters:nil];
    }];
    [self setupRightWithCustomView:self.superviseButton];
}
- (void)showMarkWithOriginRect:(CGRect)rect explain:(NSString *)string {
    MasterMyExamExplainView_17 *v = [[MasterMyExamExplainView_17 alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    [v setupOriginRect:rect];
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
    WEAK_SELF
    fetcher.masterLearningInfoBlock = ^(NSArray *model, MasterLearningInfoRequestItem_Body *body) {
        STRONG_SELF
        self.itemBody = body;
        if (self.filterModel == nil) {
            self.filterModel = model;
        }
        if (self.filterModel.count == 2) {
            LSTCollectionFilterDefaultModel *model = self.filterModel[0];
            [self.headerView reloadMasterLearningInfo:model.item[model.defaultSelected.integerValue].name withNumber:body.detail.xys];
        }
    };
    self.dataFetcher = fetcher;
    self.bIsGroupedTableViewStyle = YES;
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
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.bgView.hidden = NO;
        selectionView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, 0.0f);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25f animations:^{
                if (self.bgView.bounds.size.height > selectionView.collectionSize.height) {
                    selectionView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, selectionView.collectionSize.height);
                }else {
                    selectionView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, self.bgView.bounds.size.height);
                }
            }];
        });
    }];
    selectionView.filterSelectedBlock = ^(BOOL isChange) {
        STRONG_SELF
        [self.alert hide];
        if (isChange) {
            if (self.filterModel.count != 2) {
                return;
            }
            MasterLearningInfoFetcher_17 *fetcher = (MasterLearningInfoFetcher_17 *)self.dataFetcher;
            fetcher.barId = self.filterModel[0].defaultSelectedID;
            fetcher.status = self.filterModel[1].defaultSelectedID;
            [self startLoading];
            [self firstPageFetch];
        }
    };
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return self.dataArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MasterExamTopicCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterExamTopicCell_17" forIndexPath:indexPath];
        __block NSString *explain = @"";
        [self.itemBody.schemes enumerateObjectsUsingBlock:^(MasterLearningInfoRequestItem_Body_Schemes *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            explain = [explain stringByAppendingString:obj.descripe];
        }];
        cell.detail = self.itemBody.detail;
        if ([explain stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
            cell.explainButton.hidden = NO;
        }else {
            cell.explainButton.hidden = YES;
        }
        WEAK_SELF
        cell.masterExamTopicButtonBlock = ^(UIButton *sender) {
            STRONG_SELF
            CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
            [YXDataStatisticsManger trackEvent:@"考核说明" label:@"学情统计" parameters:nil];
            [self showMarkWithOriginRect:rect explain:explain];
        };
        return cell;
    }else {
            MasterLearningInfoCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterLearningInfoCell_17"];
        cell.learningInfo = self.dataArray[indexPath.row];
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
    if (section == 0) {
        return 0.00001f;
    }else {
        if (self.dataArray.count == 0) {
            return kScreenHeight - 198.0f - 64.0f;
        }else {
            return 0.00001f;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
        return footerView;
    }else {
        if (self.dataArray.count == 0) {
            MasterFilterEmptyFooterView_17 *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MasterFilterEmptyFooterView_17"];
            return footerView;
        }else {
            YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
            return footerView;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXSectionHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        PersonLearningInfoViewController_17 *VC = [[PersonLearningInfoViewController_17 alloc] init];
        VC.learningInfo = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - request
- (void)requestForRemindStudy{
    [self.studyRequest stopRequest];
    MasterRemindStudyRequest *request = [[MasterRemindStudyRequest alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    request.barId = self.filterModel[0].defaultSelectedID;
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
        [self showAlertCancleRemark];
    }];
    self.studyRequest = request;
}
- (void)showAlertCancleRemark{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy.MM.dd"];
    NSDate *date = [dateFormater dateFromString:[LSTSharedInstance sharedInstance].trainManager.currentProject.endDate];
    [dateFormater setDateFormat:@"yyyy年MM月dd日"];
    NSString *currentDateString = [dateFormater stringFromDate:date];
    NSString *string = [NSString stringWithFormat:@"友情提示:\"%@\"截止时间: %@,请各位老师注意学习进度",[LSTSharedInstance sharedInstance].trainManager.currentProject.name,currentDateString];
    LSTAlertView *alertView = [[LSTAlertView alloc]init];
    alertView.title = string;
    alertView.imageName = @"失败icon";
    WEAK_SELF
    [alertView addButtonWithTitle:@"我知道了" style:LSTAlertActionStyle_Alone action:^{
        STRONG_SELF
    }];
    [alertView show];
}
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
        self.superviseButton.hidden = self.dataArray.count == 0;
    }];
}

@end

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
#import "YXMyExamExplainView_17.h"
#import "LSTCollectionFilterDefaultView.h"
#import "PersonLearningInfoViewController_17.h"
#import "MasterRemindStudyRequest.h"
@interface MasterLearningInfoViewController_17 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) MasterLearningInfoTableHeaderView_17 *headerView;
@property (nonatomic, strong) NSArray<LSTCollectionFilterDefaultModel *> *filterModel;
@property (nonatomic, strong) MasterLearningInfoRequestItem_Body *itemBody;
@property (nonatomic, strong) MasterRemindStudyRequest *studyRequest;

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
    WEAK_SELF
    self.headerView.masterLearningInfoButtonBlock = ^(BOOL isOpen) {
        STRONG_SELF
        if (self.bgView.hidden) {
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
    UIButton *superviseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [superviseButton setTitle:@"督促学习" forState:UIControlStateNormal];
    [superviseButton setTitleColor:[UIColor colorWithHexString:@"0070c9"] forState:UIControlStateNormal];
    superviseButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    superviseButton.frame = CGRectMake(0, 0, 80.0f, 30.0f);
    superviseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20.0f, 0.0f, -20.0f);
    WEAK_SELF
    [[superviseButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self requestForRemindStudy];
    }];
    [self setupRightWithCustomView:superviseButton];
}
- (void)showMarkWithOriginRect:(CGRect)rect explain:(NSString *)string {
    YXMyExamExplainView_17 *v = [[YXMyExamExplainView_17 alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    [v setupOriginRect:rect withToTop:(rect.origin.y - [self heightForDescription:string] - 30 > 0) ? YES : NO];
}
- (CGFloat)heightForDescription:(NSString *)desc {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    CGRect rect = [desc boundingRectWithSize:CGSizeMake(kScreenWidth - 60.0f, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSParagraphStyleAttributeName:paragraphStyle} context:NULL];
    return rect.size.height;
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
            [self.headerView reloadMasterLearningInfo:model.item[model.defaultSelected.integerValue].name withNumber:body.xueQing.total];
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
               selectionView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, selectionView.collectionSize.height);
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
        cell.detail = self.itemBody.detail;
        WEAK_SELF
        cell.masterExamTopicButtonBlock = ^(UIButton *sender) {
            STRONG_SELF
            CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
            __block NSString *explain = @"";
            [self.itemBody.schemes enumerateObjectsUsingBlock:^(MasterLearningInfoRequestItem_Body_Schemes *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                explain = [explain stringByAppendingString:obj.descripe];
            }];
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
    PersonLearningInfoViewController_17 *VC = [[PersonLearningInfoViewController_17 alloc] init];
    VC.learningInfo = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];
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
        [self showMarkWithOriginRect:CGRectMake(200, 30.0f, 80, 30.0f) explain:@"友情上飞机法律框架发就;了法兰克福;老卡机的发了空间啊离开房间啊;立刻就发了卡机的是发"];
    }];
    self.studyRequest = request;
}

@end

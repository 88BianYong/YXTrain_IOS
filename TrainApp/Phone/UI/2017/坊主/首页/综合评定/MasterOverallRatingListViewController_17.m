//
//  MasterOverallRatingListViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOverallRatingListViewController_17.h"
#import "MasterOverallRatingListRequest_17.h"
#import "MasterOverallRatingListHeaderView_17.h"
#import "MasterOverallRatingFilterTitleView_17.h"
#import "MasterOverallRatingListCell_17.h"
#import "MasterOverallRatingListTableHeaderView_17.h"
#import "LSTCollectionFilterDefaultProtocol.h"
#import "LSTCollectionFilterDefaultView.h"
#import "MasterOverallRatingSearchView_17.h"
#import "MasterOverallRatingSearchContentView_17.h"
#import "MasterOverallRatingScoreViewController_17.h"
@interface MasterOverallRatingListViewController_17 ()<UITableViewDelegate, UITableViewDataSource,LSTCollectionFilterDefaultProtocol,UIGestureRecognizerDelegate>
@property (nonatomic, strong) MasterOverallRatingListRequest_17 *listRequest;
@property (nonatomic, strong) MasterOverallRatingListItem *listItem;
@property (nonatomic, strong) NSMutableArray *allMutableArray;
@property (nonatomic, strong) NSMutableArray *dataMutableArray;
@property (nonatomic, strong) NSMutableArray *sectionTitleMutableArray;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) MasterOverallRatingListTableHeaderView_17 *headerView;
@property (nonatomic, strong) MasterOverallRatingFilterTitleView_17 *filterTitleView;
@property (nonatomic, assign) BOOL isMoveBool;
@property (nonatomic, strong) NSArray<LSTCollectionFilterDefaultModel *> *filterModel;
@property (nonatomic, strong) AlertView *alert;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) MasterOverallRatingSearchView_17 *seachView;
@property (nonatomic, strong) MasterOverallRatingSearchContentView_17 *maskView;
@property (nonatomic, strong) NSMutableArray *searchMutableArray;

@end

@implementation MasterOverallRatingListViewController_17
- (void)dealloc {
    DDLogDebug(@"======>>%@",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - set
- (AlertView *)alert {
    if (_alert == nil) {
        _alert = [[AlertView alloc]init];
        _alert.hideWhenMaskClicked = YES;
    }
    return _alert;
}
- (void)setListItem:(MasterOverallRatingListItem *)listItem {
    _listItem = listItem;
    if (self.filterModel == nil) {
        self.filterModel = [self fomartCollectionFilterModel:_listItem.body.bars];
    }
    if (self.allMutableArray.count == 0) {
        [self.allMutableArray addObjectsFromArray:_listItem.body.userScores];
    }
    self.headerView.countUser = _listItem.body.countUser;
    self.headerView.hidden = NO;
    self.filterTitleView.filterModel = self.filterModel;
    self.filterTitleView.hidden = NO;
    [self fomartUserScoreList:_listItem.body.userScores];
    if ([_listItem.body.exmineDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        self.headerView.explainButton.hidden = NO;
    }else {
        self.headerView.explainButton.hidden = YES;
    }
}
#pragma mark - fomart Data
- (void)fomartUserScoreList:(NSArray *)userScores {
    [self.dataMutableArray removeAllObjects];
    [self.sectionTitleMutableArray removeAllObjects];
    //初始化UILocalizedIndexedCollation
    UILocalizedIndexedCollation *localizedCollection = [UILocalizedIndexedCollation currentCollation];
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[localizedCollection sectionTitles] count];
    //初始化一个数组newSectionsArray用来存放最终的数据
    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self.dataMutableArray addObject:array];
    }
    //将每个人按name分到某个section下
    for (MasterOverallRatingListItem_Body_UserScore *temp in _listItem.body.userScores) {
        //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [localizedCollection sectionForObject:temp collationStringSelector:@selector(sortName)];
        NSMutableArray *sectionNames = self.dataMutableArray[sectionNumber];
        [sectionNames addObject:temp];
    }
    
    //对每个section中的数组按照name属性排序
    for (int index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = self.dataMutableArray[index];
        NSArray *sortedPersonArrayForSection = [localizedCollection sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(sortName)];
        self.dataMutableArray[index] = sortedPersonArrayForSection;
    }
    //section title
    NSMutableArray *tempMutableArray = [NSMutableArray array];
    [self.dataMutableArray enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL * _Nonnull stop) {
        if (array.count == 0) {
            [tempMutableArray addObject:array];
        }else{
            [self.sectionTitleMutableArray addObject:[localizedCollection sectionTitles][idx]];
        }
    }];
    [self.dataMutableArray removeObjectsInArray:tempMutableArray];
    [self.tableView reloadData];
}
- (NSMutableArray<LSTCollectionFilterDefaultModel *> *)fomartCollectionFilterModel:(id)item {
    NSArray *bars = item;
    NSMutableArray<LSTCollectionFilterDefaultModel *> *modelArray = [[NSMutableArray<LSTCollectionFilterDefaultModel *> alloc] initWithCapacity:2];
    if (bars.count > 0) {
        NSMutableArray<LSTCollectionFilterDefaultModelItem *> *barArray = [[NSMutableArray<LSTCollectionFilterDefaultModelItem *> alloc] init];
        [bars enumerateObjectsUsingBlock:^(MasterOverallRatingListItem_Body_Bar *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LSTCollectionFilterDefaultModelItem *model = [[LSTCollectionFilterDefaultModelItem alloc] init];
            model.name = obj.name;
            model.itemID = obj.barId;
            [barArray addObject:model];
        }];
        LSTCollectionFilterDefaultModel *barModel = [[LSTCollectionFilterDefaultModel alloc] init];
        barModel.defaultSelected = @"0";
        barModel.itemName = @"工作坊";
        barModel.item = barArray;
        [modelArray addObject:barModel];
    }
    
    //1：已评定，2：未评定 0全部
    NSArray<NSString *> *array = @[@"全部",@"已评定",@"未评定"];
    NSMutableArray<LSTCollectionFilterDefaultModelItem *> *statusArray = [[NSMutableArray<LSTCollectionFilterDefaultModelItem *> alloc] init];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSTCollectionFilterDefaultModelItem *model = [[LSTCollectionFilterDefaultModelItem alloc] init];
        model.name = obj;
        model.itemID = [NSString stringWithFormat:@"%ld",idx];
        [statusArray addObject:model];
    }];
    LSTCollectionFilterDefaultModel *statusModel = [[LSTCollectionFilterDefaultModel alloc] init];
    statusModel.defaultSelected = @"0";
    statusModel.itemName = @"状态";
    statusModel.item = statusArray;
    [modelArray addObject:statusModel];
    return modelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"综合评定";
    self.dataMutableArray = [[NSMutableArray alloc] init];
    self.searchMutableArray = [[NSMutableArray alloc] init];
    self.allMutableArray = [[NSMutableArray alloc] init];
    self.sectionTitleMutableArray = [[NSMutableArray alloc] initWithCapacity:27];
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForOverallRatingList];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            [self.maskView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (kScreenHeight == keyboardFrame.origin.y) {
                    make.bottom.mas_equalTo(-(kScreenHeight - keyboardFrame.origin.y));
                }else {
                    make.bottom.mas_equalTo(-(kScreenHeight - keyboardFrame.origin.y));
                }
            }];
            [self.view layoutIfNeeded];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self.tableView registerClass:[MasterOverallRatingListHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"MasterOverallRatingListHeaderView_17"];
    [self.tableView registerClass:[MasterOverallRatingListCell_17 class] forCellReuseIdentifier:@"MasterOverallRatingListCell_17"];
    [self.tableView registerClass:[MasterFilterEmptyFooterView_17 class] forHeaderFooterViewReuseIdentifier:@"MasterFilterEmptyFooterView_17"];
    
    self.headerView = [[MasterOverallRatingListTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 198.0f + 30.0f)];
    self.headerView.hidden = YES;
    WEAK_SELF
    self.headerView.masterOverallRatingButtonBlock = ^(UIButton *sender) {
        STRONG_SELF
        CGRect rect = [sender convertRect:sender.bounds toView:self.navigationController.view];
        [self showMarkWithOriginRect:rect explain:self.listItem.body.exmineDesc?:@""];
    };
    self.tableView.tableHeaderView = self.headerView;
    self.filterTitleView = [[MasterOverallRatingFilterTitleView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30.0f)];
    self.filterTitleView.hidden = YES;
    self.filterTitleView.masterOverallRatingFilterButtonBlock = ^{
        STRONG_SELF
        if (self.bgView.hidden) {
            if (self.tableView.contentOffset.y < 198.0f) {
                [self.tableView setContentOffset:CGPointMake(0, 198.0f) animated:YES];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showSelectionView];
            });
        }else {
            [self.alert hide];
        }
    };
    [self.tableView addSubview:self.filterTitleView];

    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.hidden = YES;
    [self.view addSubview:_bgView];
    
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForOverallRatingList];
    };
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForOverallRatingList];
    };
    self.seachView = [[MasterOverallRatingSearchView_17 alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.seachView.backgroundColor = [UIColor whiteColor];
    [self setupRightWithImageNamed:@"搜索" highlightImageNamed:@"搜索"];
    self.maskView = [[MasterOverallRatingSearchContentView_17 alloc] init];
    self.maskView.masterOverallRatingSearchBlock = ^(MasterOverallRatingListItem_Body_UserScore *userScore) {
        STRONG_SELF
        MasterOverallRatingScoreViewController_17 *VC = [[MasterOverallRatingScoreViewController_17 alloc] init];
        VC.userScore = userScore;
        VC.masterOverallRatingScoreBlock = ^{
            STRONG_SELF
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:VC animated:YES];
        [self hiddenMaskView];
    };
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.maskView.hidden = YES;
    [self.view addSubview:self.maskView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    recognizer.delegate = self;
    [[recognizer rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *sender) {
        STRONG_SELF
        [self hiddenMaskView];
    }];
    [self.maskView addGestureRecognizer:recognizer];
}
- (void)hiddenMaskView {
    [self.searchMutableArray removeAllObjects];
    self.maskView.searchMutableArray = self.searchMutableArray;
    self.seachView.searchTextField.text = nil;
    [super setupLeftBack];
    [self setupRightWithImageNamed:@"搜索" highlightImageNamed:@"搜索"];
    self.navigationItem.titleView = nil;
    self.maskView.hidden = YES;
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.filterTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.tableView.mas_top).offset(198.0f);
        make.height.mas_offset(30.0f);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(30.0f);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (void)showMarkWithOriginRect:(CGRect)rect explain:(NSString *)string {
    MasterMyExamExplainView_17 *v = [[MasterMyExamExplainView_17 alloc]init];
    [v showInView:self.navigationController.view examExplain:string];
    [v setupOriginRect:rect];
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
            if (self.filterModel.count != 2) {
                return;
            }
            [self startLoading];
            [self requestForOverallRatingList];
        }
    };
}
- (void)naviRightAction{
    if (self.dataMutableArray.count == 0) {
        [self showToast:@"当前无可搜索数据"];
        return;
    }
    [self.seachView setFirstResponse];
    WEAK_SELF
    self.seachView.textBeginEdit = ^{
        STRONG_SELF
        self.maskView.hidden = NO;
        [self.view bringSubviewToFront:self.maskView];
    };
    self.seachView.textShouldClear = ^{
        STRONG_SELF
        [self.searchMutableArray removeAllObjects];
        self.maskView.searchMutableArray = self.searchMutableArray;
    };
    self.seachView.cancelButtonClickedBlock = ^{
        STRONG_SELF
        [self hiddenMaskView];
    };
    self.seachView.textShouldReturn = ^(NSString *key){
        STRONG_SELF
        [self.searchMutableArray removeAllObjects];
        if (![key isEqualToString:@"" ] && ![key isEqual:[NSNull null]]) {
            [self.allMutableArray enumerateObjectsUsingBlock:^(MasterOverallRatingListItem_Body_UserScore *userScore, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *name = userScore.userName.lowercaseString;
                NSString * namePinyin = userScore.sortName.yx_transformToPinyin;
                NSString * nameFirstLetter = userScore.sortName.yx_transformToPinyinFirstLetter;
                NSRange rang1 = [name rangeOfString:key];
                if (rang1.length > 0) {
                    [self.searchMutableArray addObject:userScore];
                }else {
                    if ([nameFirstLetter containsString:key]) {
                        [self.searchMutableArray addObject:userScore];
                    }else {
                        if ([nameFirstLetter containsString:[key substringToIndex:1]]) {
                            if ([namePinyin containsString:key]) {
                                [self.searchMutableArray addObject:userScore];
                            }
                        }
                    }
                }
            }];
        }
        self.maskView.searchMutableArray = self.searchMutableArray;
    };
    self.navigationItem.titleView = self.seachView;
    self.navigationItem.titleView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItems = nil;
    [self.navigationItem setHidesBackButton:YES animated:NO];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataMutableArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataMutableArray[section];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterOverallRatingListCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterOverallRatingListCell_17" forIndexPath:indexPath];
    cell.userScore = self.dataMutableArray[indexPath.section][indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.dataMutableArray.count == 0) {
        return kScreenHeight - 198.0f - 64.0f;
    }else {
        return 0.00001;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MasterOverallRatingListHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MasterOverallRatingListHeaderView_17"];
    headerView.titleLabel.text = self.sectionTitleMutableArray[section];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.dataMutableArray.count == 0) {
        MasterFilterEmptyFooterView_17 *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MasterFilterEmptyFooterView_17"];
        return footerView;
    }else {
        YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
        return footerView;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MasterOverallRatingScoreViewController_17 *VC = [[MasterOverallRatingScoreViewController_17 alloc] init];
    VC.userScore = self.dataMutableArray[indexPath.section][indexPath.row];
    WEAK_SELF
    VC.masterOverallRatingScoreBlock = ^{
        STRONG_SELF
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 198.0f) {
        if (!self.isMoveBool) {
            [self.filterTitleView removeFromSuperview];
            [self.view addSubview:self.filterTitleView];
            [self.filterTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left);
                make.right.equalTo(self.view.mas_right);
                make.top.equalTo(self.view.mas_top);
                make.height.mas_offset(30.0f);
            }];
            self.isMoveBool = YES;
        }
    }else {
        if (self.isMoveBool) {
            [self.filterTitleView removeFromSuperview];
            [self.tableView addSubview:self.filterTitleView];
            [self.filterTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left);
                make.right.equalTo(self.view.mas_right);
                make.top.equalTo(self.tableView.mas_top).offset(198.0f);
                make.height.mas_offset(30.0f);
            }];
            self.isMoveBool = NO;
        }
    }
//    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"userName CONTAINS[c] %@", @""];
//    //过滤数据
//    self.dataMutableArray = [NSMutableArray arrayWithArray:[self.dataMutableArray filteredArrayUsingPredicate:preicate]];
}
#pragma mark - request
- (void)requestForOverallRatingList  {
    MasterOverallRatingListRequest_17 *request = [[MasterOverallRatingListRequest_17 alloc] init];
    request.projectId = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    if (self.filterModel.count == 2) {
        request.barId = self.filterModel[0].defaultSelectedID;
        request.isScore = self.filterModel[1].defaultSelectedID;
    }
    WEAK_SELF
    [request startRequestWithRetClass:[MasterOverallRatingListItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self stopLoading];
        if (error) {
            UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
            data.requestDataExist = YES;
            data.localDataExist = NO;
            data.error = error;
            if ([self handleRequestData:data inView:self.view]) {
                return;
            }
        }else {
            self.listItem = retItem;
        }
    }];
    self.listRequest = request;
}



@end

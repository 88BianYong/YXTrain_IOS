//
//  MasterMainViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterMainViewController_17.h"
#import "MasterMainHeaderView_17.h"
#import "MasterMainTableHeaderView_17.h"
#import "YXMySettingCell.h"
#import "MasterMainCell_17.h"
#import "MasterMainFooterView_17.h"
#import "YXUserProfileRequest.h"
#import "PersistentUrlDownloader.h"
#import "YXHelpViewController.h"
#import "YXAboutViewController.h"
#import "YXBarGetMyBarsRequest_17.h"
#import "MasterMainBarErrorCell_17.h"
#import "YXWorkshopDetailViewController.h"
#import "TrainListProjectGroup.h"
@interface MasterMainViewController_17 ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) YXUserProfile *userProfile;
@property (nonatomic, strong) YXUserProfileRequest *userProfileRequest;
@property (nonatomic, strong) YXBarGetMyBarsRequest_17 *barsRequest;
@property (nonatomic, strong) YXBarGetMyBarsRequestItem_Body *itemBody;
@property (nonatomic, strong) MasterMainTableHeaderView_17 *headerView;

@property (nonatomic, assign) BOOL isBarBool;
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation MasterMainViewController_17

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - set
- (void)setItemBody:(YXBarGetMyBarsRequestItem_Body *)itemBody {
    _itemBody = itemBody;
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.titleArray = @[@"清空缓存",@"帮助与反馈",@"去AppStore评分",@"关于我们"];
    [self setupUI];
    [self setupLayout];
    [self reloadUserProfileData];
    [self requestForGetBars];
    self.itemBody = nil;
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"kYXUploadUserPicSuccessNotification" object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        self.headerView.userProfile = [LSTSharedInstance sharedInstance].userManger.userModel.profile;
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:@"我页面" withStatus:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:@"我页面" withStatus:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI setting
- (void)setupUI{
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.tableView registerClass:[MasterMainCell_17 class] forCellReuseIdentifier:@"MasterMainCell_17"];
    [self.tableView registerClass:[YXMySettingCell class] forCellReuseIdentifier:@"YXMySettingCell"];
    [self.tableView registerClass:[MasterMainBarErrorCell_17 class] forCellReuseIdentifier:@"MasterMainBarErrorCell_17"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
    [self.tableView registerClass:[MasterMainHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"MasterMainHeaderView_17"];
    [self.view addSubview:self.tableView];
    self.headerView = [[MasterMainTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 133.0f)];
    WEAK_SELF
    self.headerView.masterMainUserCompleteBlock = ^{
        STRONG_SELF
        UIViewController *VC = [[NSClassFromString(@"YXMineViewController") alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    };
    self.tableView.tableHeaderView = self.headerView;
    MasterMainFooterView_17 *footerView = [[MasterMainFooterView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45.0f)];
    [[footerView.logoutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [[LSTSharedInstance  sharedInstance].webSocketManger close];
        [[LSTSharedInstance sharedInstance].userManger logout];
        [YXDataStatisticsManger trackEvent:@"退出登录" label:@"成功登出" parameters:nil];
    }];
    self.tableView.tableFooterView = footerView;
}
- (void)setupLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.trains.count;
    }else if (section == 1) {
        if (!self.isBarBool) {
            return 0;
        }else {
            return self.itemBody.bars.count != 0 ? self.itemBody.bars.count : 1;

        }
    }else {
        return self.titleArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        YXTrainListRequestItem_body_train *train = [LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.trains[indexPath.row];
        MasterMainCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterMainCell_17" forIndexPath:indexPath];
        cell.titleString = train.name;
        return cell;
    }else if (indexPath.section == 1) {
        if (self.itemBody.bars.count == 0) {
            MasterMainBarErrorCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterMainBarErrorCell_17" forIndexPath:indexPath];
            return cell;
        }else {
            MasterMainCell_17 *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterMainCell_17" forIndexPath:indexPath];
            YXBarGetMyBarsRequestItem_Body_Bar *bar = self.itemBody.bars[indexPath.row];
            cell.titleString = bar.name;
            return cell;
        }
    }
    else{
        YXMySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXMySettingCell" forIndexPath:indexPath];
        [cell reloadWithText:self.titleArray[indexPath.row] imageName:@""];
        return cell;
    }
}

#pragma mark - tableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && self.itemBody.bars.count == 0){
        return 45.0f * 3;
    }else {
        return 45.0f;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 30.0f;
    }else {
        return 10.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YXSectionHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSectionHeaderFooterView"];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 0.0001f;
    }else {
        return 45.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MasterMainHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MasterMainHeaderView_17"];
    if (section == 0) {
        [headerView reloadMasterMainHeader:@"我的项目" withTitle:@"我的项目"];
    }else if (section == 1){
        [headerView reloadMasterMainHeader:@"我的工作坊icon-正常态" withTitle:@"我的工作坊"];
    }else {
        [headerView reloadMasterMainHeader:@"" withTitle:@""];
    }
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0){
        YXTrainListRequestItem_body_train *train = [LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.trains[indexPath.row];
        if (train.pid.integerValue == [LSTSharedInstance sharedInstance].trainManager.currentProject.pid.integerValue) {
            self.tabBarController.selectedIndex = 0;
        }else {
            NSArray<TrainListProjectGroup *> *groups = [TrainListProjectGroup projectGroupsWithRawData:[LSTSharedInstance sharedInstance].trainManager.trainlistItem.body];
            __block NSInteger sectionInteger = 0;
            __block NSInteger indexInteger = 0;
            __block BOOL isSaveBool = NO;
            [groups enumerateObjectsUsingBlock:^(TrainListProjectGroup * _Nonnull obj, NSUInteger section, BOOL * _Nonnull stop) {
                [obj.items enumerateObjectsUsingBlock:^(YXTrainListRequestItem_body_train * _Nonnull train, NSUInteger index, BOOL * _Nonnull stop) {
                    if ([train.pid isEqualToString:train.pid]) {
                        sectionInteger = section;
                        indexInteger = index;
                        isSaveBool = YES;
                    }
                }];
            }];
            [LSTSharedInstance sharedInstance].trainManager.currentProject.role = nil;
            [LSTSharedInstance sharedInstance].trainManager.currentProjectIndexPath = [NSIndexPath indexPathForRow:indexInteger inSection:sectionInteger];
            [[NSNotificationCenter defaultCenter] postNotificationName:kXYTrainChangeProject object:nil];
        }
        
    }else if(indexPath.section == 1){
        if (self.itemBody.bars.count == 0) {
          [self requestForGetBars];
        }else {
            YXWorkshopDetailViewController *detailVC = [[YXWorkshopDetailViewController alloc] init];
            YXBarGetMyBarsRequestItem_Body_Bar *bar = self.itemBody.bars[indexPath.row];
            detailVC.baridString = bar.barId;
            [self.navigationController pushViewController:detailVC animated:YES];
        }

    }else {
        switch (indexPath.row) {
            case 0:
            {
                // 清sdwebimage
                [[SDImageCache sharedImageCache] clearDisk];
                [[SDImageCache sharedImageCache] clearMemory];
                
                // 清缓存
                NSString *dp = [BaseDownloader downloadFolderPath];
                [[NSFileManager defaultManager] removeItemAtPath:dp error:nil];
                [self showToast:@"清除成功"];
                [YXDataStatisticsManger trackEvent:@"清理缓存" label:@"成功清理缓存" parameters:nil];
            }
                break;
            case 1:
            {
                YXHelpViewController *helpVC = [[YXHelpViewController alloc] init];
                [self.navigationController pushViewController:helpVC animated:YES];
            }
                break;
            case 2:
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1012923844"]];
            }
                break;
            case 3:
            {
                YXAboutViewController *aboutVC = [[YXAboutViewController alloc] init];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - request
- (void)reloadUserProfileData {
    self.userProfile = [LSTSharedInstance sharedInstance].userManger.userModel.profile;
    if (!self.userProfile) {
        [self requestUserProfile];
    }else {
        [self.tableView reloadData];
    }
    self.headerView.userProfile = self.userProfile;
}
- (void)requestUserProfile {
    YXUserProfileRequest *request = [[YXUserProfileRequest alloc] init];
    request.targetuid = [LSTSharedInstance sharedInstance].userManger.userModel.uid;
    WEAK_SELF
    [request startRequestWithRetClass:[YXUserProfileItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        YXUserProfileItem *item = retItem;
        if (item) {
            [LSTSharedInstance sharedInstance].userManger.userModel.profile = item.editUserInfo;
            [[LSTSharedInstance sharedInstance].userManger saveUserData];
        }
        self.userProfile = [LSTSharedInstance sharedInstance].userManger.userModel.profile;
        self.headerView.userProfile = self.userProfile;
    }];
    self.userProfileRequest = request;
}
- (void)requestForGetBars {
    YXBarGetMyBarsRequest_17 *request = [[YXBarGetMyBarsRequest_17 alloc] init];
    request.roleId = [LSTSharedInstance sharedInstance].trainManager.currentProject.role;
    [self startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[YXBarGetMyBarsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        self.isBarBool = YES;
        [self stopLoading];
        if (error) {
            self.itemBody = nil;
        }else {
            YXBarGetMyBarsRequestItem *item = retItem;
            self.itemBody = item.body;
        }
    }];
    self.barsRequest = request;
}

@end

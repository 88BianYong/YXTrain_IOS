//
//  XYMineViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXMineViewController_17.h"
#import "PersistentUrlDownloader.h"
#import "YXHelpViewController.h"
#import "YXAboutViewController.h"
#import "YXMySettingCell.h"
#import "YXWebSocketManger.h"
#import "YXUserProfileRequest.h"
#import "YXMineTableHeaderView_17.h"
#import "YXMineMainCell.h"
#import "YXMineHeaderView_17.h"
static  NSString *const trackPageName = @"设置页面";
@interface YXMineViewController_17 ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) YXUserProfile *userProfile;
@property (nonatomic, strong) YXUserProfileRequest *userProfileRequest;
@property (nonatomic, strong) YXMineTableHeaderView_17 *headerView;
@end

@implementation YXMineViewController_17
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.titleArray = @[@"清空缓存",@"帮助与反馈",@"去AppStore评分",@"关于我们"];
    [self setupUI];
    [self layoutInterface];
    [self reloadUserProfileData];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"kYXUploadUserPicSuccessNotification" object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        self.headerView.userProfile = [LSTSharedInstance sharedInstance].userManger.userModel.profile;
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:YES];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [YXDataStatisticsManger trackPage:trackPageName withStatus:NO];
    self.navigationController.navigationBar.shadowImage = [UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI setting
- (void)setupUI{
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithHexString:@"eceef2"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15.0f, 0.0f, 0.0f);
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"staticString"];
    [self.tableView registerClass:[YXMySettingCell class] forCellReuseIdentifier:@"YXMySettingCell"];
    [self.tableView registerClass:[YXMineMainCell class] forCellReuseIdentifier:@"YXMineMainCell"];
    [self.tableView registerClass:[YXSectionHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXSectionHeaderFooterView"];
     [self.tableView registerClass:[YXMineHeaderView_17 class] forHeaderFooterViewReuseIdentifier:@"YXMineHeaderView_17"];
    
    [self.view addSubview:self.tableView];
    self.headerView = [[YXMineTableHeaderView_17 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 133.0f)];
    WEAK_SELF
    self.headerView.mineHeaderUserCompleteBlock = ^{
        STRONG_SELF
        UIViewController *VC = [[NSClassFromString(@"YXMineViewController") alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    };
    self.tableView.tableHeaderView = self.headerView;
}
- (void)layoutInterface{
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
        return self.titleArray.count;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YXMineMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXMineMainCell" forIndexPath:indexPath];
         YXTrainListRequestItem_body_train *train = [LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.trains[indexPath.row];
        cell.titleString = train.name;
        return cell;
    }else if (indexPath.section == 1) {
        YXMySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXMySettingCell" forIndexPath:indexPath];
        [cell reloadWithText:_titleArray[indexPath.row] imageName:@""];
        return cell;
    } else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"staticString" forIndexPath:indexPath];
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"0067be"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        UIView *selectedBgView = [[UIView alloc]init];
        selectedBgView.backgroundColor = [UIColor colorWithHexString:@"f2f6fa"];
        cell.selectedBackgroundView = selectedBgView;
        return cell;
    }
}

#pragma mark - tableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
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
    if (section == 0) {
        return 45.0f;
    }else {
        return 0.0001f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXMineHeaderView_17 *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXMineHeaderView_17"];
    if (section == 0) {
        [headerView reloadMasterMainHeader:@"我的项目" withTitle:@"我的项目"];
    }else {
        [headerView reloadMasterMainHeader:@"" withTitle:@""];
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        YXTrainListRequestItem_body_train *train = [LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.trains[indexPath.row];
        if (train.pid.integerValue == [LSTSharedInstance sharedInstance].trainManager.currentProject.pid.integerValue) {
            self.tabBarController.selectedIndex = 0;
        }else {
            [LSTSharedInstance sharedInstance].trainManager.currentProjectIndex = indexPath.row;
            [YXDataStatisticsManger trackEvent:@"切换项目" label:@"我页面" parameters:nil];
        }
        
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                // 清sdwebimage
                [[SDImageCache sharedImageCache] clearDisk];
                [[SDImageCache sharedImageCache] clearMemory];
                
                // 清缓存
                NSString *dp = [BaseDownloader downloadFolderPath];
                [[NSFileManager defaultManager] removeItemAtPath:dp error:nil];
                
                [[QYSDK sharedSDK] cleanResourceCacheWithBlock:^(NSError *error) {
                    
                }];
                [self showToast:@"清除成功"];
                [YXDataStatisticsManger trackEvent:@"清理缓存" label:@"成功清理缓存" parameters:nil];
            }
                break;
            case 1:
            {
#ifdef TianjinApp
                YXHelpViewController *vc = [[YXHelpViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
#else
                [[QYSDK sharedSDK] customUIConfig].customerHeadImageUrl = [LSTSharedInstance sharedInstance].userManger.userModel.profile.head;
                QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
                sessionViewController.sessionTitle = @"手机研修";
                [self.navigationController pushViewController:sessionViewController animated:YES];
#endif
            }
                break;
            case 2:
            {
                [YXDataStatisticsManger trackEvent:@"去App Store打分" label:@"我页面" parameters:nil];
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
        
    }else{
        [[LSTSharedInstance  sharedInstance].webSocketManger close];
        [[LSTSharedInstance sharedInstance].userManger logout];
        [YXDataStatisticsManger trackEvent:@"退出登录" label:@"成功登出" parameters:nil];
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

@end

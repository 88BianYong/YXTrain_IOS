//
//  YXSideMenuViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXSideMenuViewController.h"
#import "YXDatumViewController.h"
#import "YXMySettingViewController.h"
#import "YXWorkshopViewController.h"

#import "YXSideTableViewCell.h"
#import "YXUserProfileRequest.h"
#import "YXMineViewController.h"
#import "YXGuideViewController.h"
#import "YXGuideModel.h"
#import "YXHotspotViewController.h"
#import "YXDynamicViewController.h"
#import "YXWebSocketManger.h"
#import "TrainRedPointManger.h"
#import "StudentsLearnController.h"
@interface YXSideMenuViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *_titleArray;
}

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) YXUserProfile *profile;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) YXUserProfileRequest *userProfileRequest;


@end

@implementation YXSideMenuViewController {
    
    UIImageView *_iconImageView;
    UILabel *_nameLabel;
    UILabel *_schoolNameLabel;
}
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWebSocket];
    [self registerNotifications];
    self.view.backgroundColor = [UIColor whiteColor];
    self.shadowView = [[UIView alloc] init];
    self.shadowView.backgroundColor = [UIColor whiteColor];
    self.shadowView.layer.shadowColor = [UIColor colorWithHexString:@"dfe2e6"].CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(9, 0);
    self.shadowView.layer.shadowRadius = 20;
    self.shadowView.layer.shadowOpacity = 1;
    self.shadowView.hidden = YES;
    [self.view addSubview:self.shadowView];
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(@0);
    }];

    self.headerView = [[UIView alloc] init];
    [self.view addSubview:self.headerView];
    self.headerView.backgroundColor = [UIColor colorWithHexString:@"1378cd"];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 45;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[YXSideTableViewCell class] forCellReuseIdentifier:@"YXSideTableViewCell"];
    
    self.footerView = [[UIView alloc] init];
    self.footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_footerView];
    [self reloadMenuTableView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(@121);
    }];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(60);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.right.mas_equalTo(@0);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = [UIImage imageNamed:@"用户默认头像"];
    [self.headerView addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont boldSystemFontOfSize:17];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.text = @"1";
    [self.headerView addSubview:_nameLabel];
    
    _schoolNameLabel = [[UILabel alloc] init];
    _schoolNameLabel.font = [UIFont systemFontOfSize:12];
    _schoolNameLabel.textColor = [UIColor whiteColor];
    _schoolNameLabel.text = @"1";
    [self.headerView addSubview:_schoolNameLabel];
    UIView *topView = [[UIView alloc] init];
    topView.hidden = IS_IPHONE_X;
    topView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left);
        make.top.equalTo(self.headerView.mas_top);
        make.right.equalTo(self.headerView.mas_right);
        make.height.mas_offset(20.0f);
    }];
    
    
    UIButton *editButton = [[UIButton alloc] init];
    [editButton setImage:[UIImage imageNamed:@"进入编辑个人中心icon正常态"]
                forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"进入编辑个人中心icon正常态"]
                forState:UIControlStateHighlighted];
    editButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [editButton addTarget:self action:@selector(pushMineButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setImageEdgeInsets:UIEdgeInsetsMake(0,kScreenWidth *YXTrainLeftDrawerWidth/750.f - 10.0f - 18.0f, -13.0f, 0.0f)];
    [self.headerView addSubview:editButton];
    UIView *headerBottomView = [[UIView alloc] init];
    headerBottomView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.headerView addSubview:headerBottomView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@15);
        make.centerY.equalTo(self.headerView.mas_centerY).offset(10.0f);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    _iconImageView.layer.cornerRadius = 44.0/2;
    _iconImageView.layer.masksToBounds = YES;
    
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30.0f + 20.0f);
        make.left.mas_equalTo(self->_iconImageView.mas_right).mas_offset(10.0f);
        make.right.mas_equalTo(self.headerView.mas_right).offset(-50.0f);
    }];
    
    [_schoolNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headerView.mas_bottom).offset(-30.0f);
        make.left.mas_equalTo(self->_iconImageView.mas_right).mas_offset(10.0f);
        make.right.mas_equalTo(self.headerView.mas_right).offset(-50.0f);
    }];
    
    [headerBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1.0f / [UIScreen mainScreen].scale);
    }];
    
    UIView *footerBottomView = [[UIView alloc] init];
    footerBottomView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.footerView addSubview:footerBottomView];
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerButton addTarget:self action:@selector(pushSettingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"f2f6fa"]] forState:UIControlStateHighlighted];
    [footerButton setImage:[UIImage imageNamed:@"设置icon-正常态"]
                forState:UIControlStateNormal];
    [footerButton setImage:[UIImage imageNamed:@"设置icon-点击态"]
                forState:UIControlStateHighlighted];
    footerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [footerButton setImageEdgeInsets:UIEdgeInsetsMake(0,25.0f, 0, 0.0f)];
    
    
    [self.footerView addSubview:footerButton];
    
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.text = @"设置";
    footerLabel.font = [UIFont boldSystemFontOfSize:14];
    footerLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.footerView addSubview:footerLabel];
    
    [footerBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1.0f / [UIScreen mainScreen].scale);
    }];
    [footerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.footerView.mas_left).offset(69.0f);
        make.centerY.mas_equalTo(0);
    }];
    [footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.footerView);
    }];
    [self loadUserProfile];
}

- (NSArray *)configGuideArray {
    YXGuideModel *model_1 = [self guideModelWithImageName:@"" title:@"yiyi" isShowButton:NO];
    YXGuideModel *model_2 = [self guideModelWithImageName:@"" title:@"erer" isShowButton:NO];
    YXGuideModel *model_3 = [self guideModelWithImageName:@"" title:@"sansan" isShowButton:NO];
    YXGuideModel *model_4 = [self guideModelWithImageName:@"" title:@"sisi" isShowButton:YES];
    NSArray *guideArry = @[model_1,model_2,model_3,model_4];
    return guideArry;
}

- (YXGuideModel *)guideModelWithImageName:(NSString *)name title:(NSString *)titile isShowButton:(BOOL)isShowButton {
    YXGuideModel *model =[[YXGuideModel alloc] init];
    model.guideTitle = titile;
    model.guideImageString = name;
    model.isShowButton = isShowButton;
    return model;
}

- (void)loadUserProfile
{
    self.profile = [LSTSharedInstance sharedInstance].userManger.userModel.profile;
    if (!self.profile) {
        YXUserProfileRequest *request = [[YXUserProfileRequest alloc] init];
        request.targetuid = [LSTSharedInstance sharedInstance].userManger.userModel.uid;
        WEAK_SELF
        [request startRequestWithRetClass:[YXUserProfileItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            YXUserProfileItem *item = retItem;
            if (item) {
                [LSTSharedInstance sharedInstance].userManger.userModel.profile = item.editUserInfo;
                [[LSTSharedInstance sharedInstance].userManger saveUserData];
                [[NSNotificationCenter defaultCenter] postNotificationName:YXUserProfileGetSuccessNotification object:nil];
            }else {
                [self showToast:error.localizedDescription];
            }
        }];
        self.userProfileRequest = request;
    } else {
        [self reloadUserProfileView];
    }
}

- (void)reloadUserProfileView
{
    self.profile = [LSTSharedInstance sharedInstance].userManger.userModel.profile;
    _nameLabel.text = self.profile.realName;
    _schoolNameLabel.text = self.profile.school;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.profile.head] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    [self.view setNeedsLayout];
}
- (void)reloadMenuTableView{
    NSArray *trainArray = [LSTSharedInstance sharedInstance].trainManager.trainlistItem.body.trains;
    __block BOOL isShow = NO;
    [trainArray enumerateObjectsUsingBlock:^(YXTrainListRequestItem_body_train * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.w.integerValue >= 3) {
            isShow = YES;
            *stop = YES;
        }
    }];
    if (isShow){//北京项目 13,14项目没有消息动态
        _titleArray = [NSArray arrayWithArray:[LSTSharedInstance sharedInstance].trainManager.trainHelper.sideMenuArray];
    }else{
        _titleArray = @[@{@"title":@"热点",@"normalIcon":@"热点icon-正常态",@"hightIcon":@"热点icon-点击态"},
                        @{@"title":@"资源",@"normalIcon":@"资源icon正常态",@"hightIcon":@"资源icon点击态"},
                        @{@"title":[LSTSharedInstance sharedInstance].trainManager.trainHelper.workshopListTitle,@"normalIcon":@"我的工作坊icon-正常态",@"hightIcon":@"我的工作坊icon-点击态"}];
    }
    [self.tableView reloadData];
}


- (void)registerNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(reloadUserProfileView)
                   name:YXUserProfileGetSuccessNotification
                 object:nil];
    
    [center addObserver:self selector:@selector(reloadMenuTableView) name:kYXTrainListDynamic  object:nil];
}

- (void)setWebSocket {
    [[LSTSharedInstance  sharedInstance].webSocketManger open];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXSideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXSideTableViewCell" forIndexPath:indexPath];
    cell.nameDictionary = _titleArray[indexPath.section];
    cell.cellStatus = indexPath.section;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            [LSTSharedInstance sharedInstance].redPointManger.hotspotInteger = -1;
            [[LSTSharedInstance  sharedInstance].webSocketManger setState:YXWebSocketMangerState_Hotspot];
            YXHotspotViewController *hotspot = [[YXHotspotViewController alloc] init];
            [self.navigationController pushViewController:hotspot animated:YES];
        }
            break;
        case 1:
        {
            YXDatumViewController *datumVc = [[YXDatumViewController alloc] init];
            [self.navigationController pushViewController:datumVc animated:YES];
        }
            break;
        case 2:
        {
            YXWorkshopViewController *workshopVc = [[YXWorkshopViewController alloc] init];
            [self.navigationController pushViewController:workshopVc animated:YES];
        }
            break;
        case 3:
        {
            YXDynamicViewController *dynamicVc = [[YXDynamicViewController alloc] init];
            [self.navigationController pushViewController:dynamicVc animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 22.5;
    } else {
        return 15;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor whiteColor];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)displayShadowView {
    self.shadowView.hidden = NO;
    [[LSTSharedInstance  sharedInstance].webSocketManger open];
}
- (void)dismissShadowView {
    self.shadowView.hidden = YES;
}

#pragma mark - button Action
- (void)pushSettingButtonAction:(UIButton *)sender{
    YXMySettingViewController *datumVc = [[YXMySettingViewController alloc] init];
    [self.navigationController pushViewController:datumVc animated:YES];
}
- (void)pushMineButtonAction:(UIButton *)sender{
    WEAK_SELF
    YXMineViewController *vc = [[YXMineViewController alloc] init];
    vc.userInfoModifySuccess = ^(){
        STRONG_SELF
        [self reloadUserProfileView];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) {
    return UIInterfaceOrientationMaskLandscapeRight;
}
@end

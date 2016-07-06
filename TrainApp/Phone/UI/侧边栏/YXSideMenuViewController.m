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


@interface YXSideMenuViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) YXUserProfile *profile;

@property (nonatomic, strong) UIView *shadowView;

@end

@implementation YXSideMenuViewController {
    
    UIImageView *_iconImageView;
    UILabel *_nameLabel;
    UILabel *_subNameLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotifications];
    // Do any additional setup after loading the view, typically from a nib.
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
        make.width.mas_equalTo(@([UIScreen mainScreen].bounds.size.width * 600/750));
    }];

    self.headerView = [[UIView alloc] init];
    [self.view addSubview:self.headerView];
    self.headerView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer * tapHeaderGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderGesture:)];
    [self.headerView addGestureRecognizer:tapHeaderGesture];
    
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
    UITapGestureRecognizer * tapFooterGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFooterGesture:)];
    [self.footerView addGestureRecognizer:tapFooterGesture];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(@0);
        make.height.mas_equalTo(@108);
        make.width.mas_equalTo(@([UIScreen mainScreen].bounds.size.width * 600/750));
    }];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.mas_equalTo(@0);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(@([UIScreen mainScreen].bounds.size.width * 600/750));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.right.mas_equalTo(@0);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.backgroundColor = [UIColor redColor];
    [self.headerView addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont boldSystemFontOfSize:17];
    _nameLabel.textColor = [UIColor colorWithHexString:@"334466"];
    _nameLabel.text = @"123";
    [self.headerView addSubview:_nameLabel];
    
    _subNameLabel = [[UILabel alloc] init];
    _subNameLabel.font = [UIFont systemFontOfSize:12];
    _subNameLabel.textColor = [UIColor colorWithHexString:@"505f84"];
    _subNameLabel.text = @"1233455";
    [self.headerView addSubview:_subNameLabel];
    
    UIImageView *headerIconImageView = [[UIImageView alloc] init];
    headerIconImageView.backgroundColor = [UIColor redColor];
    [self.headerView addSubview:headerIconImageView];
    
    UIView *headerBottomView = [[UIView alloc] init];
    headerBottomView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.headerView addSubview:headerBottomView];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@15);
        make.bottom.mas_equalTo(@-21);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    _iconImageView.layer.cornerRadius = 45.0/2;
    _iconImageView.layer.masksToBounds = YES;
    
    [headerIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.equalTo(_iconImageView.mas_centerY);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45);
        make.left.mas_equalTo(self->_iconImageView.mas_right).mas_offset(@12);
        make.right.mas_equalTo(headerIconImageView.mas_left).offset(-20);
    }];
    
    [_subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self->_iconImageView.mas_bottom);
        make.left.mas_equalTo(self->_iconImageView.mas_right).mas_offset(@12);
        make.right.mas_equalTo(headerIconImageView.mas_left).offset(-20);
    }];
    
    [headerBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UIView *footerBottomView = [[UIView alloc] init];
    footerBottomView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.footerView addSubview:footerBottomView];
    UIImageView *footerIconImageView = [[UIImageView alloc] init];
    footerIconImageView.backgroundColor = [UIColor redColor];
    [self.footerView addSubview:footerIconImageView];
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.text = @"设置";
    footerLabel.font = [UIFont boldSystemFontOfSize:14];
    footerLabel.textColor = [UIColor colorWithHexString:@"334466"];
    [self.footerView addSubview:footerLabel];
    
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerButton addTarget:self action:@selector(pushSettingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:footerButton];
    
    
    [footerBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    [footerIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [footerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerIconImageView.mas_right).offset(21);
        make.centerY.mas_equalTo(0);
    }];
    [footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.footerView);
    }];
}

- (void)tapHeaderGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        //
        NSLog(@"tapHeader");
    }
}

- (void)tapFooterGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        //
        NSLog(@"tapFooter");
    }
}

- (void)loadUserProfile
{
    self.profile = [YXUserManager sharedManager].userModel.profile;
    if (!self.profile) {
        @weakify(self);
        [[YXUserProfileHelper sharedHelper] requestCompeletion:^(NSError *error) {
            @strongify(self);
            [self showToast:error.localizedDescription];
        }];
    } else {
        [self reloadUserProfileView];
    }
}

- (void)reloadUserProfileView
{
    self.profile = [YXUserManager sharedManager].userModel.profile;
    
    _nameLabel.text = self.profile.realName;
    _subNameLabel.text = self.profile.school;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.profile.head] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    [self.view setNeedsLayout];
}


- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center addObserver:self
//               selector:@selector(userLogoutSuccess:)
//                   name:YXUserLogoutSuccessNotification
//                 object:nil];
    [center addObserver:self
               selector:@selector(reloadUserProfileView)
                   name:YXUserProfileGetSuccessNotification
                 object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YXSideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXSideTableViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell updateWithIconNamed:@"" andName:@"资源"];
    }
    if (indexPath.section == 1) {
        [cell updateWithIconNamed:@"" andName:@"我的工作坊"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        YXDatumViewController *datumVc = [[YXDatumViewController alloc] init];
        [self.navigationController pushViewController:datumVc animated:YES];
    }else if(indexPath.section == 1){
        YXWorkshopViewController *workshopVc = [[YXWorkshopViewController alloc] init];
        [self.navigationController pushViewController:workshopVc animated:YES];
    }
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
    [self loadUserProfile];
}

- (void)displayShadowView {
    self.shadowView.hidden = NO;
}
- (void)dismissShadowView {
    self.shadowView.hidden = YES;
}

#pragma mark - button Action
- (void)pushSettingButtonAction:(UIButton *)sender{
    YXMySettingViewController *datumVc = [[YXMySettingViewController alloc] init];
    [self.navigationController pushViewController:datumVc animated:YES];
}
@end

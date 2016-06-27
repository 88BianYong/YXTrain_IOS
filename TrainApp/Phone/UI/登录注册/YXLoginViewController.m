//
//  YXLoginViewController.m
//  TrainApp
//
//  Created by 李五民 on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXLoginViewController.h"
#import "YXClickedUnderLineButton.h"
#import "YXLoginTextFiledView.h"
#import "YXLoginTopView.h"
#import "YXLoginVerifyCodeViewController.h"
#import "YXLoginByScanQRViewController.h"
#import "YXLoginModifyPasswordViewController.h"


#import "YXUserManager.h"
#import "YXLoginRequest.h"
#import "YXInitRequest.h"

@interface YXLoginViewController ()

@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *registerNumber;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) YXLoginRequest *request;

@end

@implementation YXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupUI{
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.contentSize = [UIScreen mainScreen].bounds.size;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    UIView *containerView = [[UIView alloc]init];
    [self.scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView.mas_width);
        make.height.mas_equalTo(self.scrollView.mas_height);
    }];
    
    UIImageView *QRScanImageView = [[UIImageView alloc] init];
    QRScanImageView.image = [UIImage imageNamed:@"QR-icon"];
    [containerView addSubview:QRScanImageView];
    YXClickedUnderLineButton *QRScanButton = [[YXClickedUnderLineButton alloc] initWithFrame:CGRectZero];
    QRScanButton.buttonClicked = ^{
        YXLoginByScanQRViewController *vc = [[YXLoginByScanQRViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [QRScanButton buttonTitileWithName:@"扫描二维码登录"];
    [containerView addSubview:QRScanButton];
    [QRScanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView.mas_left).offset(75);
        make.centerY.equalTo(QRScanButton.mas_centerY);
    }];
    [QRScanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(containerView.mas_bottom).offset(-kScreenSpaceHeight * 0.22);
        make.left.equalTo(QRScanImageView.mas_right).offset(5);
    }];
    
    YXClickedUnderLineButton *forgetPasswordButton = [[YXClickedUnderLineButton alloc] init];
    forgetPasswordButton.buttonClicked = ^{
        YXLoginVerifyCodeViewController *vc = [[YXLoginVerifyCodeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [forgetPasswordButton buttonTitileWithName:@"忘记密码"];
    [containerView addSubview:forgetPasswordButton];
    [forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(containerView.mas_bottom).offset(-kScreenSpaceHeight * 0.22);
        make.right.equalTo(containerView.mas_right).offset(-75);
    }];
    
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setTitleColor:[UIColor colorWithHexString:@"41c694"] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [loginButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"41c694"]] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(startLoginRequest) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.layer.borderColor = [[UIColor colorWithHexString:@"41c694"] CGColor];
    loginButton.layer.borderWidth = 1;
    loginButton.layer.cornerRadius = 2;
    loginButton.layer.masksToBounds = YES;
    [containerView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(QRScanButton.mas_top).offset(-kScreenSpaceHeight * 0.1);
        make.width.mas_equalTo(225);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    YXLoginTextFiledView *passwordView = [[YXLoginTextFiledView alloc] init];
    [passwordView setTextFiledViewBackgroundColor:[UIColor colorWithHexString:@"dae2eb"]];
    [passwordView setTextFiledEditedBackgroundColor:[UIColor colorWithHexString:@"bbc2c9"]];
    [passwordView setPlaceHolderWithString:@"请输入密码" keyType:UIKeyboardTypeDefault isSecure:YES];
    @weakify(self)
    passwordView.textChangedBlock = ^(NSString *password){
        @strongify(self)
        if (!self) {
            return;
        }
        self.password = password;
    };
    [containerView addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(loginButton.mas_top).offset(-20);
        make.width.mas_equalTo(225);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    YXLoginTextFiledView *registerView = [[YXLoginTextFiledView alloc] init];
    [registerView setTextFiledViewBackgroundColor:[UIColor colorWithHexString:@"dae2eb"]];
    [registerView setTextFiledEditedBackgroundColor:[UIColor colorWithHexString:@"bbc2c9"]];
    [registerView setPlaceHolderWithString:@"手机号／身份证／邮箱" keyType:UIKeyboardTypeDefault isSecure:NO];
    registerView.textChangedBlock = ^(NSString *registerNumber){
        @strongify(self)
        if (!self) {
            return;
        }
        self.registerNumber = registerNumber;
    };
    [containerView addSubview:registerView];
    [registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(passwordView.mas_top).offset(-10);
        make.width.mas_equalTo(225);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    YXLoginTopView *topView = [[YXLoginTopView alloc] init];
    [containerView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(registerView.mas_top);
        make.left.right.top.equalTo(containerView);
    }];
 }

- (void)startLoginRequest
{
    NSString *name = [self.registerNumber yx_stringByTrimmingCharacters];
    NSString *password = [self.password yx_stringByTrimmingCharacters];
    if (![name yx_isValidString]) {
        [self showToast:@"帐号不能为空"];
        return;
    }
    if (![password yx_isValidString]) {
        [self showToast:@"密码不能为空"];
        return;
    }
    if (!self.request) {
        self.request = [[YXLoginRequest alloc] init];
    }
    self.request.loginName = [self.registerNumber yx_safeString];
    self.request.password = [self.password yx_safeString];
    [self startLoading];
    @weakify(self);
    [self.request startRequestWithRetClass:[YXLoginRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        @strongify(self);
        [self stopLoading];
        YXLoginRequestItem *item = (YXLoginRequestItem *)retItem;
        if (!error && item) {
            if ([item.actiFlag integerValue] == 1) {
                [self showToast:@"登录成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self saveUserDataWithLoginItem:retItem];
                    if(self.loginInSuccessBlock) {
                        self.loginInSuccessBlock();
                    }
                });
            } else {
                [self showToast:@"您的帐号未激活，修改密码完成登录"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    YXLoginModifyPasswordViewController *vc = [[YXLoginModifyPasswordViewController alloc] initWithFirstLogin:YES];
//                    vc.loginName = self.request.loginName;
//                    vc.verifyType = YXLoginPhoneVerifyTypeResetPassword;
//                    [self.navigationController pushViewController:vc animated:YES];
                });
            }
        } else {
            [self showToast:error.localizedDescription];
        }
    }];
}

- (void)saveUserDataWithLoginItem:(YXLoginRequestItem *)item
{
    [YXUserManager sharedManager].userModel.uid = item.uid;
    [YXUserManager sharedManager].userModel.actiFlag = item.actiFlag;
    [YXUserManager sharedManager].userModel.uname = item.uname;
    [YXUserManager sharedManager].userModel.head = item.head;
    if (![item.token isEqualToString:[YXUserManager sharedManager].userModel.token]) {
        [YXUserManager sharedManager].userModel.token = item.token;
        [[YXInitHelper sharedHelper] requestLoginCompeletion:nil];
    }
    [YXUserManager sharedManager].userModel.token = item.token;
    [[YXUserManager sharedManager] login];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 60;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
}


@end

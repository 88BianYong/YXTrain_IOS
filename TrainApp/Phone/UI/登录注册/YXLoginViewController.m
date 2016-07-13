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
#import "YXNavigationController.h"

#import "YXUserManager.h"
#import "YXLoginRequest.h"
#import "YXInitRequest.h"
#import "YXAlertView.h"
#import "YXInitRequest.h"

@interface YXLoginViewController ()

@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *registerNumber;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) YXLoginRequest *request;
@property (nonatomic, strong) YXClickedUnderLineButton *touristLoginButton;

@end

@implementation YXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setObserver];
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
        @weakify(self);
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    YXLoginByScanQRViewController *vc = [[YXLoginByScanQRViewController alloc] init];
                    YXNavigationController *navi = [[YXNavigationController alloc] initWithRootViewController:vc];
                    [self presentViewController:navi animated:YES completion:^{
                        //
                    }];
                } else {
                    YXAlertView *alertView = [YXAlertView alertViewWithTitle:@"无法访问相机" message:@"请到“设置->隐私->相机”中设置为允许访问相机！"];
                    [alertView addButtonWithTitle:@"取消" action:^{
                        //
                    }];
                    [alertView addButtonWithTitle:@"确定" action:^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=Photos"]];
                    }];
                    [alertView show];
                }
            });
        }];
        
    };
    [QRScanButton buttonTitileWithName:@"扫描二维码登录"];
    [containerView addSubview:QRScanButton];
    
    YXClickedUnderLineButton *forgetPasswordButton = [[YXClickedUnderLineButton alloc] init];
    forgetPasswordButton.buttonClicked = ^{
        YXLoginVerifyCodeViewController *vc = [[YXLoginVerifyCodeViewController alloc] init];
        YXNavigationController *navi = [[YXNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navi animated:YES completion:^{
            //
        }];
    };
    [forgetPasswordButton buttonTitileWithName:@"忘记密码?"];
    [containerView addSubview:forgetPasswordButton];
    
    self.touristLoginButton = [[YXClickedUnderLineButton alloc] init];
    @weakify(self);
    self.touristLoginButton.buttonClicked = ^{
        @strongify(self);
        [self startTouristRequet];
    };
    [self.touristLoginButton buttonTitileWithName:@"游客登录"];
    [containerView addSubview:self.touristLoginButton];
    
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
    
    YXLoginTextFiledView *passwordView = [[YXLoginTextFiledView alloc] init];
    [passwordView setTextFiledViewBackgroundColor:[UIColor colorWithHexString:@"dae2eb"]];
    [passwordView setTextFiledEditedBackgroundColor:[UIColor colorWithHexString:@"bbc2c9"]];
    [passwordView setPlaceHolderWithString:@"请输入密码" keyType:UIKeyboardTypeDefault isSecure:YES];
    passwordView.textChangedBlock = ^(NSString *password){
        @strongify(self)
        if (!self) {
            return;
        }
        self.password = password;
    };
    [containerView addSubview:passwordView];
    
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
    
    YXLoginTopView *topView = [[YXLoginTopView alloc] init];
    [containerView addSubview:topView];

    //
    [QRScanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginButton.mas_left);
        make.centerY.equalTo(QRScanButton.mas_centerY);
    }];
    [QRScanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(containerView.mas_bottom).offset(-kScreenSpaceHeight * 0.22);
        make.left.equalTo(QRScanImageView.mas_right).offset(5);
    }];
    [forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(containerView.mas_bottom).offset(-kScreenSpaceHeight * 0.22);
        make.right.equalTo(loginButton.mas_right);
    }];
    [self.touristLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(QRScanButton.mas_bottom).offset(2);
        make.left.equalTo(QRScanImageView.mas_left);
    }];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(QRScanButton.mas_top).offset(-kScreenSpaceHeight * 0.1);
        make.width.mas_equalTo(225);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(loginButton.mas_top).offset(-20);
        make.width.mas_equalTo(225);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(passwordView.mas_top).offset(-10);
        make.width.mas_equalTo(225);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(registerView.mas_top);
        make.left.right.top.equalTo(containerView);
    }];
    self.touristLoginButton.hidden = ![[YXInitHelper sharedHelper] isAppleChecking];
 }

- (void)setObserver {
    @weakify(self);
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXInitSuccessNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        if (!self) {
            return;
        }
        self.touristLoginButton.hidden = ![[YXInitHelper sharedHelper] isAppleChecking];
    }];
}

- (void)startTouristRequet {
    [self.view endEditing:YES];
    self.registerNumber = @"XY02307777@yanxiu.com";
    self.password = @"888888";
    [self startLoginRequest];
}

- (void)startLoginRequest
{
    [self.view endEditing:YES];
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
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXLoginRequest alloc] init];
    self.request.loginName = [self.registerNumber yx_safeString];
    self.request.password = [self.password yx_safeString];
    [self startLoading];
    @weakify(self);
    [self.request startRequestWithRetClass:[YXLoginRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        @strongify(self);
        [self stopLoading];
        YXLoginRequestItem *item = (YXLoginRequestItem *)retItem;
        if (!error && item) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self saveUserDataWithLoginItem:retItem];
            });
//            if ([item.actiFlag integerValue] == 1) {
//                //[self showToast:@"登录成功"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self saveUserDataWithLoginItem:retItem];
//                    if(self.loginInSuccessBlock) {
//                        self.loginInSuccessBlock();
//                    }
//                });
//            } else {
//                [self showToast:@"您的帐号未激活，修改密码完成登录"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    YXLoginModifyPasswordViewController *vc = [[YXLoginModifyPasswordViewController alloc] initWithFirstLogin:YES];
//                    vc.loginName = self.request.loginName;
//                    vc.verifyType = YXLoginPhoneVerifyTypeResetPassword;
//                    [self.navigationController pushViewController:vc animated:YES];
//                });
//            }
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

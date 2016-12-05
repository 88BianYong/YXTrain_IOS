//
//  BeijingCheckedMobileUserViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingCheckedMobileUserViewController.h"
#import "BeijingCheckedMobileUserHeaderView.h"
#import "BeijingCheckedMobileUserCell.h"
#import "YXExamBlankHeaderFooterView.h"
#import "BeijingCheckedMobileMessageCell.h"
#import "BeijingSendSmsRequest.h"
#import "BeijingModifyPasswordRequest.h"
#import "YXWebSocketManger.h"
@interface BeijingCheckedMobileUserViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BeijingCheckedMobileUserHeaderView *headerView;
@property (nonatomic, strong) BeijingCheckedMobileUserCell *userNameCell;
@property (nonatomic, strong) BeijingCheckedMobileUserCell *passwordCell;
@property (nonatomic, strong) BeijingCheckedMobileUserCell *confirmPasswordCell;
@property (nonatomic, strong) BeijingCheckedMobileUserCell *phoneNumberCell;
@property (nonatomic, strong) BeijingCheckedMobileMessageCell *messageCell;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) BeijingSendSmsRequest *smsRequest;
@property (nonatomic, strong) BeijingModifyPasswordRequest *passwordRequest;


@end

@implementation BeijingCheckedMobileUserViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
    [self addNotification];
    self.title = @"确认信息/修改密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 60;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
- (void)naviLeftAction {
    [[YXWebSocketManger sharedInstance] close];
    [[YXUserManager sharedManager] logout];
    [YXDataStatisticsManger trackEvent:@"退出登录" label:@"成功登出" parameters:nil];
}

#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.headerView = [[BeijingCheckedMobileUserHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130.0f)];
    self.headerView.passportString = self.passportString;
    self.tableView.tableHeaderView = self.headerView;
    self.userNameCell = [[BeijingCheckedMobileUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userName"];
    self.passwordCell = [[BeijingCheckedMobileUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"password"];
    self.confirmPasswordCell = [[BeijingCheckedMobileUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"confirmPassword"];
    self.phoneNumberCell = [[BeijingCheckedMobileUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"phoneNumber"];
    self.messageCell = [[BeijingCheckedMobileMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCell"];
    [self.tableView registerClass:[YXExamBlankHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YXExamBlankHeaderFooterView"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40.0f)];
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"0067be"]
                             forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHexString:@"868fa3"]
                             forState:UIControlStateDisabled];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.confirmButton setBackgroundImage:[UIImage yx_imageWithColor:[UIColor colorWithHexString:@"0070c9"]] forState:UIControlStateHighlighted];
    self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"a1aabc"].CGColor;
    self.confirmButton.layer.cornerRadius = YXTrainCornerRadii;
    self.confirmButton.layer.borderWidth = 1.0f;
    self.confirmButton.enabled = YES;
    self.confirmButton.clipsToBounds = YES;
    [footerView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left).offset(10.0f);
        make.right.equalTo(footerView.mas_right).offset(-10.0f);
        make.top.equalTo(footerView.mas_top);
        make.bottom.equalTo(footerView.mas_bottom);
    }];
    self.tableView.tableFooterView = footerView;
}

- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)addNotification {
    @weakify(self);
    RACSignal *validUsernameSignal =
    [self.userNameCell.textField.rac_textSignal
     map:^id(NSString *text) {
         @strongify(self);
         return @([self isInformationLength:text]);
     }];
    
    RACSignal *validPasswordSignal =
    [self.passwordCell.textField.rac_textSignal
     map:^id(NSString *text) {
         @strongify(self);
         return @([self isInformationLength:text]);
     }];
    
    RACSignal *validConfirmPasswordSignal =
    [self.confirmPasswordCell.textField.rac_textSignal
     map:^id(NSString *text) {
         @strongify(self);
         return @([self isInformationLength:text]);
     }];
    
    RACSignal *validPhoneNumberSignal =
    [self.phoneNumberCell.textField.rac_textSignal
     map:^id(NSString *text) {
         @strongify(self);
         return @([self isInformationLength:text]);
     }];
    
    RACSignal *validMessageSignal =
    [self.messageCell.textField.rac_textSignal
     map:^id(NSString *text) {
         @strongify(self);
         return @([self isInformationLength:text]);
     }];
    
    RACSignal *signUpActiveSignal =
    [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal,validConfirmPasswordSignal,validPhoneNumberSignal,validMessageSignal]
                      reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid, NSNumber *confirmPasswordValid, NSNumber *phoneNumberValid, NSNumber *messageValid) {
                          return @([usernameValid boolValue] && [passwordValid boolValue] && [confirmPasswordValid boolValue] && [phoneNumberValid boolValue] && [messageValid boolValue]);
                      }];
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        STRONG_SELF
        if ([signupActive boolValue]) {
            self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"0070c9"].CGColor;
        }else {
            self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"a1aabc"].CGColor;
        }
        self.confirmButton.enabled = [signupActive boolValue];
    }];
    
    [[self.confirmButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         STRONG_SELF
         [self requestForModifyPasswordFT];
     }];
    
    [validPhoneNumberSignal  subscribeNext:^(NSNumber *phoneNumber) {
        STRONG_SELF
        if (!self.messageCell.isCountdown) {
            self.messageCell.sendButton.enabled = [phoneNumber boolValue];
        }
     }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeConfirmButtonStatus:) name:kYXTrainDeleteInfo object:nil];//手动删除内容 UITextFieldTextDidChangeNotification 不响应
}
- (void)changeConfirmButtonStatus:(NSNotification *)aNotification {
    BOOL tempBool = ((NSNumber *)aNotification.object).boolValue;
    if (tempBool) {
        self.confirmButton.layer.borderColor = [UIColor colorWithHexString:@"a1aabc"].CGColor;
        self.confirmButton.enabled = NO;
    }
}

#pragma mark - check
- (BOOL)isInformationLength:(NSString *)userName {
    return userName.length > 0 ? YES : NO;
}

- (BOOL)isPasswordCheck{
    return (self.passwordCell.textField.text.length > 0 &&
           self.confirmPasswordCell.textField.text.length > 0 &&
    (self.passwordCell.textField.text == self.confirmPasswordCell.textField.text));
}
- (BOOL)isCheckInformation {
    if (isEmpty(self.userNameCell.textField.text)) {
        [self showToast:@"姓名不能为空"];
        return NO;
    }
    if (isEmpty(self.passwordCell.textField.text)) {
        [self showToast:@"新密码不能为空"];
        return NO;
    }
    if (isEmpty(self.confirmPasswordCell.textField.text)) {
        [self showToast:@"确认密码不能为空"];
        return NO;
    }
    if (isEmpty(self.phoneNumberCell.textField.text)) {
        [self showToast:@"手机号码不能为空"];
        return NO;
    }
    if (isEmpty(self.messageCell.textField.text)) {
        [self showToast:@"短信验证码不能为空"];
        return NO;
    }
    if (![self isPasswordCheck]) {
        [self showToast:@"两次输入密码不一致"];
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            self.userNameCell.textField.placeholder = @"学员姓名";
            return self.userNameCell;
        }
            break;
        case 1:
        {
            self.passwordCell.textField.placeholder = @"新密码";
            self.passwordCell.textField.secureTextEntry = YES;
            return self.passwordCell;
        }
            break;
        case 2:
        {
            self.confirmPasswordCell.textField.placeholder = @"确认密码";
            self.confirmPasswordCell.textField.secureTextEntry = YES;
            return self.confirmPasswordCell;
        }
            break;
        case 3:
        {
            self.phoneNumberCell.textField.placeholder = @"输入手机号";
            self.phoneNumberCell.textField.keyboardType = UIKeyboardTypeNumberPad;
            return self.phoneNumberCell;
        }
            break;
        case 4:
        {
            WEAK_SELF
            [self.messageCell setBeijingCheckedMobileMessageBlock:^{
                STRONG_SELF
                [self requestForSendSms];
            }];
            return self.messageCell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}
#pragma mark - request
- (void)requestForSendSms {
    if (self.smsRequest) {
        [self.smsRequest stopRequest];
    }
    BeijingSendSmsRequest *request = [[BeijingSendSmsRequest alloc] init];
    request.mobile = self.phoneNumberCell.textField.text;
    WEAK_SELF
    [request startRequestWithRetClass:[BeijingSendSmsRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF;
        BeijingSendSmsRequestItem *item = retItem;
        if (error) {
            [self showToast:error.description];
        }else {
            if (item.ret.integerValue != 0) {
                [self.messageCell resetMobileMessage];
            }
            [self showToast:item.msg];
        }
    }];
    self.smsRequest = request;
}

- (void)requestForModifyPasswordFT{
    if ([self isCheckInformation]) {
        if (self.passwordRequest) {
            [self.passwordRequest stopRequest];
        }
        WEAK_SELF
        [self startLoading];
        BeijingModifyPasswordRequest *request = [[BeijingModifyPasswordRequest alloc] init];
        request.truename = self.userNameCell.textField.text;
        request.password = self.passwordCell.textField.text;
        request.mobile = self.phoneNumberCell.textField.text;
        request.verifycode = self.messageCell.textField.text;
        [request startRequestWithRetClass:[BeijingModifyPasswordRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self stopLoading];
            if (error) {
                [self showToast:error.description];
            }else {
                BeijingModifyPasswordRequestItem *item = retItem;
                [self showToast:item.msg];
                if (item.status.integerValue == 0) {
                    [self.navigationController popViewControllerAnimated:NO];
                }
            }
        }];
        self.passwordRequest = request;
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YXExamBlankHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXExamBlankHeaderFooterView"];
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2 || section == 4) {
        return 20.0f;
    }else {
       return 5.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

@end

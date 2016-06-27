//
//  YXLoginVerifyCodeViewController.m
//  TrainApp
//
//  Created by 李五民 on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXLoginVerifyCodeViewController.h"
#import "YXLoginFieldTableViewCell.h"
#import "YXVerifyCodeInputTableViewCell.h"
#import "YXLoginButtonTableViewCell.h"
#import "YXLoginModifyPasswordViewController.h"

#import "YXVerifyPhoneExistRequest.h"
#import "YXPhoneVerifyCodeRequest.h"
#import "YXVerifySMSCodeRequest.h"

@interface YXLoginVerifyCodeViewController ()

@property (nonatomic, strong) YXVerifyCodeInputTableViewCell *verifyCodeCell;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *verifyCode;

@property (nonatomic, strong) YXVerifyPhoneExistRequest *verigyPhoneExistRequest;
@property (nonatomic, strong) YXPhoneVerifyCodeRequest *verifyCodeRequest;
@property (nonatomic, strong) YXVerifySMSCodeRequest *verifySMSCodeRequest;

@end

@implementation YXLoginVerifyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.text = @"邮箱账户用户，请前往 pp.yanxiu.com 重置密码";
    footerLabel.font = [UIFont systemFontOfSize:13];
    footerLabel.textColor = [UIColor colorWithHexString:@"a1a3a6"];
    [footerView addSubview:footerLabel];
    [footerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(45);
    }];
    self.tableView.tableFooterView = footerView;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YXLoginFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXLoginFieldTableViewCell"];
        if (!cell) {
            cell = [[YXLoginFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YXLoginFieldTableViewCell"];
            [cell setPlaceHolderWithString:@"输入手机号" keyType:UIKeyboardTypeNumberPad isSecure:NO];
            @weakify(self)
            cell.textChangedBlock = ^(NSString *text){
                @strongify(self)
                if (!self) {
                    return;
                }
                self.phoneNumber = text;
            };
        }
        return cell;
    } else if(indexPath.section == 1) {
        YXVerifyCodeInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXVerifyCodeInputTableViewCell"];
        if (!cell) {
            cell = [[YXVerifyCodeInputTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YXVerifyCodeInputTableViewCell"];
            @weakify(self)
            cell.verifyCodeChangedBlock = ^(NSString *verifyCode){
                @strongify(self)
                if (!self) {
                    return;
                }
                self.verifyCode = verifyCode;
            };
            cell.verifyCodeAction = ^{
                @strongify(self)
                if (![self.phoneNumber yx_isPhoneNum]) {
                    [self showToast:@"请输入正确手机号"];
                    return;
                }
                [self verifyPhoneNumExist];
            };
            self.verifyCodeCell = cell;
        }
        return cell;
    } else {
        YXLoginButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXLoginButtonTableViewCell"];
        if (!cell) {
            cell = [[YXLoginButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YXLoginButtonTableViewCell"];
            [cell setTitleWithString:@"下一步"];
            @weakify(self)
            cell.buttonClicked = ^(){
                @strongify(self)
                if (!self) {
                    return;
                }
                if (![self.phoneNumber yx_isPhoneNum]) {
                    [self showToast:@"请输入正确手机号"];
                    return;
                }
                if (isEmpty(self.verifyCode)) {
                    [self showToast:@"请输入验证码"];
                    return;
                }
                [self verifySMSCode];
                //
            };
        }
        return cell;
    }
}

- (void)verifyPhoneNumExist
{
    if (self.verigyPhoneExistRequest) {
        [self.verigyPhoneExistRequest stopRequest];
    }
    self.verigyPhoneExistRequest = [[YXVerifyPhoneExistRequest alloc] init];
    self.verigyPhoneExistRequest.mobile = self.phoneNumber;
    [self startLoading];
    @weakify(self);
    [self.verigyPhoneExistRequest startRequestWithRetClass:[YXVerifyPhoneExistRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        @strongify(self);
        [self stopLoading];
        YXVerifyPhoneExistRequestItem *item = retItem;
        if (item.code.integerValue != 0) {
            [self showToast:error.localizedDescription];
            return;
        }
        if ([item isPhoneExist]) {
            [self getVerifyCodeRequest];
        } else {
            [self showToast:@"该手机号帐号不存在，请重新输入"];
        }
    }];
}

#pragma mark -

- (void)getVerifyCodeRequest
{
    if (self.verifyCodeRequest) {
        [self.verifyCodeRequest stopRequest];
    }
    self.verifyCodeRequest = [[YXPhoneVerifyCodeRequest alloc] init];
    self.verifyCodeRequest.mobile = self.phoneNumber;
    self.verifyCodeRequest.type = [NSString stringWithFormat:@"%@", @(0)];
    [self startLoading];
    @weakify(self);
    [self.verifyCodeRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        @strongify(self);
        if (!self) {
            return;
        }
        [self stopLoading];
        HttpBaseRequestItem *item = retItem;
        if (item.code.integerValue == 0 && !error) {
            [self.verifyCodeCell startTimer];
        } else {
            [self showToast:@"请求失败"];
        }
    }];
}

- (void)verifySMSCode
{
    if (self.verifySMSCodeRequest) {
        [self.verifySMSCodeRequest stopRequest];
    }
    self.verifySMSCodeRequest = [[YXVerifySMSCodeRequest alloc] init];
    self.verifySMSCodeRequest.mobile = self.phoneNumber;
    self.verifySMSCodeRequest.smsCode = self.verifyCode;
    self.verifySMSCodeRequest.type = [NSString stringWithFormat:@"%@", @(0)];
    @weakify(self);
    [self startLoading];
    [self.verifySMSCodeRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        @strongify(self);
        [self stopLoading];
        HttpBaseRequestItem *item = retItem;
        if (retItem && item.code.integerValue == 0&&!error) {
            [self.verifyCodeCell stopTimer];
            YXLoginModifyPasswordViewController *vc = [[YXLoginModifyPasswordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self showToast:item.desc];
        }
    }];
    
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

@end

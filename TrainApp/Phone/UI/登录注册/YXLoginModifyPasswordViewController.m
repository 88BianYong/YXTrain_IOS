//
//  YXLoginModifyPasswordViewController.m
//  TrainApp
//
//  Created by 李五民 on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXLoginModifyPasswordViewController.h"
#import "YXLoginFieldTableViewCell.h"
#import "YXLoginButtonTableViewCell.h"
#import "YXUserManager.h"

#import "YXResetPasswordRequest.h"

@interface YXLoginModifyPasswordViewController ()

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *verifyNewPassword;

@property (nonatomic, strong) YXResetPasswordRequest *request;

@end

@implementation YXLoginModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置新密码";
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
            [cell setRightButtonImage];
            [cell setPlaceHolderWithString:@"输入新密码" keyType:UIKeyboardTypeDefault isSecure:YES];
            @weakify(self)
            cell.textChangedBlock = ^(NSString *text){
                @strongify(self)
                if (!self) {
                    return;
                }
                self.password = text;
            };
        }
        return cell;
    } else if(indexPath.section == 1) {
        YXLoginFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXLoginFieldTableViewCell"];
        if (!cell) {
            cell = [[YXLoginFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YXLoginFieldTableViewCell"];
            [cell setRightButtonImage];
            [cell setPlaceHolderWithString:@"确认新密码" keyType:UIKeyboardTypeDefault isSecure:YES];
            @weakify(self)
            cell.textChangedBlock = ^(NSString *text){
                @strongify(self)
                if (!self) {
                    return;
                }
                self.verifyNewPassword = text;
            };
        }
        return cell;
    } else {
        YXLoginButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXLoginButtonTableViewCell"];
        if (!cell) {
            cell = [[YXLoginButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YXLoginButtonTableViewCell"];
            [cell setTitleWithString:@"完 成"];
            @weakify(self)
            cell.buttonClicked = ^(){
                @strongify(self)
                if (!self) {
                    return;
                }
                [self submitAction];
            };
        }
        return cell;
    }
}

- (void)submitAction
{
    NSString *password = self.password;
    NSString *confirmPassword = self.verifyNewPassword;
    if (!password || !confirmPassword) {
        [self showToast:@"密码不能为空"];
        return;
    }
    if (![password isEqualToString:confirmPassword]) {
        [self showToast:@"两次输入密码不一致"];
        return;
    }
    if (password.length < 6) {
        [self showToast:@"密码不能少于6位"];
        return;
    }
    [self.view endEditing:YES];
    [self resetPasswordRequest];
}

- (void)resetPasswordRequest
{
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXResetPasswordRequest alloc] init];
    self.request.loginName = self.phoneNumberString;
    self.request.password = self.password;
    [self startLoading];
    @weakify(self);
    [self.request startRequestWithRetClass:[YXResetPasswordRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        @strongify(self);
        [self stopLoading];
        YXResetPasswordRequestItem *item = (YXResetPasswordRequestItem *)retItem;
        if (retItem && !error) {
            [self showToast:@"登录成功"];
            [self saveUserDataWithResetPasswordItem:item];
//            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self showToast:error.localizedDescription];
        }
        
    }];
}

- (void)saveUserDataWithResetPasswordItem:(YXResetPasswordRequestItem *)item
{
    [YXUserManager sharedManager].userModel.token = item.token;
    [YXUserManager sharedManager].userModel.uid = item.uid;
    [YXUserManager sharedManager].userModel.uname = item.uname;
    [YXUserManager sharedManager].userModel.head = item.head;
    [[YXUserManager sharedManager] login];
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

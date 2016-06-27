//
//  YXUserManager.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YXLoginPhoneVerifyType) {
    YXLoginPhoneVerifyTypeResetPassword, // 重置密码
    YXLoginPhoneVerifyTypeRegister,      // 注册
};

typedef NS_ENUM(NSInteger, YXUserIdentityType) {
    YXUserIdentityType_Teacher = 0,         // 教师
    YXUserIdentityType_Instructor = 1       // 教研员
};



// 用户登录登出成功通知
extern NSString *const YXUserLoginSuccessNotification;
extern NSString *const YXUserLogoutSuccessNotification;

@class YXUserProfile;
@class YXCooperateGroupItem;
@interface YXUserModel : JSONModel

// 登录成功后帐号数据
@property (nonatomic, copy) NSString<Optional> *token;
@property (nonatomic, copy) NSString<Optional> *uid;
@property (nonatomic, copy) NSString<Optional> *actiFlag;
@property (nonatomic, copy) NSString<Optional> *uname;
@property (nonatomic, copy) NSString<Optional> *head;

// 校验学习码，已激活用户数据
@property (nonatomic, copy) NSString<Optional> *mobile;
@property (nonatomic, copy) NSString<Optional> *email;
@property (nonatomic, copy) NSString<Optional> *personalId;

// 用户信息
@property (nonatomic, copy) YXUserProfile<Optional> *profile;
// 工作坊数据
@property (nonatomic, copy) YXCooperateGroupItem<Optional> *groupItem;

@end

@interface YXUserManager : NSObject

@property (nonatomic, strong) YXUserModel *userModel;

+ (instancetype)sharedManager;

// 用户数据持久化存储方式
- (void)saveUserData;

// 登录成功后存储数据等操作
- (void)login;

// 登出后重置用户数据等操作
- (void)logout;

// 判断是否登录
- (BOOL)isLogin;

@end

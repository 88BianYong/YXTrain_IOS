//
//  YXResetPasswordRequest.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@interface YXResetPasswordRequestItem : HttpBaseRequestItem

@property (nonatomic, copy) NSString<Optional> *token;
@property (nonatomic, copy) NSString<Optional> *uid;
@property (nonatomic, copy) NSString<Optional> *uname;
@property (nonatomic, copy) NSString<Optional> *head;

@end

// 激活帐号、重置密码
@interface YXResetPasswordRequest : YXPostRequest

@property (nonatomic, strong) NSString *loginName;
@property (nonatomic, strong) NSString *password;

@end

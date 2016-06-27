//
//  YXLoginRequest.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@interface YXLoginRequestItem : HttpBaseRequestItem

@property (nonatomic, copy) NSString<Optional> *token;
@property (nonatomic, copy) NSString<Optional> *uid;
@property (nonatomic, copy) NSString<Optional> *actiFlag;
@property (nonatomic, copy) NSString<Optional> *uname;
@property (nonatomic, copy) NSString<Optional> *head;

@end

// 登录
@interface YXLoginRequest : YXPostRequest

@property (nonatomic, strong) NSString *loginName;
@property (nonatomic, strong) NSString *password;

@end

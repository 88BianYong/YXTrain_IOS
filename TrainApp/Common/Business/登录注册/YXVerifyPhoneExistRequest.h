//
//  YXVerifyPhoneExistRequest.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@interface YXVerifyPhoneExistRequestItem : HttpBaseRequestItem

@property (nonatomic, copy) NSString<Optional> *mobile;
@property (nonatomic, copy) NSString<Optional> *isExist;
@property (nonatomic, copy) NSString<Optional> *actiFlag;

- (BOOL)isPhoneExist;

@end

// 验证手机号帐号是否存在以及是否激活
@interface YXVerifyPhoneExistRequest : YXPostRequest

@property (nonatomic, strong) NSString *mobile;

@end

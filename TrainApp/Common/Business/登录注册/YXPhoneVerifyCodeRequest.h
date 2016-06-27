//
//  YXPhoneVerifyCodeRequest.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

// 获取验证码
@interface YXPhoneVerifyCodeRequest : YXPostRequest

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *type;

@end

//
//  YXVerifySMSCodeRequest.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

// 校验验证码
@interface YXVerifySMSCodeRequest : YXPostRequest

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *smsCode;
@property (nonatomic, strong) NSString *type;

@end

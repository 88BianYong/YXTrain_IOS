//
//  YXPhoneVerifyCodeRequest.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXPhoneVerifyCodeRequest.h"

@implementation YXPhoneVerifyCodeRequest 

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.loginServer stringByAppendingString:@"verifyCode.json"];
    }
    return self;
}

@end

//
//  YXResetPasswordRequest.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXResetPasswordRequest.h"

@implementation YXResetPasswordRequestItem

@end

@implementation YXResetPasswordRequest 

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.loginServer stringByAppendingString:@"resetPassword.json"];
    }
    return self;
}

@end

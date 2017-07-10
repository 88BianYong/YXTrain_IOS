//
//  YXLoginRequest.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXLoginRequest.h"

@implementation YXLoginRequestItem

@end

@implementation YXLoginRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.loginServer stringByAppendingString:@"login.json"];
    }
    return self;
}

@end

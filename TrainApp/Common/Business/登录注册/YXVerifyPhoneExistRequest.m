//
//  YXVerifyPhoneExistRequest.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXVerifyPhoneExistRequest.h"

@implementation YXVerifyPhoneExistRequestItem

- (BOOL)isPhoneExist
{
    return [self.isExist boolValue];
}

@end

@implementation YXVerifyPhoneExistRequest 

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"validateMobile.json"];
    }
    return self;
}

@end

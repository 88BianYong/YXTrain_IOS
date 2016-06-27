//
//  YXVerifySMSCodeRequest.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/2.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXVerifySMSCodeRequest.h"

@implementation YXVerifySMSCodeRequest 

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"validateVeriCode.json"];
    }
    return self;
}

@end

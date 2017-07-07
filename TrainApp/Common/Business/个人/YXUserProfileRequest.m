//
//  YXUserProfileRequest.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/5.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXUserProfileRequest.h"
#import "YXUserManager.h"

NSString *const YXUserProfileGetSuccessNotification = @"kYXUserProfileGetSuccessNotification";

@implementation YXUserProfileItem

@end

@implementation YXUserProfileRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"psprofile/getEditUserInfo"];
    }
    return self;
}

@end

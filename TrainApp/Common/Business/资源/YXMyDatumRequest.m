//
//  YXMyDatumRequest.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/7.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMyDatumRequest.h"
#import "YXDatumGlobalSingleton.h"

@implementation YXMyDatumRequestItem_result_list

@end

@implementation YXMyDatumRequestItem_result

@end

@implementation YXMyDatumRequestItem

@end

@implementation YXMyDatumRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"resource/myResourceList"];
    }
    return self;
}

@end

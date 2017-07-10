//
//  YXResourceCollectionRequest.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/7.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXResourceCollectionRequest.h"

@implementation YXResourceCollectionRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"resource/collection"];
    }
    return self;
}

@end

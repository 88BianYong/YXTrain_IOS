//
//  YXGetRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@implementation YXGetRequest

- (instancetype)init {
    if (self = [super init]) {
        self.token = [LSTSharedInstance sharedInstance].userManger.userModel.token;
        self.os = @"ios";
        self.ver = [LSTSharedInstance sharedInstance].configManager.clientVersion;
    }
    return self;
}
@end

//
//  YXUploadHeadImgRequest.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/8/27.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXUploadHeadImgRequest.h"

@implementation YXUploadHeadImgItem

@end

@implementation YXUploadHeadImgRequest{
}

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"resource/uploadheader"];
        self.width = @"80";
        self.height = @"80";
        self.left = @"-40";
        self.top = @"40";
        self.rate = @"1";
        self.token = [YXUserManager sharedManager].userModel.token;
    }
    return self;
}

@end

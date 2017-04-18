//
//  YXNoticeListRequest.m
//  TrainApp
//
//  Created by 李五民 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXNoticeListRequest.h"

@implementation YXNoticeAndBulletinItem

@end

@implementation YXNoticeListRequestItem_body

@end

@implementation YXNoticeListRequestItem
@end

@implementation YXNoticeListRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"guopei/noticeList"];
    }
    return self;
}

@end

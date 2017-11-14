//
//  YXBriefListRequest.m
//  TrainApp
//
//  Created by 李五民 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBriefListRequest.h"

@implementation YXBriefListRequestItem_body

@end

@implementation YXBriefListRequestItem

@end

@implementation YXBriefListRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"guopei/briefList"];
    }
    return self;
}

@end

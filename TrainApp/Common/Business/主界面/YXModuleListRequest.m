//
//  YXModuleListRequest.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXModuleListRequest.h"

@implementation YXModuleListRequestItem_body

@end

@implementation YXModuleListRequestItem

@end

@implementation YXModuleListRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"guopei/module/list"];
    }
    return self;
}
@end

//
//  YXModuleDetailRequest.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXModuleDetailRequest.h"

@implementation YXModuleDetailRequestItem

@end

@implementation YXModuleDetailRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"guopei/module/detail"];
    }
    return self;
}
@end

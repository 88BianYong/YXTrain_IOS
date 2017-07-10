//
//  YXCheckRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCheckRequest.h"
@implementation YXCheckRequestItem

@end

@implementation YXCheckRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"resource/version/check"];
    }
    return self;
}
@end

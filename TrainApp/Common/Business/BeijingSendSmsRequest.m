//
//  BeijingSendSmsRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingSendSmsRequest.h"
@implementation BeijingSendSmsRequestItem
@end
@implementation BeijingSendSmsRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"peixun/bj/sendSms"];
    }
    return self;
}
@end

//
//  BeijingActivityFilterRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingActivityFilterRequest.h"

@implementation BeijingActivityFilterRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"peixun/bj/active/condition"];
    }
    return self;
}
@end

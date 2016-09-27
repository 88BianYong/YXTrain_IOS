//
//  YXMsgReadedRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/18.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXMsgReadedRequest.h"

@implementation YXMsgReadedRequest
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"msgId"}];
}
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"notice/setMsgReaded"];
    }
    return self;
}
@end

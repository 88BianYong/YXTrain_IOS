//
//  YXTrainListRequest.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTrainListRequest.h"

@implementation YXTrainListRequestItem_body_train

@end

@implementation YXTrainListRequestItem_body

@end

@implementation YXTrainListRequestItem

@end

@implementation YXTrainListRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"guopei/trainlist"];
    }
    return self;
}
@end

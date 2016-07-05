//
//  YXWorkshopDetailRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopDetailRequest.h"
@implementation YXWorkshopDetailRequestItem
@end

@implementation YXWorkshopDetailRequest
- (instancetype)init {
    self = [super init];
    if (self) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"cooperate/detail"];
    }
    return self;
}

@end

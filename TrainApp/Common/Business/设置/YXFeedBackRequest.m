//
//  YXFeedbackRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXFeedBackRequest.h"
@implementation YXFeedBackRequestItem
@end

@implementation YXFeedBackRequest
- (instancetype)init{
    self = [super init];
    if (self) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"feedback/collect"];
    }
    return self;
}
@end

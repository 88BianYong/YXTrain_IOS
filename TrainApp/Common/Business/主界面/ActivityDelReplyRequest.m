//
//  ActivityDelReplyRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 17/1/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ActivityDelReplyRequest.h"

@implementation ActivityDelReplyRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"club/delReply"];
    }
    return self;
}
@end

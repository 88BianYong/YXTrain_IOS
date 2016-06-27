//
//  YXTaskListRequest.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTaskListRequest.h"

@implementation YXTaskListRequestItem_body_task

@end
@implementation YXTaskListRequestItem_body

@end
@implementation YXTaskListRequestItem

@end

@implementation YXTaskListRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"api/guopei/taskList"];
    }
    return self;
}
@end

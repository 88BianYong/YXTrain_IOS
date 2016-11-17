//
//  ActivityToolVideoRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityToolVideoRequest.h"
@implementation ActivityToolVideoRequestItem_Body
@end
@implementation ActivityToolVideoRequestItem
@end
@implementation ActivityToolVideoRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"club/active/tool/video"];
    }
    return self;
}
@end

//
//  YXHotReadedRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/18.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHotReadedRequest.h"

@implementation YXHotReadedRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"notice/setHotReaded"];
    }
    return self;
}
@end

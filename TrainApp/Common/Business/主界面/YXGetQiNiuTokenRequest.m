//
//  YXGetQiNiuTokenRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetQiNiuTokenRequest.h"
@implementation YXGetQiNiuTokenRequestItem

@end

@implementation YXGetQiNiuTokenRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"qiniu/genUploadToken"];
    }
    return self;
}
@end

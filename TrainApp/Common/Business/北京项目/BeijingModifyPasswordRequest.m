//
//  BeijingModifyPasswordRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingModifyPasswordRequest.h"
@implementation BeijingModifyPasswordRequestItem
@end

@implementation BeijingModifyPasswordRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/bj/modifyPasswordFT"];
    }
    
    return self;
}
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"newPwd":@"password"}];
}
@end

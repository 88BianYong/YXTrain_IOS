//
//  BeijingCheckedMobileUserRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/2.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingCheckedMobileUserRequest.h"

@implementation BeijingCheckedMobileUserRequestItem
@end
@implementation BeijingCheckedMobileUserRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/bj/checkedMobileUser"];
    }
    return self;
}
@end

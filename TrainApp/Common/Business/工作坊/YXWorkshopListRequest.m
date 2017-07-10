//
//  YXWorkshopListRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopListRequest.h"
@implementation YXWorkshopListRequestItem
@end

@implementation YXWorkshopListRequestItem_group
@end

@implementation YXWorkshopListRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"cooperate/list"];
    }
    return self;
}
@end

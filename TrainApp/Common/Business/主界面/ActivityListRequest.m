//
//  ActivityListRequest.m
//  TrainApp
//
//  Created by ZLL on 2016/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityListRequest.h"
@implementation ActivityListRequestItem_body_scheme_scheme
@end
@implementation ActivityListRequestItem_body_scheme_process
@end
@implementation ActivityListRequestItem_body_scheme
@end
@implementation ActivityListRequestItem_body_activity
@end

@implementation ActivityListRequestItem_body
@end

@implementation ActivityListRequestItem
@end

@implementation ActivityListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"club/actives"];
    }
    return self;
}
@end

//
//  YXWorkshopMemberRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWorkshopMemberRequest.h"
@implementation YXWorkshopMemberRequestItem
@end
@implementation YXWorkshopMemberRequestItem_memberList
@end

@implementation YXWorkshopMemberRequest
- (instancetype)init {
    self = [super init];
    if (self) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"cooperate/memberlist"];
    }
    return self;
}
@end

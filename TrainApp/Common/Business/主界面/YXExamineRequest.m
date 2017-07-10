//
//  YXExamineRequest.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXExamineRequest.h"

@implementation YXExamineRequestItem_body_toolExamineVo

@end
@implementation YXExamineRequestItem_body_leadingVo
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"voID"}];
}
@end
@implementation YXExamineRequestItem_body_bounsVoData
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"voID"}];
}
@end
@implementation YXExamineRequestItem_body_bounsVo

@end
@implementation YXExamineRequestItem_body

@end
@implementation YXExamineRequestItem

@end


@implementation YXExamineRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"guopei/examine"];
    }
    return self;
}

@end

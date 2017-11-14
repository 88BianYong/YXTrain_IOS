//
//  BeijingActivityFilterRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingActivityFilterRequest.h"
@implementation BeijingActivityFilterRequestItem_Filter
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"filterID":@"id"}];
}
@end
@implementation BeijingActivityFilterRequestItem_Body_Segment
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"segmentID":@"id"}];
}
@end
@implementation BeijingActivityFilterRequestItem_Body
@end
@implementation BeijingActivityFilterRequestItem
@end

@implementation BeijingActivityFilterRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/bj/condition/v2"];
    }
    return self;
}
@end

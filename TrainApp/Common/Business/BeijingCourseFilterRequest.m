//
//  BeijingCourseFilterRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingCourseFilterRequest.h"
@implementation BeijingCourseFilterRequestItem_Filter
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"filterID"}];
}
@end
@implementation BeijingCourseFilterRequestItem_Body_Segment
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"segmentID"}];
}
@end

@implementation BeijingCourseFilterRequestItem_Body
@end

@implementation BeijingCourseFilterRequestItem
@end

@implementation BeijingCourseFilterRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"peixun/bj/courselist"];
    }
    return self;
}

@end

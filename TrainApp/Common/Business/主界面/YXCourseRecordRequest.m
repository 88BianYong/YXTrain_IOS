//
//  YXCourseRecordRequest.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseRecordRequest.h"

@implementation YXCourseRecordRequestItem_body_module_course

@end

@implementation YXCourseRecordRequestItem_body_module

@end

@implementation YXCourseRecordRequestItem_body

@end

@implementation YXCourseRecordRequestItem

@end

@implementation YXCourseRecordRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"api/guopei/course/list"];
    }
    return self;
}
@end

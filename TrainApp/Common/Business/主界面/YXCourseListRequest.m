//
//  YXCourseListRequest.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseListRequest.h"

@implementation YXCourseListRequestItem_body_stage
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"stageID"}];
}
@end
@implementation YXCourseListRequestItem_body_study
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"studyID"}];
}
@end
@implementation YXCourseListRequestItem_body_type
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"typeID"}];
}
@end
@implementation YXCourseListRequestItem_body_segment
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"segmentID"}];
}
@end
@implementation YXCourseListRequestItem_body_module_course

@end
@implementation YXCourseListRequestItem_body_module

@end
@implementation YXCourseListRequestItem_body

@end
@implementation YXCourseListRequestItem
- (NSArray *)allCourses{
    NSMutableArray *courseArray = [NSMutableArray array];
    for (YXCourseListRequestItem_body_module *module in self.body.modules) {
        for (YXCourseListRequestItem_body_module_course *course in module.courses) {
            course.module_id = module.module_id;
            [courseArray addObject:course];
        }
    }
    return courseArray;
}
- (YXCourseListFilterModel *)filterModel{
    return [YXCourseListFilterModel modelFromRawData:self];
}
- (YXCourseListFilterModel *)beijingFilterModel {
    return [YXCourseListFilterModel beijingModelFromRawData:self];
}
@end

@implementation YXCourseListRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"guopei/myCourseList"];
    }
    return self;
}
@end

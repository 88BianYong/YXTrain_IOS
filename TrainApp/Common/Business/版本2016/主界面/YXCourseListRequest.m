//
//  YXCourseListRequest.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXCourseListRequest.h"

@implementation YXCourseListRequestItem_body_stage_quiz

@end

@implementation YXCourseListRequestItem_body_stage
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"stageID":@"id"}];
}
@end
@implementation YXCourseListRequestItem_body_study
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"studyID":@"id"}];
}
@end
@implementation YXCourseListRequestItem_body_type
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"typeID":@"id"}];
}
@end
@implementation YXCourseListRequestItem_body_segment
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"segmentID":@"id"}];
}
@end
@implementation YXCourseListRequestItem_body_module_course_quiz

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
- (YXCourseListFilterModel *)deyangFilterModel {
    return [YXCourseListFilterModel deyangModelFromRawData:self];
}
- (NSArray<__kindof YXCourseListRequestItem_body_stage_quiz *> *)deyangFilterStagesQuiz {
    return [YXCourseListFilterModel deyangFilterStagesQuiz:self];
}
@end

@implementation YXCourseListRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"guopei/myCourseList"];
    }
    return self;
}
@end

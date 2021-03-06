//
//  CourseListFormatModel_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseListFormatModel_17.h"
@implementation CourseListFormatModel_17
+(YXCourseListRequestItem_body_module_course *)formatModel:(CourseListRequest_17Item_Objs *)item {
    YXCourseListRequestItem_body_module_course *course  = [[YXCourseListRequestItem_body_module_course alloc] init];
    course.courses_id = item.objID;
    course.course_title = item.name;
    course.course_img = item.content.imgUrl;
    course.record = item.timeLength;
    course.courseType = item.courseType;
    course.is_selected = item.isSelected;
    course.module_id = item.stageID;
    course.isSupportApp = item.isSupportApp;
    course.type = item.type;
    return course;
}
+(YXCourseListRequestItem_body_module_course *)formatRecordModel:(YXCourseRecordRequestItem_body_module_course *)item {
    YXCourseListRequestItem_body_module_course *course  = [[YXCourseListRequestItem_body_module_course alloc] init];
    course.courses_id = item.courses_id;
    course.course_title = item.course_title;
    course.course_img = item.course_img;
    course.record = item.record;
    course.courseType = item.courseType;
    course.is_selected = item.is_selected;
    course.module_id = item.module_id;
    course.isSupportApp = item.isSupportApp;
    course.type = item.type;
    return course;
    
}
@end

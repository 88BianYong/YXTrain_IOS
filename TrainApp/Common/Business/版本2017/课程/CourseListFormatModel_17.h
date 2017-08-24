//
//  CourseListFormatModel_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXCourseListRequest.h"
#import "CourseListRequest_17.h"
@interface CourseListFormatModel_17 : NSObject
+(YXCourseListRequestItem_body_module_course *)formatModel:(CourseListRequest_17Item_Objs *)item;
@end

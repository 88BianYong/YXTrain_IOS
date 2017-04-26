//
//  DeYangCourseTableHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCourseListRequest.h"
@interface DeYangCourseTableHeaderView : UIView
@property (nonatomic, strong) YXCourseListRequestItem_body_module_course_quiz<Optional> *quiz;
@end

//
//  YXCourseDetailViewController.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "YXCourseListRequest.h"

@interface YXCourseDetailViewController : YXBaseViewController
@property (nonatomic, strong) YXCourseListRequestItem_body_module_course *course;
@end

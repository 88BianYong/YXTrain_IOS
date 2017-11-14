//
//  CourseDetailMangerViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "YXCourseListRequest.h"
#import "VideoCourseChapterViewController.h"
@interface VideoCourseDetailViewController_17 : YXBaseViewController
@property (nonatomic, strong) YXCourseListRequestItem_body_module_course *course;
@property (nonatomic, assign) NSInteger seekInteger;
@property (nonatomic, assign) VideoCourseFromWhere fromWhere;
@property (nonatomic, strong) NSString *stageString;
@property (nonatomic, assign) BOOL isHiddenTestBool;

@end

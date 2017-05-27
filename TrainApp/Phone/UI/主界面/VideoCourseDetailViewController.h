//
//  VideoCourseDetailViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "YXCourseListRequest.h"
@interface VideoCourseDetailViewController : YXBaseViewController
@property (nonatomic, strong) YXCourseListRequestItem_body_module_course *course;
@property (nonatomic, assign) NSInteger seekInteger;

@property (nonatomic, assign) BOOL isFromRecord;
@end

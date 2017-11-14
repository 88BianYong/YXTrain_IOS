//
//  CourseCenterListViewController_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXCourseBaseViewController.h"
#import "CourseListRequest_17.h"
typedef NS_ENUM(NSInteger, CourseCenterListStatus) {
    CourseCenterListStatus_Elective = 0,
    CourseCenterListStatus_Local = 1
};
@interface CourseCenterListViewController_17 : YXCourseBaseViewController
@property (nonatomic, copy) CourseListRequest_17Item_SearchTerm *conditionItem;
@property (nonatomic, assign) CourseCenterListStatus status;
@property (nonatomic, copy) NSString *tabString;
@end

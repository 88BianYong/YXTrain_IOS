//
//  YXCourseViewController.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/21.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "PagedListViewControllerBase.h"
typedef NS_ENUM(NSUInteger, YXCourseFromStatus){
    YXCourseFromStatus_Course = 0,//课程
    YXCourseFromStatus_Stage = 1,//阶段
    YXCourseFromStatus_Market = 2,//课程超市
    YXCourseFromStatus_Local  = 3,//本地课程
};


@interface YXCourseViewController : PagedListViewControllerBase
@property (nonatomic, strong) NSString *stageID; // 从考核的阶段课程进入需要传阶段的id
@property (nonatomic, assign) YXCourseFromStatus status; // 哪个入口进入
@end

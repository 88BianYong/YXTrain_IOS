//
//  YXCourseViewController.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/21.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "PagedListViewControllerBase.h"

@interface YXCourseViewController : PagedListViewControllerBase
@property (nonatomic, strong) NSString *stageID; // 从考核的阶段课程或课程超市进入需要传阶段的id
@end

//
//  YXCourseBaseViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListViewControllerBase.h"
@interface YXCourseBaseViewController : PagedListViewControllerBase
@property (nonatomic, assign) BOOL isWaitingForFilter;
- (void)setupUI;
@end

//
//  YXCourseListCell.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCourseListRequest.h"

@interface YXCourseListCell : UITableViewCell
@property (nonatomic, strong) YXCourseListRequestItem_body_module_course *course;
@end

//
//  DeYangCourseListCell.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCourseListRequest.h"
@interface DeYangCourseListCell : UITableViewCell
@property (nonatomic, strong) YXCourseListRequestItem_body_module_course *course;
@end

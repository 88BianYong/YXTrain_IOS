//
//  BeijingCourseListCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCourseListRequest.h"
@interface BeijingCourseListCell : UITableViewCell
@property (nonatomic, strong) YXCourseListRequestItem_body_module_course *course;
@end

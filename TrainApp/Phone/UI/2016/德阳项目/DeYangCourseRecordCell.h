//
//  DeYangCourseRecordCell.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCourseRecordRequest.h"
@interface DeYangCourseRecordCell : UICollectionViewCell
@property (nonatomic, strong) YXCourseRecordRequestItem_body_module_course *course;
@property (nonatomic, assign) BOOL isFirst;
@end

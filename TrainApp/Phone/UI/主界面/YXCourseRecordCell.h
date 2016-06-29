//
//  YXCourseRecordCell.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCourseRecordRequest.h"

@interface YXCourseRecordCell : UICollectionViewCell
@property (nonatomic, strong) YXCourseRecordRequestItem_body_module_course *course;
@end

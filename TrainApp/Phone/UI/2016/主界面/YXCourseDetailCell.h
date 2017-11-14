//
//  YXCourseDetailCell.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCourseDetailItem.h"
typedef NS_ENUM(NSInteger ,YXCourseDetailCellStatus) {
    YXCourseDetailCellStatus_Default,
    YXCourseDetailCellStatus_Watched,
    YXCourseDetailCellStatus_PLaying,
    YXCourseDetailCellStatus_Unknown
};

@interface YXCourseDetailCell : UITableViewCell
@property (nonatomic, strong) YXCourseDetailItem_chapter_fragment *data;
@property (nonatomic, assign) YXCourseDetailCellStatus cellStatus;
@end

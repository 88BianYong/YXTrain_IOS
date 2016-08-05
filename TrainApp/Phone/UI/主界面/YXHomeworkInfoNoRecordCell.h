//
//  YXHomeworkInfoNoRecordCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,YXHomeworkInfoNoRecordCellType) {
    YXHomeworkInfoNoRecordCell_Record = 1,
    YXHomeworkInfoNoRecordCell_Explanation = 2,
};

@interface YXHomeworkInfoNoRecordCell : UITableViewCell
@property (nonatomic ,copy) void(^noRecordHandler)(YXHomeworkInfoNoRecordCellType type);
@end

//
//  YXHomeworkInfoNoRecordCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXHomeworkInfoNoRecordCell : UITableViewCell
@property (nonatomic ,copy) void(^noRecordHandler)(YXRecordVideoInterfaceStatus type);
@end

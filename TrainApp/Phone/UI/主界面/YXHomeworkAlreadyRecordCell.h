//
//  YXHomeworkAlreadyRecordCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YXHomeworkAlreadyRecordCell : UITableViewCell
@property (nonatomic ,copy) NSString *filePath;
@property (nonatomic ,copy) void(^buttonActionHandler)(YXRecordVideoInterfaceStatus  type);

@end

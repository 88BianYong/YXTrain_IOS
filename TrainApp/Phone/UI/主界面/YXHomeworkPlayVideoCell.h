//
//  YXHomeworkPlayVideoCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXHomeworkPlayVideoCell : UITableViewCell
@property (nonatomic, copy)NSString *imageName;
@property (nonatomic ,copy) void(^buttonActionHandler)(YXRecordVideoInterfaceStatus  type);
@end

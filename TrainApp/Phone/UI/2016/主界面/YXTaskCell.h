//
//  YXTaskCell.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXTaskListRequest.h"

@interface YXTaskCell : UITableViewCell
@property (nonatomic, strong) YXTaskListRequestItem_body_task *task;
@end

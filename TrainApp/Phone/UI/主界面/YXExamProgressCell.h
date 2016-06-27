//
//  YXExamProgressCell.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXExamineRequest.h"

@interface YXExamProgressCell : UITableViewCell
@property (nonatomic, strong) YXExamineRequestItem_body_toolExamineVo *item;
@property (nonatomic, copy) void(^markAction)(UIButton *b);
@end

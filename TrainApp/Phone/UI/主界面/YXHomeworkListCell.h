//
//  YXHomeworkListCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXHomeworkListRequest.h"
@interface YXHomeworkListCell : UITableViewCell
@property (nonatomic ,strong) YXHomeworkListRequestItem_Body_Stages_Homeworks *homework;
@property (nonatomic ,assign) BOOL isLast;
@end

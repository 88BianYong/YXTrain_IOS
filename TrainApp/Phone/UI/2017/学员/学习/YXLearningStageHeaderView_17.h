//
//  YXLearningStageHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamineDetailRequest_17.h"
@interface YXLearningStageHeaderView_17 : UITableViewHeaderFooterView
@property (nonatomic, strong) ExamineDetailRequest_17Item_Stages *stage;
@property (nonatomic, strong) void(^learningStageHeaderViewBlock)(BOOL isFinish);
@end

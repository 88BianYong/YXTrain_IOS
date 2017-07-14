//
//  YXLearningStageCell_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamineDetailRequest_17.h"
@interface YXLearningStageCell_17 : UITableViewCell
@property (nonatomic, strong) NSArray<__kindof ExamineDetailRequest_17Item_Stages_Tools *> *tools;
@property (nonatomic, strong) void(^learningStageToolCompleteBlock)(ExamineDetailRequest_17Item_Stages_Tools *tool);
@end

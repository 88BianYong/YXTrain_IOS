//
//  YXLearningStageHeaderView_DeYang17.h
//  TrainApp
//
//  Created by 郑小龙 on 2018/2/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamineDetailRequest_17.h"
@interface YXLearningStageHeaderView_DeYang17 : UITableViewHeaderFooterView
@property (nonatomic, strong) ExamineDetailRequest_17Item_Examine_Process *proces;
@property (nonatomic, strong) void(^learningStageHeaderViewBlock)(BOOL isStage);
@property (nonatomic, strong) void(^learningStageExplainBlock)(UIButton *sender);

@end

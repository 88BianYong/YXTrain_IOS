//
//  YXLearningStageCell_DeYang17.h
//  TrainApp
//
//  Created by 郑小龙 on 2018/2/8.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamineDetailRequest_17.h"
@interface YXLearningStageCell_DeYang17 : UITableViewCell
@property (nonatomic, strong) NSArray<__kindof ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList *> *toolExamineVoLists;
@property (nonatomic, strong) void(^learningExamineProcesToolCompleteBlock)(ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList *tool, NSInteger tagInteger);
@end

//
//  BeijingExamGenreExplainHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeijingExamineRequest.h"
typedef void(^BeijingExamGenreExplainButtonBlock) (UIButton *sender);
typedef void (^BeijingExamGenreExplainNextBlock) (BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *tool);

@interface BeijingExamGenreExplainHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *toolExamineVo;
- (void)setBeijingExamGenreExplainNextBlock:(BeijingExamGenreExplainNextBlock)block;
- (void)setBeijingExamGenreExplainButtonBlock:(BeijingExamGenreExplainButtonBlock)block;

@end

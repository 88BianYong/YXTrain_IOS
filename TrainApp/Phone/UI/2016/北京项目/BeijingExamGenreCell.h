//
//  BeijingExamGenreCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/29.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeijingExamineRequest.h"
typedef void(^BeijingExamGenreButtonBlock) (UIButton *sender);
@interface BeijingExamGenreCell : UITableViewCell
@property (nonatomic, strong) BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *toolExamineVo;
- (void)setBeijingExamGenreButtonBlock:(BeijingExamGenreButtonBlock)block;
@end

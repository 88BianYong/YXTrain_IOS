//
//  BeijingExamTipCell.h
//  TrainApp
//
//  Created by ZLL on 2016/12/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeijingExamineRequest.h"
typedef void(^BeijingExamTipButtonBlock) (UIButton *sender);

@interface BeijingExamTipCell : UITableViewCell

@property (nonatomic, strong) NSString *tipLabelContent;
@property (nonatomic, strong) BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList *toolExamineVo;

- (void)setBeijingExamTipButtonBlock:(BeijingExamTipButtonBlock)block;

@end

//
//  YXMyLearningScoreHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalExamineRequest_17.h"
@interface YXMyLearningScoreHeaderView_17 : UITableViewHeaderFooterView
@property (nonatomic, strong) PersonalExamineRequest_17Item_Examine_Process *process;
@property (nonatomic, copy) void(^myLearningScoreButtonBlock)(UIButton *sender);
@end

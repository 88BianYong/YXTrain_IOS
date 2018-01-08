//
//  PersonTableHeaderView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterLearningInfoRequest_17.h"
@interface PersonTableHeaderView_17 : UIView
- (void)reloadPersonLearningInfo:(MasterLearningInfoRequestItem_Body_XueQing_LearningInfoList *)info withScore:(NSString *)score withPass:(NSString *)isPass;

@end

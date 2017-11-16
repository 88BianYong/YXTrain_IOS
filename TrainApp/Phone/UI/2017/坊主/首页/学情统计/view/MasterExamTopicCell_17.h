//
//  MasterExamTopicCell_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterLearningInfoRequest_17.h"
@interface MasterExamTopicCell_17 : UITableViewCell
@property (nonatomic, strong) MasterLearningInfoRequestItem_Body_Count *detail;
@property (nonatomic, copy) void(^masterExamTopicButtonBlock)(UIButton *sender);

@end

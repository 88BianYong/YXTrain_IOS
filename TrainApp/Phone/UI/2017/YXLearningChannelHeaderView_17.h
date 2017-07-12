//
//  YXLearningChannelHeaderView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamineDetailRequest_17.h"
@interface YXLearningChannelHeaderView_17 : UITableViewHeaderFooterView
@property (nonatomic, strong) ExamineDetailRequest_17Item_MockOther *mockOther;
@property (nonatomic, copy) void(^learningChannelButtonCompleteBlock)(ExamineDetailRequest_17Item_MockOther *mockOther);
@end

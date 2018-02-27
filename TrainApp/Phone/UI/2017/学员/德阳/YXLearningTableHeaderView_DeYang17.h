//
//  YXLearningTableHeaderView_DeYang17.h
//  TrainApp
//
//  Created by 郑小龙 on 2018/2/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLearningTableHeaderView_DeYang17 : UIView
@property (nonatomic, copy) NSString *isPass;
@property (nonatomic, copy) void(^learningMyScoreCompleteBlock)(BOOL isScoreBool);
@end

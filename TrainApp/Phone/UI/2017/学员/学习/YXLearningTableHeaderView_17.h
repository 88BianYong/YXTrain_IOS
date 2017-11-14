//
//  YXLearningTableHeaderView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLearningTableHeaderView_17 : UIView
@property (nonatomic, copy) NSString *scoreString;
@property (nonatomic, copy) void(^learningMyScoreCompleteBlock)(BOOL isScoreBool);
@end

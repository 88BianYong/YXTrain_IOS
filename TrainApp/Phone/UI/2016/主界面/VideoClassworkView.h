//
//  VideoClassworkView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXVideoQuestionsRequest.h"
typedef NS_ENUM(NSUInteger,VideoClassworkAnswerStatus) {
    VideoClassworkAnswerStatus_Normal = 0, //未提交答案
    VideoClassworkAnswerStatus_Right = 1,//回答正确
    VideoClassworkAnswerStatus_Error = 2,//非强制错误
    VideoClassworkAnswerStatus_ForceError//强制错误
};
@interface VideoClassworkView : UIView
@property (nonatomic, copy) void(^videoClassworkButtonActionBlock)(VideoClassworkAnswerStatus status ,NSArray *answer);
@property (nonatomic, strong) YXVideoQuestionsRequestItem_Result_Questions_Question *question;
@property (nonatomic, assign) BOOL isFullscreen;

- (void)refreshClassworkViewAnsewr:(BOOL)isTrue quizCorrect:(BOOL)isForce;
@end

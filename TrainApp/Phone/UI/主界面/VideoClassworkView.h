//
//  VideoClassworkView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXVideoQuestionsRequest.h"
typedef NS_ENUM(NSUInteger,VideoClassworkButtonStatus) {
    VideoClassworkButtonStatus_Back = 0, //返回当前章节
    VideoClassworkButtonStatus_Continue = 1,//继续学习
    VideoClassworkButtonStatus_Confirm = 2,//确认 提交答案
};
@interface VideoClassworkView : UIView
@property (nonatomic, copy) void(^videoClassworkButtonActionBlock)(VideoClassworkButtonStatus status ,NSArray *answer);
@property (nonatomic, strong) YXVideoQuestionsRequestItem_Result_Questions_Question *question;
- (void)refreshClassworkViewAnsewr:(BOOL)isTrue quizCorrect:(BOOL)isForce;
@end

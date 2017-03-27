//
//  VideoClassworkCell.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXVideoQuestionsRequest.h"
typedef NS_ENUM(NSUInteger, VideoClassworkCellStatus) {
    VideoClassworkCellStatus_Normal,//未答题
    VideoClassworkCellStatus_Right,//回答正确
    VideoClassworkCellStatus_Error//回答错误
};
@interface VideoClassworkCell : UITableViewCell
@property (nonatomic, strong) YXVideoQuestionsRequestItem_Result_Questions_Question_AnswerJson *answer;
@property (nonatomic, assign) VideoClassworkCellStatus classworkStatus;
@end

//
//  CourseTestCell_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseGetQuizesRequest_17.h"
typedef NS_ENUM(NSUInteger, CourseTestCellStatus) {
    CourseTestCellStatus_Normal,//未答题
    CourseTestCellStatus_Right,//回答正确
    CourseTestCellStatus_Error//回答错误
};
@interface CourseTestCell_17 : UITableViewCell
@property (nonatomic, strong) CourseGetQuizesRequest_17Item_Result_Questions_Questions_AnswerJson *answer;
@property (nonatomic, assign) CourseTestCellStatus classworkStatus;
@end

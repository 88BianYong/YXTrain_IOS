//
//  CourseTestViewController_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
typedef NS_ENUM(NSInteger,CourseTestSubmitStatus) {
    CourseTestSubmitStatus_NotSubmi = 0,//未作答
    CourseTestSubmitStatus_NotPass = 1,//未通过
    CourseTestSubmitStatus_Pass = 2,//通过
    CourseTestSubmitStatus_FullScore = 3//满分
};
@interface CourseTestViewController_17 : YXBaseViewController
@property (nonatomic, strong) NSString *cID;
@property (nonatomic, strong) NSString *stageString;
@property (nonatomic, copy) void(^courseTestQuestionBlock)(BOOL isFullBool);
@end

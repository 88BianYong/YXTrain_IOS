//
//  CourseTestViewController_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"

@interface CourseTestViewController_17 : YXBaseViewController
@property (nonatomic, strong) NSString *cID;
@property (nonatomic, strong) NSString *stageString;
@property (nonatomic, copy) void(^courseTestQuestionBlock)(BOOL isFullBool);
@end

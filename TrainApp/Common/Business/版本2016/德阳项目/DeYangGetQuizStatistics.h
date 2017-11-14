//
//  DeYangGetQuizStatistics.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXCourseListRequest.h"
@interface DeYangGetQuizStatisticsItem : HttpBaseRequestItem
@property (nonatomic, copy) YXCourseListRequestItem_body_stage_quiz *body;
@end

@interface DeYangGetQuizStatistics : YXGetRequest
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *stageid;
@end

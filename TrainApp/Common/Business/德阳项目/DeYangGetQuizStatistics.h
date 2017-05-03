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

@end

@interface DeYangGetQuizStatistics : YXGetRequest
@property (nonatomic, strong) NSString *projectid;
@property (nonatomic, strong) NSString *w;
@property (nonatomic, strong) NSString *role;
@end

//
//  DeYangGetQuizStatistics.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/3.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "DeYangGetQuizStatistics.h"
@implementation DeYangGetQuizStatisticsItem
@end
@implementation DeYangGetQuizStatistics
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"quiz/getQuizStatistics"];
    }
    return self;
}

@end

//
//  MasterHomeworkSetRecommendRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkSetRecommendRequest_17.h"

@implementation MasterHomeworkSetRecommendRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/homeworkSet/recHomeworkSet"];
    }
    return self;
}
@end

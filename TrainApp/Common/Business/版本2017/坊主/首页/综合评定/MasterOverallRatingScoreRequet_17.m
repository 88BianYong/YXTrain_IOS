//
//  MasterOverallRatingScoreRequet_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterOverallRatingScoreRequet_17.h"

@implementation MasterOverallRatingScoreRequet_17
- (instancetype)init{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/overallRating/score"];
    }
    return self;
}
@end

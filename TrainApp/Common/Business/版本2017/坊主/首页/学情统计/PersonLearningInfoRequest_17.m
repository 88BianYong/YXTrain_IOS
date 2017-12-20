//
//  PersonLearningInfoRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PersonLearningInfoRequest_17.h"

@implementation PersonLearningInfoRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/personLearningInfo"];
        self.hook = @"yes";
    }
    return self;
}
@end


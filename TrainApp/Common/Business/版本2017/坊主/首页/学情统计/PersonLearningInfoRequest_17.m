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
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/learningInfoIndex"];
        self.urlHead = @"http://mobile.yanxiu.com/test/api/peixun/examine/detail?hook=yes&projectid=2393&os=ios&token=d4b805da40c00baeb54d5a030b63f77d&role=9&ver=2.5.4";
    }
    return self;
}
@end


//
//  MasterRemindStudyRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterRemindStudyRequest.h"

@implementation MasterRemindStudyRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"master/getLearningInfoListt"];
    }
    return self;
}
@end

//
//  MasterLearningInfoListRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterLearningInfoListRequest.h"
@implementation MasterLearningInfoListRequestItem_Body_LearningInfoList
@end
@implementation MasterLearningInfoListRequestItem_Body
@end
@implementation MasterLearningInfoListRequestItem
@end
@implementation MasterLearningInfoListRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"master/getLearningInfoListt"];
    }
    return self;
}
@end

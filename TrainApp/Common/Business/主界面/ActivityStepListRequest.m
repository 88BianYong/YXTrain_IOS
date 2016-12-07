//
//  ActivityStepListRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/10.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityStepListRequest.h"
@implementation ActivityStepListRequestItem_Body
@end

@implementation ActivityStepListRequestItem
- (ActivityStepListRequestItem *)activityDetailFormatItem:(ActivityListRequestItem_body_activity *)activity {
    self.body.active.joinUserCount = activity.joinUserCount;
    self.body.active.studyName = activity.studyName;
    self.body.active.segmentName = activity.segmentName;
    return self;
}
@end

@implementation ActivityStepListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"club/active"];
    }
    return self;
}
@end

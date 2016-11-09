//
//  ActivityListRequest.m
//  TrainApp
//
//  Created by ZLL on 2016/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityListRequest.h"

@implementation ActivityListRequestItem_body_activity
@end

@implementation ActivityListRequestItem_body
@end

@implementation ActivityListRequestItem
- (NSArray *)allActivities {
    NSMutableArray *activityArray = [NSMutableArray array];
    for (ActivityListRequestItem_body_activity *activity in self.body.actives) {
        [activityArray addObject:activity];
    }
    return activityArray;
}
@end

@implementation ActivityListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"club/actives"];
    }
    return self;
}
@end

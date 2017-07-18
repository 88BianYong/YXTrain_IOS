//
//  CourseHistoryListRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseHistoryListRequest_17.h"

@implementation CourseHistoryListRequest_17
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"projectid":@"projectID"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/examine/score"];
    }
    return self;
}
@end

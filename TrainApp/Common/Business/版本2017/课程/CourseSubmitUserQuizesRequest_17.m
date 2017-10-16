//
//  CourseSubmitUserQuizesRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseSubmitUserQuizesRequest_17.h"
@implementation CourseSubmitUserQuizesRequest_17Item_Data
@end

@implementation CourseSubmitUserQuizesRequest_17Item
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"correctNum":@"correctnum",
                                                                  @"totalNum":@"totalnum",
                                                                  @"passRate":@"passrate",
                                                                  @"isPass":@"ispass"}];
}
@end
@implementation CourseSubmitUserQuizesRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"quiz/submitUserQuizes"];
        self.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    }
    return self;
}
@end

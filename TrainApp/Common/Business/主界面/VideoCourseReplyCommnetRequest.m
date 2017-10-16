//
//  VideoCourseReplyCommnetRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseReplyCommnetRequest.h"
@implementation VideoCourseReplyCommnetRequestItem_Body
@end
@implementation VideoCourseReplyCommnetRequestItem
@end

@implementation VideoCourseReplyCommnetRequest
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"commentID":@"id",
                                                                  @"courseID":@"courseId"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/course/replyCommnet"];
    }
    return self;
}
@end

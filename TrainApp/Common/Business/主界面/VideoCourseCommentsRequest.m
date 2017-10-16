//
//  VideoCourseCommentsRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseCommentsRequest.h"
@implementation VideoCourseCommentsRequestItem
@end
@implementation VideoCourseCommentsRequestItem_Body@end
@implementation VideoCourseCommentsRequestItem_Body_Comments
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"commentID":@"id",
                                                                  @"userName": @"usnm",
                                                                  @"content":@"ct",
                                                                  @"childNum":@"rpnm",
                                                                  @"laudNumber":@"unm",
                                                                  @"parentId":@"tgid"}];
}
@end
@implementation VideoCourseCommentsRequest
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"commentID":@"id",
                                                                  @"courseID":@"courseId",
                                                                  @"parentID":@"parentId"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/course/comments"];
    }
    return self;
}
@end

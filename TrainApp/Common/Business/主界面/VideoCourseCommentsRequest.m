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
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"commentID",
                                                       @"usnm":@"userName",
                                                       @"ct":@"content",
                                                       @"rpnm":@"childNum",
                                                       @"unm":@"laudNumber",
                                                       @"tgid":@"parentId"}];
}
@end
@implementation VideoCourseCommentsRequest
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"commentID",
                                                       @"courseId":@"courseID",
                                                       @"parentId":@"parentID"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"peixun/course/comments"];
    }
    return self;
}
@end

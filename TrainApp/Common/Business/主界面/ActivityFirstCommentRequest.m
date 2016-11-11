//
//  ActivityFirstCommentRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityFirstCommentRequest.h"
@implementation ActivityFirstCommentRequestItem_Body_Replies
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"commentID",
                                                       @"foorl":@"isFoorl"}];
}
@end
@implementation ActivityFirstCommentRequestItem_Body
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
@implementation ActivityFirstCommentRequestItem
@end
@implementation ActivityFirstCommentRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"club/replies"];
    }
    return self;
}
@end

//
//  YXHomeworkInfoRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHomeworkInfoRequest.h"
@implementation YXHomeworkInfoRequestItem
@end
@implementation YXHomeworkInfoRequestItem_Body
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"requireId",@"description":@"depiction"}];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
@implementation YXHomeworkInfoRequestItem_Body_Detail

@end

@implementation YXHomeworkInfoRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"guopei/homeworkInfo"];
    }
    return self;
}
@end

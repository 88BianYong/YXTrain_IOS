//
//  YXHomeworkListRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHomeworkListRequest.h"
@implementation YXHomeworkListRequestItem
@end
@implementation YXHomeworkListRequestItem_Body
@end
@implementation YXHomeworkListRequestItem_Body_Stages
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"stagesId"}];
}
@end
@implementation YXHomeworkListRequestItem_Body_Stages_Homeworks
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"requireId",@"description":@"depiction"}];
}
@end


@implementation YXHomeworkListRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"guopei/homeworkList"];
    }
    return self;
}
@end

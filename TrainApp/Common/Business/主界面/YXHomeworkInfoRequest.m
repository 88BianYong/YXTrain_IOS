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
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"requireId":@"id",
                                                                  @"depiction":@"description"}];
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
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"guopei/homeworkInfo"];
    }
    return self;
}
@end

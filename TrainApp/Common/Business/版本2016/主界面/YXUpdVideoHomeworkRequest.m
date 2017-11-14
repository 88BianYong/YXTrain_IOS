//
//  YXUpdVideoHomeworkRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/18.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXUpdVideoHomeworkRequest.h"
@implementation YXUpdVideoHomeworkRequestData
@end

@implementation YXUpdVideoHomeworkRequestItem_Data

@end
@implementation YXUpdVideoHomeworkRequestModel
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"contentId":@"id"}];
}
@end


@implementation YXUpdVideoHomeworkRequestItem

@end


@implementation YXUpdVideoHomeworkRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/homework/updVideoHomework"];
    }
    return self;
}
@end

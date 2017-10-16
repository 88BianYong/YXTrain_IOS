//
//  YXStageAndSubjectRequest.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/11.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXStageAndSubjectRequest.h"

@implementation YXStageAndSubjectItem_Stage_Subject

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"sid":@"id"}];
}

@end

@implementation YXStageAndSubjectItem_Stage

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"sid":@"id"}];
}

@end

@implementation YXStageAndSubjectItem

@end

@implementation YXStageAndSubjectRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"stageSubject"];
    }
    return self;
}

@end

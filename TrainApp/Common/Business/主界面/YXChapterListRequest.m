//
//  YXChapterListRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXChapterListRequest.h"
@implementation YXChapterListRequestItem_sub

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"chapterId",
                                                       }];
}

@end
@implementation YXChapterListRequestItem
@end

@implementation YXChapterListRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"meizi/resource-chapter/cascade2"];
    }
    return self;
}

@end

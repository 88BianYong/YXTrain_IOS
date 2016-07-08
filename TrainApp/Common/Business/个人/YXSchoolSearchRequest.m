//
//  YXSchoolSearchRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/7/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXSchoolSearchRequest.h"
@implementation YXSchool

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"sid"}];
}

@end

@implementation YXSchoolSearchItem

@end

@implementation YXSchoolSearchRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"psprofile/searchSchoolInfo"];
    }
    return self;
}

@end

//
//  YXDatumSearchRequest.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/7.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXDatumSearchRequest.h"

@implementation YXDatumSearchRequestItem_data

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"datumId":@"id",
                                                                  @"typeId":@"typeid"}];
}

@end

@implementation YXDatumSearchRequestItem

@end

@implementation YXDatumSearchRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"search/search"];
    }
    return self;
}

@end

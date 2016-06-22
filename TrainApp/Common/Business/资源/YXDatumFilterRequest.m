//
//  YXDatumFilterRequest.m
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/6.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXDatumFilterRequest.h"

@implementation YXDatumFilterRequestItem_data_cataele

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"elementId"}];
}

@end

@implementation YXDatumFilterRequestItem_data

@end

@implementation YXDatumFilterRequestItem

@end
@implementation YXDatumFilterRequest

/*
 中职 id  60   转换1205
 小学 id  10   转换1202
 初中 id  20   转换1203
 高中 id  30   转换1204
 学前教育  id  0 转化1201
 */
- (NSString *)stage {
    int org = [_stage intValue];
    if (org == 60) {
        return @"1205";
    }
    if (org == 10) {
        return @"1202";
    }
    if (org == 20) {
        return @"1203";
    }
    if (org == 30) {
        return @"1204";
    }
    if (org == 0) {
        return @"1201";
    }
    
    return [NSString stringWithFormat:@"%@", @(org)];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"search/stagecataelelist"];
    }
    return self;
}

@end

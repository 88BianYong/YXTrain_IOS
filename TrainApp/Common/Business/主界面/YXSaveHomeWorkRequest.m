//
//  YXSaveHomeWorkRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXSaveHomeWorkRequest.h"
@implementation YXSaveHomeWorkRequestModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"des",
                                                       }];
}
@end

@implementation YXSaveHomeWorkRequestItem

@end

@implementation YXSaveHomeWorkRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"newupload/resource"];
    }
    return self;
}
@end

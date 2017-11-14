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
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"des":@"description",
                                                       }];
}
@end

@implementation YXSaveHomeWorkRequestItem

@end

@implementation YXSaveHomeWorkRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"newupload/resource"];
    }
    return self;
}
@end

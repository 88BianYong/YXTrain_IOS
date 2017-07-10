//
//  YXHotspotRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/13.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXHotspotRequest.h"
@implementation YXHotspotRequestItem_Data
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"hotspotId"}];
}

@end

@implementation YXHotspotRequestItem

@end


@implementation YXHotspotRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"notice/getHotspots"];
    }
    return self;
}
@end

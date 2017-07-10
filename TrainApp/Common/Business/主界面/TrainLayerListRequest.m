//
//  TrainLayerListRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "TrainLayerListRequest.h"
@implementation TrainLayerListRequestItem_Body
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"layerId"}];
}
@end
@implementation TrainLayerListRequestItem
@end

@implementation TrainLayerListRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/layer/list"];
    }
    return self;
}
@end

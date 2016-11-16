//
//  ShareResourcesRequest.m
//  TrainApp
//
//  Created by ZLL on 2016/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ShareResourcesRequest.h"
@implementation ActivityListRequestItem_body_resource
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"resid":@"resId",
                                                       @"resname":@"resName",
                                                       @"res_type":@"resType",
                                                       @"res_size":@"resSize",
                                                        @"previewurl":@"previewUrl",
                                                        @"downloadurl":@"downloadUrl"
                                                       }];
}
@end

@implementation ShareResourcesRequest_body
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"toolid":@"toolId"}];
}
@end

@implementation ShareResourcesRequestItem

@end

@implementation ShareResourcesRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"club/active/tool/resources"];
    }
    return self;
}
@end

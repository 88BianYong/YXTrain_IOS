//
//  ShareResourcesRequest.m
//  TrainApp
//
//  Created by ZLL on 2016/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ShareResourcesRequest.h"
@implementation ShareResourcesRequestItem_body_resource
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"resid":@"resId",
                                                       @"resname":@"resName",
                                                       @"filetype":@"fileType",
                                                       @"res_size":@"resSize",
                                                       @"res_type":@"resType",
                                                       @"previewurl":@"previewUrl",
                                                       @"downloadurl":@"downloadUrl",
                                                       @"external_url":@"externalUrl"
                                                       }];
}
@end

@implementation ShareResourcesRequestItem_body
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

//
//  ResourcesDownloadRequest.m
//  TrainApp
//
//  Created by ZLL on 2016/11/18.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ResourcesDownloadRequest.h"
@implementation ResourcesDownloadRequestItem_body_resource
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

@implementation ResourcesDownloadRequestItem_body
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"toolid":@"toolId"}];
}
@end

@implementation ResourcesDownloadRequestItem

@end

@implementation ResourcesDownloadRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"club/active/tool/download"];
    }
    return self;
}
@end

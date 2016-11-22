//
//  DownloadResourceRequest.m
//  TrainApp
//
//  Created by ZLL on 2016/11/22.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "DownloadResourceRequest.h"
@implementation DownloadResourceRequestItem_body_resource
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"resid":@"resId",
                                                       @"resname":@"resName",
                                                       @"filetype":@"fileType",
                                                       @"res_size":@"resSize",
                                                       @"previewurl":@"previewUrl",
                                                       @"downloadurl":@"downloadUrl"
                                                       }];
}
@end

@implementation DownloadResourceRequestItem_body
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"toolid":@"toolId"}];
}
@end

@implementation DownloadResourceRequestItem

@end

@implementation DownloadResourceRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"club/active/tool/download"];
    }
    return self;
}
@end

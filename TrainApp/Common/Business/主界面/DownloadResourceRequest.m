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
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"club/active/tool/download"];
    }
    return self;
}
@end

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
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"resId":@"resid",
                                                                  @"resName":@"resname",
                                                                  @"fileType":@"filetype",
                                                                  @"resSize":@"res_size",
                                                                  @"resType":@"res_type",
                                                                  @"previewUrl":@"previewurl",
                                                                  @"downloadUrl": @"downloadurl",
                                                                  @"externalUrl":@"external_url"}];
}
@end

@implementation DownloadResourceRequestItem_body
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"toolId":@"toolid"}];
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

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
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"resId":@"resid",
                                                                  @"resName":@"resname",
                                                                  @"fileType":@"filetype",
                                                                  @"resSize":@"res_size",
                                                                  @"resType":@"res_type",
                                                                  @"previewUrl":@"previewurl",
                                                                  @"downloadUrl":@"downloadurl",
                                                                  @"externalUrl":@"external_url"}];
}
@end

@implementation ShareResourcesRequestItem_body
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"toolId":@"toolid"}];
}
@end

@implementation ShareResourcesRequestItem

@end

@implementation ShareResourcesRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"club/active/tool/resources"];
    }
    return self;
}
@end

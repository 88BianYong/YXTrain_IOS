//
//  ActivityToolVideoRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityToolVideoRequest.h"
@implementation ActivityToolVideoRequestItem_Body_Content
@end
@implementation ActivityToolVideoRequestItem_Body
- (ActivityToolVideoRequestItem_Body_Content * __nullable)formatToolVideo{
    __block ActivityToolVideoRequestItem_Body_Content *content = nil;
    [self.content enumerateObjectsUsingBlock:^(ActivityToolVideoRequestItem_Body_Content * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.filetype isEqualToString:@"video"] || [obj.res_type isEqualToString:@"unknown"] ) {
            content = obj;
            *stop = YES;
        }
    }];
    return content;
}
- (ActivityToolVideoRequestItem_Body_Content * __nullable)formatToolEnclosure{
    __block ActivityToolVideoRequestItem_Body_Content *content = nil;
    [self.content enumerateObjectsUsingBlock:^(ActivityToolVideoRequestItem_Body_Content * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YXFileType fileType= [YXAttachmentTypeHelper fileTypeWithTypeName:obj.filetype];
        if (fileType == YXFileTypeDoc) {
            content = obj;
            *stop = YES;
        }
    }];
    return content;
}
@end
@implementation ActivityToolVideoRequestItem
@end
@implementation ActivityToolVideoRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"club/active/tool/video"];
    }
    return self;
}
@end

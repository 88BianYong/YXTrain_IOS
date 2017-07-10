//
//  YXProvincesRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/9/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXProvincesRequest.h"

@implementation YXProvincesRequestItem_subArea
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end


@implementation YXProvincesRequestItem
@end

@implementation YXProvincesRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"getAllProvinces"];
    }
    return self;
}
@end

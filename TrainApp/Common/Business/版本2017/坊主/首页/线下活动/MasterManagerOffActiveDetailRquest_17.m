//
//  MasterManagerOffActiveDetailRquest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManagerOffActiveDetailRquest_17.h"
@implementation MasterManagerOffActiveDetailItem_Body_Affix
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"resId":@"resid",
                                            @"resName":@"resname",
                                            @"previewUrl":@"previewurl",
                                            @"downloadUrl":@"previewurl",
                                            @"convertStatus":@"convertstatus"
                                            }];
}
@end

@implementation MasterManagerOffActiveDetailItem_Body
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"activeId":@"aid",
                                            @"topicId":@"topicid",
                                            @"barId":@"barid"
                                            }];
}
@end

@implementation MasterManagerOffActiveDetailItem
@end
@implementation MasterManagerOffActiveDetailRquest_17
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithModelToJSONDictionary:@{@"aId":@"aid"
                                            }];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/offActiveDetail"];
    }
    return self;
}
@end

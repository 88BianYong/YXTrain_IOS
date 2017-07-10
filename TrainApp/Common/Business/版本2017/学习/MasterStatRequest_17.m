//
//  MasterStatRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterStatRequest_17.h"
@implementation MasterStatRequest_17Item_Banner
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"bannerID"}];
}
@end
@implementation MasterStatRequest_17Item_Other


@end
@implementation MasterStatRequest_17Item_Expert
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"expertProjectId":@"expertProjectID"}];
}
@end
@implementation MasterStatRequest_17Item_Stages_Tools
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"toolid":@"toolID"}];
}
@end
@implementation MasterStatRequest_17Item_Stages
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"stageid":@"stageID",
                                                       @"starttime":@"startTime"}];
}
@end
@implementation MasterStatRequest_17Item_User
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"userId":@"userID"}];
}
@end

@implementation MasterStatRequest_17Item

@end
@implementation MasterStatRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/2017/person/examine"];
    }
    return self;
}
@end

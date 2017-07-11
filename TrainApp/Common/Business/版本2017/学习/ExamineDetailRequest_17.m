//
//  ExamineDetailRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ExamineDetailRequest_17.h"
@implementation ExamineDetailRequest_17Item_Banner
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"bannerID"}];
}
@end
@implementation ExamineDetailRequest_17Item_Other


@end
@implementation ExamineDetailRequest_17Item_Expert
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"expertProjectId":@"expertProjectID"}];
}
@end
@implementation ExamineDetailRequest_17Item_Stages_Tools
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"toolid":@"toolID"}];
}
@end
@implementation ExamineDetailRequest_17Item_Stages
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"stageid":@"stageID",
                                                       @"starttime":@"startTime"}];
}
@end
@implementation ExamineDetailRequest_17Item_User
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"userId":@"userID"}];
}
@end

@implementation ExamineDetailRequest_17Item

@end
@implementation ExamineDetailRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/examine/detail"];
    }
    return self;
}
@end

//
//  ActivityFilterRequest.m
//  TrainApp
//
//  Created by ZLL on 2016/11/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityFilterRequest.h"
#import "ActivityFilterModel.h"
@implementation ActivityFilterRequestItem_body_stage
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"stageID"}];
}
@end

@implementation ActivityFilterRequestItem_body_study
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"studyID"}];
}
@end

@implementation ActivityFilterRequestItem_body_segment
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"segmentID"}];
}
@end

@implementation ActivityFilterRequestItem_body
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"stage":@"stages",
                                                       @"segment":@"segments",
                                                       @"study":@"studys"
                                                       }];
}

@end

@implementation ActivityFilterRequestItem
- (ActivityFilterModel *)filterModel {
    return [ActivityFilterModel modelFromRawData:self];
}
@end

@implementation ActivityFilterRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"club/condition"];
    }
    return self;
}
@end

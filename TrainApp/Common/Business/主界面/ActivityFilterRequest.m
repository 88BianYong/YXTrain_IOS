//
//  ActivityFilterRequest.m
//  TrainApp
//
//  Created by ZLL on 2016/11/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityFilterRequest.h"
#import "ActivityFilterModel.h"
@implementation ActivityFilterRequestItem_body_default
@end

@implementation ActivityFilterRequestItem_body_stage
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"stageID":@"id"}];
}
@end

@implementation ActivityFilterRequestItem_body_study
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"studyID":@"id"}];
}
@end

@implementation ActivityFilterRequestItem_body_segment
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"segmentID":@"id"}];
}
@end

@implementation ActivityFilterRequestItem_body
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"stages":@"stage",
                                                                  @"segments":@"segment",
                                                                  @"studys":@"study",
                                                                  @"defaultChoose":@"default"}];
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

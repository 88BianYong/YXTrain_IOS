//
//  CourseCenterListRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseCenterListRequest_17.h"
@implementation CourseCenterListRequest_17Item_Summary
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"courseNum":@"coursenum",
                                                                  @"studyNum":@"studynum",
                                                                  @"finishNum":@"finishnum",
                                                                  @"courseTime":@"coursetime"}];
}
@end

@implementation CourseCenterListRequest_17Item

@end

@implementation CourseCenterListRequest_17
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"projectID":@"projectid",
                                                                  @"stageID":@"stageid"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/course/centerlist"];
        self.themeid = [LSTSharedInstance sharedInstance].trainManager.currentProject.themeId;
        self.layerid = [LSTSharedInstance sharedInstance].trainManager.currentProject.layerId;
    }
    return self;
}
@end

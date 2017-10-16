//
//  CourseCenterConditionRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseCenterConditionRequest_17.h"
@implementation CourseCenterConditionRequest_17Item_CourseTypes
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"typeID":@"id"}];
}
@end
@implementation CourseCenterConditionRequest_17
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"projectID":@"projectid",
                                                                  @"themeID":@"themeid",
                                                                  @"layerID":@"layerid"}];
}- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/course/centercondition"];
        self.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
        self.themeID = [LSTSharedInstance sharedInstance].trainManager.currentProject.themeId;
        self.layerID = [LSTSharedInstance sharedInstance].trainManager.currentProject.layerId;
    }
    return self;
}
@end

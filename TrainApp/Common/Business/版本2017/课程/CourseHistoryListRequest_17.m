//
//  CourseHistoryListRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/18.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseHistoryListRequest_17.h"

@implementation CourseHistoryListRequest_17
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"projectid":@"projectID",
                                                       @"themeid":@"themeID",
                                                       @"layerid":@"layerID",
                                                       @"stageid":@"stageID"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/course/history"];
        self.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
        self.themeID = [LSTSharedInstance sharedInstance].trainManager.currentProject.themeId;
        self.layerID = [LSTSharedInstance sharedInstance].trainManager.currentProject.layerId;
    }
    return self;
}
@end

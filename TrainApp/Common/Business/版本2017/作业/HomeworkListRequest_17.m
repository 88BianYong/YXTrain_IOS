//
//  HomeworkListRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "HomeworkListRequest_17.h"
@implementation HomeworkListRequest_17Item_Scheme_Process
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"userFinishNum":@"userfinishnum",
                                                                  @"userFinishScore":@"userfinishscore"}];
}
@end

@implementation HomeworkListRequest_17Item_Scheme_Scheme
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"toolID":@"toolid",
                                                                  @"finishNum":@"finishnum",
                                                                  @"finishScore":@"finishscore"}];
}
@end

@implementation HomeworkListRequest_17Item_Homeworks
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"rID":@"id",
                                                                  @"toolID":@"toolid",
                                                                  @"stageID":@"stageid",
                                                                  @"toolID":@"toolid",
                                                                  @"desc":@"description",
                                                                  @"userID":@"userid",
                                                                  @"createTime":@"createtime",
                                                                  @"templateID":@"templateid",
                                                                  @"homeworkID":@"homeworkid",
                                                                  @"homeworkTitle":@"homeworktitle",
                                                                  @"finishNum":@"finishnum",
                                                                  @"themeID":@"themeid",
                                                                  @"homeworkTitle":@"homeworktitle",
                                                                  @"projectID":@"projectid",
                                                                  @"subProjectID":@"subprojectid",
                                                                  @"totalNum":@"totalnum"}];
}
@end

@implementation HomeworkListRequest_17Item_Scheme

@end

@implementation HomeworkListRequest_17Item

@end

@implementation HomeworkListRequest_17
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"projectID":@"projectid",
                                                                  @"stageID":@"stageid",
                                                                  @"toolID":@"toolid"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/homework/list"];
        self.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    }
    return self;
}
@end

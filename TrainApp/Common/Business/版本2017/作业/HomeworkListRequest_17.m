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
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"userfinishnum":@"userFinishNum",
                                                       @"userfinishscore":@"userFinishScore"}];
}
@end

@implementation HomeworkListRequest_17Item_Scheme_Scheme
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"toolid":@"toolID",
                                                       @"finishnum":@"finishNum",
                                                       @"finishscore":@"finishScore"}];
}
@end

@implementation HomeworkListRequest_17Item_Homeworks
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"rID",
                                                       @"toolid":@"toolID",
                                                       @"stageid":@"stageID",
                                                       @"toolid":@"toolID",
                                                       @"description":@"desc",
                                                       @"userid":@"userID",
                                                       @"createtime":@"createTime",
                                                       @"templateid":@"templateID",
                                                       @"fhomeworkid":@"homeworkID",
                                                       @"homeworktitle":@"homeworkTitle",
                                                       @"finishnum":@"finishNum",
                                                       @"themeid":@"themeID",
                                                       @"homeworktitle":@"homeworkTitle",
                                                       @"projectid":@"projectID",
                                                       @"subprojectid":@"subProjectID",
                                                       @"totalnum":@"totalNum"}];
}
@end

@implementation HomeworkListRequest_17Item_Scheme

@end

@implementation HomeworkListRequest_17Item

@end

@implementation HomeworkListRequest_17
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"projectid":@"projectID",
                                                       @"stageid":@"stageID",
                                                       @"toolid":@"toolID"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/homework/list"];
        self.projectID = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    }
    return self;
}
@end

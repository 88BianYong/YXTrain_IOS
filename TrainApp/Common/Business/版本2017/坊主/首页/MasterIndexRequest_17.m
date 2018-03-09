//
//  MasterIndexRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterIndexRequest_17.h"
@implementation MasterIndexRequestItem_Body_Modules_Extend
@end
@implementation MasterIndexRequestItem_Body_MyExamine_Types_Detail
- (NSString<Optional> *)typecode {
    return [self formatTypeCode:_typecode];
}
- (NSString *)formatTypeCode:(NSString *)code {
    if ([code isEqualToString:@"CXL"]) {
        return @"参训率";
    }else if ([code isEqualToString:@"HGL"]) {
        return @"合格率";
    }else if ([code isEqualToString:@"XXL"]) {
        return @"学习率";
    }else if ([code isEqualToString:@"BESTL"]) {
        return @"优秀率";
    }else if ([code isEqualToString:@"XY_PER_SCORE"]) {
        return @"学员平均分";
    }else if ([code isEqualToString:@"PUBLISH_BRIEF"]) {
        return @"发布简报";
    }else if ([code isEqualToString:@"PUBLISH_ACTIVE"]) {
        return @"研修活动";
    }else if ([code isEqualToString:@"RECOMMEND_HOMEWORK"]) {
        return @"作业推荐";
    }else if ([code isEqualToString:@"TIME_COURSE"]) {
        return @"看课";
    }else if ([code isEqualToString:@"ASSESS_HOMEWORK"]) {
        return @"点评作业";
    }else if ([code isEqualToString:@"REPLY_WENDA"]) {
        return @"回答问题";
    }else if ([code isEqualToString:@"UPLOAD_RES"]) {
        return @"资源建设";
    }else if ([code isEqualToString:@"OFFLINE_SCORE"]) {
        return @"线下研修";
    }else if ([code isEqualToString:@"RECOMMEND_HOMEWORK_RESOURCE_KIT"]) {
        return @"作品集推荐";
    }else if ([code isEqualToString:@"COMMENT_HOMEWORK_RESOURCE_KIT"]) {
        return @"作品集点评";
    }else if ([code isEqualToString:@"ASSESS_SCHEME"]) {
        return @"成绩评定";
    }else if ([code isEqualToString:@"SELF_RECOMMEND_HOMEWORK_COMMENT_KIT"]) {
        return @"自荐作业点评率";
    }else if ([code isEqualToString:@"SUMMARY_COMMENT_KIT"]) {
        return @"总结点评率";
    }else if ([code isEqualToString:@"QUIZ"]) {
        return @"在线考试";
    }else if ([code isEqualToString:@"GL_HOMEWORK"]) {
        return @"小组作业";
    }else if ([code isEqualToString:@"GL_SCORE"]) {
        return @"坊主评分";
    }else if ([code isEqualToString:@"ADMIN_SCORE"]) {
        return @"成绩评定";
    }else if ([code isEqualToString:@"OFFLINE_ACTIVE"]) {
        return @"线下活动";
    }else if ([code isEqualToString:@"PRODUCE_RESOURCE"]) {
        return @"生成资源";
    }else if ([code isEqualToString:@"PUBLISH_LOCAL_COURSE"]) {
        return @"本地课程";
    }else if ([code isEqualToString:@"PUBLISH_NOTICE"]) {
        return @"发布通知";
    }else {
        return code;
    }
}
@end

@implementation MasterIndexRequestItem_Body_MyExamine_Types
@end

@implementation MasterIndexRequestItem_Body_MyExamine
@end

@implementation MasterIndexRequestItem_Body_Modules

@end
@implementation MasterIndexRequestItem_Body_CountBars
@end

@implementation MasterIndexRequestItem_Body
//- (void)setModules:(NSMutableArray<MasterIndexRequestItem_Body_Modules,Optional> *)modules {
//        NSMutableArray<MasterIndexRequestItem_Body_Modules,Optional> *mutableArray = [[NSMutableArray<MasterIndexRequestItem_Body_Modules,Optional> alloc] init];
//    [modules enumerateObjectsUsingBlock:^(MasterIndexRequestItem_Body_Modules *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.iconStatus.integerValue != 0) {
//            [mutableArray addObject:obj];
//        }
//    }];
//    _modules = mutableArray;
//}

@end

@implementation MasterIndexRequestItem

@end
@implementation MasterIndexRequest_17
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"projectID":@"projectId"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/index"];
    }
    return self;
}
@end

//
//  ExamineDetailRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "ExamineDetailRequest_17.h"
@implementation ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"finishNum":@"finishnum",
                                                       @"isNeedMark":@"isExistsNext",
                                                       @"toolID":@"toolid",
                                                       @"totalNum":@"totalnum",
                                                       @"totalScore":@"totalscore",
                                                       @"userScore":@"userscore",
                                                       @"passScore":@"passscore",
                                                       @"orderNo":@"orderno",
                                                       @"passFinishScore":@"passfinishscore",
                                                       @"passTotalScore":@"passtotalscore"}];
}
- (NSString<Optional> *)name {
    if (self.toolID.integerValue == 222) {
        return @"任务说明";
    }
    return _name;
}
@end
@implementation ExamineDetailRequest_17Item_Examine_Process
- (NSString<Optional> *)isMockFold {
    if (_isMockFold == nil) {
        if (self.procesID.integerValue == 304){//在线测评不支持
            return @"0";
        }
        if (self.procesID.integerValue == 1003){//附加分不支持
            return @"0";
        }
        if (self.stageID.integerValue == 0) {//非阶段下全部展开
            return @"1";
        }
        if (self.isFinish.boolValue) {
            return @"0";
        }
        if (![self compareDateDate:self.startDate]) {
            return @"1";
        }else {
            return @"0";
        }
    }
    return _isMockFold;
}
- (BOOL)compareDateDate:(NSString*)dateString {
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateformater dateFromString:dateString];
    NSComparisonResult result = [[NSDate date] compare:date];
    if (result == NSOrderedAscending) {
        return YES;
    }else {
        return NO;
    }
}
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"endDate":@"enddate",
                                                                  @"ifQuestion":@"ifquestion",
                                                                  @"isFinish":@"isfinish",
                                                                  @"isPass":@"totalnum",
                                                                  @"passsCore":@"passscore",
                                                                  @"stageID":@"stageId",
                                                                  @"totalScore":@"totalscore",
                                                                  @"userScore":@"userscore",
                                                                  @"passTotalScore":@"passtotalscore",
                                                                  @"procesID":@"id",
                                                                  @"startDate":@"startdate"
                                                                  }];
}
@end

@implementation ExamineDetailRequest_17Item_MockOther
@end

@implementation ExamineDetailRequest_17Item_Stages_Tools
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"toolID":@"toolid"}];
}
- (NSString<Optional> *)name {
    if (self.toolID.integerValue == 222) {//TBD:8-25 测试要求
        return @"任务说明";
    }
    return _name;
}
@end
@implementation ExamineDetailRequest_17Item_User
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"userID":@"userId"}];
}
@end
@implementation ExamineDetailRequest_17Item_Theme
@end
@implementation ExamineDetailRequest_17Item_Stages
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"stageID":@"stageid",
                                                                  @"startTime":@"starttime"}];
}
- (NSArray<ExamineDetailRequest_17Item_Stages_Tools,Optional> *)tools {
    [_tools enumerateObjectsUsingBlock:^(ExamineDetailRequest_17Item_Stages_Tools *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            ExamineDetailRequest_17Item_Stages_Tools *tool = self->_tools[idx - 1];
            if (tool.status.integerValue == 1 && obj.status.integerValue <= 0) {
                obj.status = @"-2";
                *stop = YES;
            }
        }
    }];
    return _tools;
}
- (NSString<Optional> *)isMockFold {
    if (_isMockFold == nil) {
        return @"1";
        if (self.isFinish.boolValue) {
            return @"0";
        }
        if (self.status.integerValue == 1) {
            return @"1";
        }else {
            return @"0";
        }
    }
    return _isMockFold;
}
@end
@implementation ExamineDetailRequest_17Item_Other
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"isWorks":@"ifWorks"}];
}
@end
@implementation ExamineDetailRequest_17Item_Layer
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"layerID":@"layerid"}];
}
@end
@implementation ExamineDetailRequest_17Item_Expert
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"expertProjectID":@"expertProjectId",
                                                                  @"channelID":@"channelid"}];
}
@end
@implementation ExamineDetailRequest_17Item_Examine
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"totalScore":@"totalscore"}];
}
@end
@implementation ExamineDetailRequest_17Item_Banner
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"bannerID":@"id"}];
}
@end
@implementation ExamineDetailRequest_17Item
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"projectID":@"projectid"}];
}
- (NSMutableArray<ExamineDetailRequest_17Item_MockOther,Optional> *)mockOthers {
    if (_mockOthers == nil) {
        NSMutableArray<ExamineDetailRequest_17Item_MockOther> *mutableArray = [[NSMutableArray<ExamineDetailRequest_17Item_MockOther> alloc] initWithCapacity:3];
        if (self.other.isShowCourseMarket.boolValue) {
            ExamineDetailRequest_17Item_MockOther *other = [[ExamineDetailRequest_17Item_MockOther alloc] init];
            other.otherType = @"1";
            other.otherName = @"选课中心";
            [mutableArray addObject:other];
        }
        if (self.other.isShowExam.boolValue) {
            ExamineDetailRequest_17Item_MockOther *other = [[ExamineDetailRequest_17Item_MockOther alloc] init];
            other.otherType = @"2";
            other.otherName = @"在线考试";
            [mutableArray addObject:other];
        }
        
        if (self.expert.isShowExpertChannel.boolValue) {
            ExamineDetailRequest_17Item_MockOther *other = [[ExamineDetailRequest_17Item_MockOther alloc] init];
            other.otherType = @"3";
            other.otherName = @"专家答疑";
            other.otherID = self.expert.channelID;
            [mutableArray addObject:other];
        }
        
        if (self.other.isShowOfflineActive.boolValue) {
            ExamineDetailRequest_17Item_MockOther *other = [[ExamineDetailRequest_17Item_MockOther alloc] init];
            other.otherType = @"4";
            other.otherName = @"线下活动";
            [mutableArray addObject:other];
        }
        
        if(self.other.isWorks.boolValue) {
            ExamineDetailRequest_17Item_MockOther *other = [[ExamineDetailRequest_17Item_MockOther alloc] init];
            other.otherType = @"5";
            other.otherName = @"作品集";
            [mutableArray addObject:other];
        }
        
        if(self.other.isShowSelfHomework.boolValue){
            ExamineDetailRequest_17Item_MockOther *other = [[ExamineDetailRequest_17Item_MockOther alloc] init];
            other.otherType = @"6";
            other.otherName = @"自荐作业";
            [mutableArray addObject:other];
        }
        _mockOthers = mutableArray;
    }
    return _mockOthers;
}
@end
@implementation ExamineDetailRequest_17
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"projectID":@"projectid"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/examine/detail"];
    }
    return self;
}
@end

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
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"finishnum":@"finishNum",
                                                       @"isExistsNext":@"isNeedMark",
                                                       @"toolid":@"toolID",
                                                       @"totalnum":@"totalNum",
                                                       @"totalscore":@"totalScore",
                                                       @"userscore":@"userScore"}];
}
@end
@implementation ExamineDetailRequest_17Item_Examine_Process
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"enddate":@"endDate",
                                                       @"id":@"processID",
                                                       @"ifquestion":@"ifQuestion",
                                                       @"isfinish":@"isFinish",
                                                       @"totalnum":@"isPass",
                                                       @"passscore":@"passsCore",
                                                       @"stageId":@"stageID",
                                                       @"totalscore":@"totalScore",
                                                       @"userscore":@"userScore"}];
}
@end

@implementation ExamineDetailRequest_17Item_MockOther
@end

@implementation ExamineDetailRequest_17Item_Stages_Tools
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"toolid":@"toolID"}];
}
@end
@implementation ExamineDetailRequest_17Item_User
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"userId":@"userID"}];
}
@end
@implementation ExamineDetailRequest_17Item_Theme
@end
@implementation ExamineDetailRequest_17Item_Stages
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"stageid":@"stageID",
                                                       @"starttime":@"startTime"}];
}
- (NSString<Optional> *)isMockFold {
    if (_isMockFold == nil) {
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
@end
@implementation ExamineDetailRequest_17Item_Layer
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"layerid":@"layerID"}];
}
@end
@implementation ExamineDetailRequest_17Item_Expert
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"expertProjectId":@"expertProjectID",
                                                       @"channelid":@"channelID"}];
}
@end
@implementation ExamineDetailRequest_17Item_Examine
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"totalscore":@"totalScore"}];
}
@end
@implementation ExamineDetailRequest_17Item_Banner
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"bannerID"}];
}
@end
@implementation ExamineDetailRequest_17Item
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"projectid":@"projectID"}];
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
        if (self.other.isShowOfflineActive.boolValue) {
            ExamineDetailRequest_17Item_MockOther *other = [[ExamineDetailRequest_17Item_MockOther alloc] init];
            other.otherType = @"2";
            other.otherName = @"在线考试";
            [mutableArray addObject:other];
        }
        if (self.expert.isShowExpertChannel.boolValue) {
            ExamineDetailRequest_17Item_MockOther *other = [[ExamineDetailRequest_17Item_MockOther alloc] init];
            other.otherType = @"3";
            other.otherName = @"专家频道";
            other.otherID = self.expert.channelID;
            [mutableArray addObject:other];
        }
        _mockOthers = mutableArray;
    }
    return _mockOthers;
}
@end
@implementation ExamineDetailRequest_17
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"projectId":@"projectID"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/examine/detail"];
    }
    return self;
}
@end

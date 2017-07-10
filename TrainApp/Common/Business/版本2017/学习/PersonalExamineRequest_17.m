//
//  PersonalExamineRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PersonalExamineRequest_17.h"

@implementation PersonalExamineRequest_17Item_Banner
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"bannerID"}];
}
@end
@implementation PersonalExamineRequest_17Item_Other

@end
@implementation PersonalExamineRequest_17Item_Expert
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"expertProjectId":@"expertProjectID"}];
}
@end

@implementation PersonalExamineRequest_17Item_Examine_Process_ToolExamineVoList
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"finishnum":@"finishNum",
                                                       @"isneedmark":@"isNeedMark",
                                                       @"tooldesc":@"toolDesc",
                                                       @"toolid":@"toolID",
                                                       @"totalnum":@"totalNum",
                                                       @"totalscore":@"totalScore",
                                                       @"userscore":@"userScore"}];
}
@end

@implementation PersonalExamineRequest_17Item_Examine_Process
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"enddate":@"endDate",
                                                       @"id":@"processID",
                                                       @"ifquestion":@"ifQuestion",
                                                       @"isfinish":@"isFinish",
                                                       @"ispass":@"isPass",
                                                       @"passscore":@"passsCore",
                                                       @"stageId":@"stageID",
                                                       @"totalscore":@"totalScore",
                                                       @"userscore":@"userScore"}];
}
@end
@implementation PersonalExamineRequest_17Item_Examine

@end
@implementation PersonalExamineRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/2017/person/score"];
    }
    return self;
}
@end

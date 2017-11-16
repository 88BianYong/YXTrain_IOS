//
//  MasterLearningInfoRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterLearningInfoRequest_17.h"
@implementation MasterLearningInfoRequestItem_Body_Bars
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"barId":@"barid"}];
}
@end
@implementation MasterLearningInfoRequestItem_Body_Count
@end
@implementation MasterLearningInfoRequestItem_Body_Schemes
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"typeCode":@"typecode"}];
}
@end
@implementation MasterLearningInfoRequestItem_Body_XueQing_LearningInfoList
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"userId":@"userid",
                                                                  @"realName":@"realname",
                                                                  @"leadScore":@"leadscore",
                                                                  @"studyName":@"studyname",
                                                                  @"totalScore":@"totalscore",
                                                                  @"expandScore":@"expandscore"
                                                                  }];
}
@end
@implementation MasterLearningInfoRequestItem_Body_XueQing
@end

@implementation MasterLearningInfoRequestItem_Body
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"detail":@"count",
                                                                  @"xueQing":@"xueqing"
                                                                  }];
}
@end
@implementation MasterLearningInfoRequestItem
@end
@implementation MasterLearningInfoRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/learningInfoIndex"];
    }
    return self;
}
@end

//
//  CourseGetQuizesRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseGetQuizesRequest_17.h"
@implementation CourseGetQuizesRequest_17Item_Result_Questions_Questions_AnswerJson
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"isChoice":@"isChoose"}];
}
@end
@implementation CourseGetQuizesRequest_17Item_Result_Questions_Question
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"qId":@"qID"}];
}
@end
@implementation CourseGetQuizesRequest_17Item_Result_Questions

@end
@implementation CourseGetQuizesRequest_17Item_Result
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"lasttime":@"lastTime",
                                                       @"wrongnum":@"wrongNum",
                                                       @"correctnum":@"correctNum"}];
}
@end
@implementation CourseGetQuizesRequest_17Item
@end
@implementation CourseGetQuizesRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"quiz/getquizes"];
    }
    return self;
}
@end

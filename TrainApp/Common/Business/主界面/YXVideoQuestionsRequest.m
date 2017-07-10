//
//  YXVideoQuestionsRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXVideoQuestionsRequest.h"
@implementation YXVideoQuestionsRequestItem_Result_Questions_Question_AnswerJson
@end
@implementation YXVideoQuestionsRequestItem_Result_Questions_Question
@end
@implementation YXVideoQuestionsRequestItem_Result_Questions
@end

@implementation YXVideoQuestionsRequestItem_Result
@end
@implementation YXVideoQuestionsRequestItem
@end

@implementation YXVideoQuestionsRequest
+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"qID",
                                                       @"pid":@"pID",
                                                       @"cid":@"cID"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"quiz/getquiz"];
    }
    return self;
}
@end

//
//  YXSubmitAnswerRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXSubmitAnswerRequest.h"
@implementation YXSubmitAnswerRequestItem

@end
@implementation YXSubmitAnswerRequest
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"qID":@"qid",
                                                                  @"pID":@"pid",
                                                                  @"cID":@"cid"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"quiz/submitUserQuiz"];
    }
    return self;
}
@end

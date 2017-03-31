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
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"qid":@"qID",
                                                       @"pid":@"pID",
                                                       @"cid":@"cID"}];
}
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"quiz/submitUserQuiz"];
    }
    return self;
}
@end

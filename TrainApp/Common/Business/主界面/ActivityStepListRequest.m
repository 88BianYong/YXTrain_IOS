//
//  ActivityStepListRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/10.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityStepListRequest.h"
@implementation ActivityStepListRequestItem_Body_Steps_Tools
@end

@implementation ActivityStepListRequestItem_Body_Steps
@end

@implementation ActivityStepListRequestItem_Body
@end

@implementation ActivityStepListRequestItem
@end

@implementation ActivityStepListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"club/active/steps"];
    }
    return self;
}
@end

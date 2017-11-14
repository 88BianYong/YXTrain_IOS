//
//  ActivityStepListRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/10.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityStepListRequest.h"
@implementation ActivityStepListRequestItem_Body_Active_Steps_Tools

@end
@implementation ActivityStepListRequestItem_Body_Active_Steps
@end

@implementation ActivityStepListRequestItem_body_Active
@end

@implementation ActivityStepListRequestItem_Body
@end

@implementation ActivityStepListRequestItem
@end

@implementation ActivityStepListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"club/active"];
    }
    return self;
}
@end

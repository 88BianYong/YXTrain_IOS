//
//  MasterManageBrief_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManageBriefRequest_17.h"
@implementation MasterManageBriefItem_Body
@end

@implementation MasterManageBriefItem
@end
@implementation MasterManageBriefRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/manageBrief"];
    }
    return self;
}
@end

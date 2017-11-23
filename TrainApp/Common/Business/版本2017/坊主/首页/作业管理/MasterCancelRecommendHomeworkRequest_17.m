//
//  MasterCancelRecommendHomeworkRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterCancelRecommendHomeworkRequest_17.h"
@implementation MasterCancelRecommendHomeworkItem_Body
@end

@implementation MasterCancelRecommendHomeworkItem
@end
@implementation MasterCancelRecommendHomeworkRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/cancelRecommendHomework"];
    }
    return self;
}
@end

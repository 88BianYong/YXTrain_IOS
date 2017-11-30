//
//  MasterHomeworkSetScoreRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkSetScoreRequest_17.h"
@implementation MasterHomeworkSetScoreItem_Body

@end
@implementation MasterHomeworkSetScoreItem
@end
@implementation MasterHomeworkSetScoreRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/scoreHomework"];
    }
    return self;
}
@end

//
//  MasterScoreHomeworkRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterScoreHomeworkRequest_17.h"
@implementation MasterScoreHomeworkItem_Body

@end
@implementation MasterScoreHomeworkItem 
@end
@implementation MasterScoreHomeworkRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/scoreHomework"];
    }
    return self;
}
@end

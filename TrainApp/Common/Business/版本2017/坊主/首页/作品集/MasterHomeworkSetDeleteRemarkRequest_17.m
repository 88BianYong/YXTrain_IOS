//
//  MasterHomeworkSetDeleteRemarkRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkSetDeleteRemarkRequest_17.h"

@implementation MasterHomeworkSetDeleteRemarkRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/homeworkSet/delRemark"];
    }
    return self;
}
@end

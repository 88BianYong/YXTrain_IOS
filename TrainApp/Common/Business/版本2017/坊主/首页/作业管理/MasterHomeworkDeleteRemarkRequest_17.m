//
//  MasterHomeworkDeleteRemarkRequest_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterHomeworkDeleteRemarkRequest_17.h"

@implementation MasterHomeworkDeleteRemarkRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/homework/delRemark"];
    }
    return self;
}
@end

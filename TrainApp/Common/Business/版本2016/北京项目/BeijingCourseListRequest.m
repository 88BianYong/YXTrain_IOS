//
//  BeijingCourseListRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "BeijingCourseListRequest.h"

@implementation BeijingCourseListRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead =  [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/bj/courselist"];
    }
    return self;
}
@end

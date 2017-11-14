//
//  YXWriteHomeworkRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/8/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXWriteHomeworkRequest.h"
@implementation YXWriteHomeworkRequestItem_Body_Upload
@end

@implementation YXWriteHomeworkRequestItem_Body
@end

@implementation YXWriteHomeworkRequestItem
@end

@implementation YXWriteHomeworkRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"guopei/user/mobile/mWriteHomework.tc"];
    }
    return self;
}
@end

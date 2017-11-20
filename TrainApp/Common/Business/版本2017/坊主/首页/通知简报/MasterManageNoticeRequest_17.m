//
//  MasterManageNotice_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManageNoticeRequest_17.h"
@implementation MasterManageNoticeItem_Body
@end


@implementation MasterManageNoticeItem
@end
@implementation MasterManageNoticeRequest_17
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/manageNotice"];
    }
    return self;
}

@end

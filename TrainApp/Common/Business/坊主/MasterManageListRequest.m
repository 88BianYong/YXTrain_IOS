//
//  MasterManageListRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 17/2/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MasterManageListRequest.h"
@implementation MasterManageListRequestItem_Body_Group
@end
@implementation MasterManageListRequestItem_Body
@end
@implementation MasterManageListRequestItem
@end

@implementation MasterManageListRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/master/getStudioList"];
    }
    return self;
}
@end

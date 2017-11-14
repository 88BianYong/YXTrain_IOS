//
//  NoticeAndBriefDetailRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeAndBriefDetailRequest.h"
@implementation NoticeAndBriefDetailRequestItem_Body_Affix
@end
@implementation NoticeAndBriefDetailRequestItem_Body
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"barID":@"barid",
                                                                  @"nbID":@"id",
                                                                  @"userID":@"userid"}];
}
@end
@implementation NoticeAndBriefDetailRequestItem

@end
@implementation NoticeAndBriefDetailRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"peixun/nbs/nbdetail"];
    }
    return self;
}
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"nbID":@"id",
                                                       }];
}
@end

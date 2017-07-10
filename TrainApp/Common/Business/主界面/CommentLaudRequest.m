//
//  CommentLaudRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "CommentLaudRequest.h"

@implementation CommentLaudRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"club/reply/laud"];
    }
    return self;
}
@end

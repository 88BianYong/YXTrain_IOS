//
//  CommentReplyRequest.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "CommentReplyRequest.h"
@implementation CommentLaudRequestItem_Body
@end

@implementation CommentReplyRequestItem

@end

@implementation CommentReplyRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[LSTSharedInstance sharedInstance].configManager.server stringByAppendingString:@"club/reply"];
    }
    return self;
}
@end

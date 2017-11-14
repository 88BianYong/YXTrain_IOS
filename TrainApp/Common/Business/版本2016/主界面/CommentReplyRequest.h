//
//  CommentReplyRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/23.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"
#import "ActivityFirstCommentRequest.h"
@interface CommentLaudRequestItem_Body :JSONModel
@property (nonatomic, strong) ActivityFirstCommentRequestItem_Body_Replies<Optional> *reply;
@end

@interface CommentReplyRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) CommentLaudRequestItem_Body<Optional> *body;
@end

@interface CommentReplyRequest : YXPostRequest
@property (nonatomic, copy) NSString *parentid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *toolid;
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *tooltype;
@property (nonatomic, copy) NSString *topicid;
@property (nonatomic, copy) NSString *stageId;
@end

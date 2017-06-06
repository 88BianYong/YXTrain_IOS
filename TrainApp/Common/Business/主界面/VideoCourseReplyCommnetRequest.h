//
//  VideoCourseReplyCommnetRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"
#import "VideoCourseCommentsRequest.h"
@interface VideoCourseReplyCommnetRequestItem_Body : JSONModel
@property (nonatomic, strong) VideoCourseCommentsRequestItem_Body_Comments<Optional> *comment;
@end

@interface VideoCourseReplyCommnetRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) VideoCourseReplyCommnetRequestItem_Body<Optional> *body;
@end

@interface VideoCourseReplyCommnetRequest : YXPostRequest
@property (nonatomic, copy) NSString<Optional> *commentID;
@property (nonatomic, copy) NSString<Optional> *courseID;
@property (nonatomic, copy) NSString<Optional> *content;
@end

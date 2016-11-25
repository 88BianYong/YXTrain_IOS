//
//  ActivityFirstCommentRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/11.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol ActivityFirstCommentRequestItem_Body_Replies <NSObject>
@end
@interface ActivityFirstCommentRequestItem_Body_Replies : JSONModel
@property (nonatomic, strong) NSString<Optional> *topicid;
@property (nonatomic, strong) NSString<Optional> *pic;
@property (nonatomic, strong) NSString<Optional> *up;
@property (nonatomic, strong) NSString<Optional> *replyID;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) NSString<Optional> *zJFlag;
@property (nonatomic, strong) NSString<Optional> *isDel;
@property (nonatomic, strong) NSString<Optional> *time;
@property (nonatomic, strong) NSString<Optional> *floor;
@property (nonatomic, strong) NSString<Optional> *userId;
@property (nonatomic, strong) NSString<Optional> *isRanked;
@property (nonatomic, strong) NSString<Optional> *userName;
@property (nonatomic, strong) NSString<Optional> *allowDel;
@property (nonatomic, strong) NSString<Optional> *childNum;
@property (nonatomic, strong) NSString<Optional> *isFloor;
@property (nonatomic, strong) NSString<Optional> *headUrl;
@property (nonatomic, strong) NSMutableArray<ActivityFirstCommentRequestItem_Body_Replies,Optional> *replies;
@end
@interface ActivityFirstCommentRequestItem_Body : JSONModel
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *page;
@property (nonatomic, strong) NSString<Optional> *totalPage;
@property (nonatomic, strong) NSString<Optional> *totalNum;
@property (nonatomic, strong) NSMutableArray<ActivityFirstCommentRequestItem_Body_Replies,Optional> *replies;
@end

@interface ActivityFirstCommentRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ActivityFirstCommentRequestItem_Body<Optional> *body;
@end

@interface ActivityFirstCommentRequest : YXGetRequest
@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *toolid;
@property (nonatomic, strong) NSString *parentid;
@property (nonatomic, strong) NSString *w;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *pageSize;
@end

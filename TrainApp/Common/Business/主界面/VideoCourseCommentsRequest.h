//
//  VideoCourseCommentsRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/26.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol  VideoCourseCommentsRequestItem_Body_Comments
@end
@interface VideoCourseCommentsRequestItem_Body_Comments : JSONModel
@property (nonatomic, copy) NSString<Optional> *commentID;
@property (nonatomic, copy) NSString<Optional> *uid;
@property (nonatomic, copy) NSString<Optional> *pp;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *content;//内容
@property (nonatomic, copy) NSString<Optional> *childNum;//回复评论个数
@property (nonatomic, copy) NSString<Optional> *lv;
@property (nonatomic, copy) NSString<Optional> *laudNumber; //点赞个数
@property (nonatomic, copy) NSString<Optional> *isLaund;//是否点赞
@property (nonatomic, copy) NSString<Optional> *dnm;
@property (nonatomic, copy) NSString<Optional> *timeDesc;
@property (nonatomic, copy) NSString<Optional> *parentId;//上级评论id
@property (nonatomic, copy) NSString<Optional> *ap;
@property (nonatomic, copy) NSString<Optional> *time;
@end

@interface VideoCourseCommentsRequestItem_Body : JSONModel
@property (nonatomic, strong) NSMutableArray<VideoCourseCommentsRequestItem_Body_Comments,Optional> *comments;
@end

@interface VideoCourseCommentsRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) VideoCourseCommentsRequestItem_Body *body;
@end

@interface VideoCourseCommentsRequest : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *commentID;
@property (nonatomic, copy) NSString<Optional> *courseID;
@property (nonatomic, copy) NSString<Optional> *offset;
@property (nonatomic, copy) NSString<Optional> *parentID;
@end

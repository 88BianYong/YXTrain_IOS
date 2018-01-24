//
//  MasterCountActiveRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface  MasterCountActiveItem_Body_CountTool_Total : JSONModel
@property (nonatomic, copy) NSString<Optional> *joinUserNum;
@property (nonatomic, copy) NSString<Optional> *discussNum;
@property (nonatomic, copy) NSString<Optional> *likeNum;
@property (nonatomic, copy) NSString<Optional> *voteNum;
@property (nonatomic, copy) NSString<Optional> *uploadNum;
@property (nonatomic, copy) NSString<Optional> *questionNum;
@end

@protocol MasterCountActiveItem_Body_CountTool @end
@interface MasterCountActiveItem_Body_CountTool : JSONModel
@property (nonatomic, copy) NSString<Optional> *toolId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *toolType;/// 1"讨论":"discuss"  2"投票":"vote"   3 "资源分享":"resources"     4"问卷":"wenjuan"   5"视频" ："video"
@property (nonatomic, strong) MasterCountActiveItem_Body_CountTool_Total<Optional> *total;
@end

@protocol MasterCountActiveItem_Body_CountMemeber_TotalArray @end
@interface MasterCountActiveItem_Body_CountMemeber_TotalArray : JSONModel
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *toolType;
@property (nonatomic, copy) NSString<Optional> *toolId;
@property (nonatomic, copy) NSString<Optional> *discussNum;
@property (nonatomic, copy) NSString<Optional> *likeNum;
@property (nonatomic, copy) NSString<Optional> *voteNum;
@property (nonatomic, copy) NSString<Optional> *uploadNum;
@property (nonatomic, copy) NSString<Optional> *questionNum;
@end

@protocol MasterCountActiveItem_Body_CountMemeber @end
@interface MasterCountActiveItem_Body_CountMemeber : JSONModel
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *userId;
@property (nonatomic, strong) NSArray<MasterCountActiveItem_Body_CountMemeber_TotalArray,Optional> *totalArray;
@end

@interface MasterCountActiveItem_Body_Active : JSONModel
@property (nonatomic, copy) NSString<Optional> *activeId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *joinUserCount;
@property (nonatomic, copy) NSString<Optional> *startTime;
@property (nonatomic, copy) NSString<Optional> *endTime;
@property (nonatomic, copy) NSString<Optional> *createUserName;
@property (nonatomic, copy) NSString<Optional> *studyName;
@property (nonatomic, copy) NSString<Optional> *segmentName;
@property (nonatomic, copy) NSString<Optional> *isJoin;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString<Optional> *stageId;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *source;
@property (nonatomic, copy) NSString<Optional> *pic;
@property (nonatomic, copy) NSString<Optional> *restrictTime;
@end

@interface MasterCountActiveItem_Body : JSONModel
@property (nonatomic, strong) MasterCountActiveItem_Body_Active<Optional> *active;
@property (nonatomic, strong) NSArray<MasterCountActiveItem_Body_CountMemeber,Optional> *countMemeber;
@property (nonatomic, strong) NSArray<MasterCountActiveItem_Body_CountTool, Optional> *countTool;
@property (nonatomic, copy) NSString<Optional> *hasNextPage;

@end

@interface MasterCountActiveItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterCountActiveItem_Body<Optional> *body;
@end

@interface MasterCountActiveRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *aId;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *pageSize;
@end

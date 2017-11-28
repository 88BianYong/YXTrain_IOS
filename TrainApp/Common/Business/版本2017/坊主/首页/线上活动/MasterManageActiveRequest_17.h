//
//  MasterManageActiveRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "MasterManagerSchemeItem.h"
@protocol MasterManageActiveItem_Body_Active @end
@interface MasterManageActiveItem_Body_Active : JSONModel
@property (nonatomic, copy) NSString<Optional> *activeId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *joinUserCount;

@property (nonatomic, copy) NSString<Optional> *startTime;
@property (nonatomic, copy) NSString<Optional> *endTime;
@property (nonatomic, copy) NSString<Optional> *createUserName;
@property (nonatomic, copy) NSString<Optional> *createUserId;
@property (nonatomic, copy) NSString<Optional> *studyName;
@property (nonatomic, copy) NSString<Optional> *segmentName;
@property (nonatomic, copy) NSString<Optional> *isJoin;
@property (nonatomic, copy) NSString<Optional> *stageid;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *source;
@property (nonatomic, copy) NSString<Optional> *pic;
@property (nonatomic, copy) NSString<Optional> *restrictTime;

@end

@protocol MasterManageActiveItem_Body_Studie @end
@interface MasterManageActiveItem_Body_Studie : JSONModel
@property (nonatomic, copy) NSString<Optional> *studieId;
@property (nonatomic, copy) NSString<Optional> *name;

@end

@protocol MasterManageActiveItem_Body_Segment @end
@interface MasterManageActiveItem_Body_Segment : JSONModel
@property (nonatomic, copy) NSString<Optional> *segmentId;
@property (nonatomic, copy) NSString<Optional> *name;
@end

@protocol MasterManageActiveItem_Body_Stage @end
@interface MasterManageActiveItem_Body_Stage : JSONModel
@property (nonatomic, copy) NSString<Optional> *stageId;
@property (nonatomic, copy) NSString<Optional> *name;
@end

@protocol MasterManageActiveItem_Body_Bar @end
@interface MasterManageActiveItem_Body_Bar: JSONModel
@property (nonatomic, copy) NSString<Optional> *name;//
@property (nonatomic, copy) NSString<Optional> *barId;//
@end

@interface MasterManageActiveItem_Body : JSONModel
@property (nonatomic, strong) MasterManagerSchemeItem<Optional> *scheme;
@property (nonatomic, strong) NSArray<MasterManageActiveItem_Body_Stage, Optional> *stages;
@property (nonatomic, strong) NSArray<MasterManageActiveItem_Body_Segment, Optional> *segments;
@property (nonatomic, strong) NSArray<MasterManageActiveItem_Body_Studie, Optional> *studies;
@property (nonatomic, strong) NSArray<MasterManageActiveItem_Body_Bar, Optional> *bars;
@property (nonatomic, strong) NSArray<MasterManageActiveItem_Body_Active, Optional> *actives;
@property (nonatomic, copy) NSString<Optional> *total;
@end

@interface MasterManageActiveItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterManageActiveItem_Body<Optional> *body;
@end

@interface MasterManageActiveRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *barId;
@property (nonatomic, copy) NSString<Optional> *study;
@property (nonatomic, copy) NSString<Optional> *stageId;
@property (nonatomic, copy) NSString<Optional> *segment;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *pageSize;
@end

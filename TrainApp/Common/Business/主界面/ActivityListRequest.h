//
//  ActivityListRequest.h
//  TrainApp
//
//  Created by ZLL on 2016/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol ActivityListRequestItem_Body_Activity_Steps_Tools <NSObject>
@end
@protocol ActivityListRequestItem_Body_Activity_Steps <NSObject>

@end

@interface ActivityListRequestItem_Body_Activity_Steps_Tools : JSONModel
@property (nonatomic, copy) NSString<Optional> *toolid;
@property (nonatomic, copy) NSString<Optional> *aid;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString<Optional> *toolType;
@end

@interface ActivityListRequestItem_Body_Activity_Steps : JSONModel
@property (nonatomic, copy) NSString<Optional> *stepid;
@property (nonatomic, copy) NSString<Optional> *aid;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, strong) NSArray<ActivityListRequestItem_Body_Activity_Steps_Tools,Optional> *tools;
@end


@protocol ActivityListRequestItem_body_activity <NSObject>
@end
@interface ActivityListRequestItem_body_activity : JSONModel
@property (nonatomic, copy) NSString<Optional> *aid;
@property (nonatomic, copy) NSString<Optional> *pic;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *startTime;
@property (nonatomic, copy) NSString<Optional> *isJoin;
@property (nonatomic, copy) NSString<Optional> *createUsername;
@property (nonatomic, copy) NSString<Optional> *studyName;
@property (nonatomic, copy) NSString<Optional> *segmentName;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *source;//club或train->研修网;zgjiaoyan->教研网
@property (nonatomic, copy) NSString<Optional> *joinUserCount;
@property (nonatomic, strong) NSArray<ActivityListRequestItem_Body_Activity_Steps,Optional> *steps;
@end

@interface ActivityListRequestItem_body : JSONModel
@property (nonatomic, copy) NSString<Optional> *pageSize;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *totalPage;
@property (nonatomic, strong) NSArray<ActivityListRequestItem_body_activity,Optional> *actives;
@end

@interface ActivityListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ActivityListRequestItem_body<Optional> *body;
@end

@interface ActivityListRequest : YXGetRequest
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *segmentId;
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, copy) NSString *studyId;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *pagesize;
@end

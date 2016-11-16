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
@property (nonatomic, strong) NSString<Optional> *toolid;
@property (nonatomic, strong) NSString<Optional> *aid;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *toolType;
@end

@interface ActivityListRequestItem_Body_Activity_Steps : JSONModel
@property (nonatomic, strong) NSString<Optional> *stepid;
@property (nonatomic, strong) NSString<Optional> *aid;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSArray<ActivityListRequestItem_Body_Activity_Steps_Tools,Optional> *tools;
@end


@protocol ActivityListRequestItem_body_activity <NSObject>
@end
@interface ActivityListRequestItem_body_activity : JSONModel
@property (nonatomic, strong) NSString<Optional> *aid;
@property (nonatomic, strong) NSString<Optional> *pic;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *isJoin;
@property (nonatomic, strong) NSString<Optional> *createUsername;
@property (nonatomic, strong) NSString<Optional> *studyName;
@property (nonatomic, strong) NSString<Optional> *segmentName;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *status;
@property (nonatomic, strong) NSString<Optional> *source;//club或train->研修网;zgjiaoyan->教研网
@property (nonatomic, copy) NSString<Optional> *joinUserCount;
@property (nonatomic, strong) NSArray<ActivityListRequestItem_Body_Activity_Steps,Optional> *steps;
@end

@interface ActivityListRequestItem_body : JSONModel
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *page;
@property (nonatomic, strong) NSString<Optional> *totalPage;
@property (nonatomic, strong) NSArray<ActivityListRequestItem_body_activity,Optional> *actives;
@end

@interface ActivityListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ActivityListRequestItem_body<Optional> *body;
@end

@interface ActivityListRequest : YXGetRequest
@property (nonatomic, strong) NSString *projectId;
@property (nonatomic, strong) NSString *segmentId;
@property (nonatomic, strong) NSString *stageId;
@property (nonatomic, strong) NSString *studyId;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *pagesize;
@end

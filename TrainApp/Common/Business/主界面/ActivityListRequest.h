//
//  ActivityListRequest.h
//  TrainApp
//
//  Created by ZLL on 2016/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol ActivityListRequestItem_body_activity <NSObject>
@end
@interface ActivityListRequestItem_body_activity : JSONModel
@property (nonatomic, strong) NSString<Optional> *aid;
@property (nonatomic, strong) NSString<Optional> *pic;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *startTime;
@property (nonatomic, strong) NSString<Optional> *isJoin;
@property (nonatomic, strong) NSString<Optional> *source;
@end

@interface ActivityListRequestItem_body : JSONModel
@property (nonatomic, strong) NSString<Optional> *pageSize;
@property (nonatomic, strong) NSString<Optional> *page;
@property (nonatomic, strong) NSString<Optional> *totalPage;
@property (nonatomic, strong) NSArray<ActivityListRequestItem_body_activity,Optional> *actives;
@end

@interface ActivityListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ActivityListRequestItem_body<Optional> *body;
- (NSArray *)allActivities;
@end

@interface ActivityListRequest : YXGetRequest
@property (nonatomic, strong) NSString *projectId;
@property (nonatomic, strong) NSString *segmentId;
@property (nonatomic, strong) NSString *stageId;
@property (nonatomic, strong) NSString *studyId;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *pagesize;
@end

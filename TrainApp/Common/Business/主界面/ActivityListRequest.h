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
@property (nonatomic, strong) NSString<Optional> *createUsername;
@property (nonatomic, strong) NSString<Optional> *studyName;
@property (nonatomic, strong) NSString<Optional> *segmentName;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *status;
@end

@interface ActivityListRequestItem_body : JSONModel
@property (nonatomic, strong) NSString<Optional> *pageSize;//每页显示的数量
@property (nonatomic, strong) NSString<Optional> *page;//当前页
@property (nonatomic, strong) NSString<Optional> *totalPage;//总页数
@property (nonatomic, strong) NSArray<ActivityListRequestItem_body_activity,Optional> *actives;
@end

@interface ActivityListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ActivityListRequestItem_body<Optional> *body;
- (NSArray *)allActivities;
@end

@interface ActivityListRequest : YXGetRequest
@property (nonatomic, strong) NSString *projectId;
@property (nonatomic, strong) NSString *segmentId;
@property (nonatomic, strong) NSString *stageid;
@property (nonatomic, strong) NSString *studyId;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *pagesize;
@end

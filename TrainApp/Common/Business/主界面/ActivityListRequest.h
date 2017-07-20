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
@property (nonatomic, copy) NSString<Optional> *aid;
@property (nonatomic, copy) NSString<Optional> *pic;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *startTime;
@property (nonatomic, copy) NSString<Optional> *endTime;
@property (nonatomic, copy) NSString<Optional> *isJoin;//是否参与  0：未参与  1：已参与
@property (nonatomic, copy) NSString<Optional> *createUsername;
@property (nonatomic, copy) NSString<Optional> *studyName;
@property (nonatomic, copy) NSString<Optional> *segmentName;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString<Optional> *status;//0=未开始;2=进行中;3=已完成;4=阶段关闭-1=关闭;-2=草稿;-5=删除
@property (nonatomic, copy) NSString<Optional> *source;//活动来源 club或train->研修网;zgjiaoyan->教研网
@property (nonatomic, copy) NSString<Optional> *joinUserCount;
@property (nonatomic, copy) NSString<Optional> *restrictTime;//是否限制时间，1为限制，0为不限制
@property (nonatomic, copy) NSString<Optional> *isRecommend;//1代表推荐

@end
@interface ActivityListRequestItem_body_scheme_process : JSONModel
@property (nonatomic, copy) NSString<Optional> *userfinishnum;
@property (nonatomic, copy) NSString<Optional> *userfinishscore;
@end

@interface ActivityListRequestItem_body_scheme_scheme : JSONModel
@property (nonatomic, copy) NSString<Optional> *finishnum;
@property (nonatomic, copy) NSString<Optional> *finishscore;
@end

@interface ActivityListRequestItem_body_scheme : JSONModel
@property (nonatomic, strong) ActivityListRequestItem_body_scheme_scheme<Optional> *scheme;
@property (nonatomic, strong) ActivityListRequestItem_body_scheme_process<Optional> *process;
@end


@interface ActivityListRequestItem_body : JSONModel
@property (nonatomic, copy) NSString<Optional> *pageSize;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *totalPage;
@property (nonatomic, strong) NSArray<ActivityListRequestItem_body_activity,Optional> *actives;
@property (nonatomic, strong) ActivityListRequestItem_body_scheme<Optional> *scheme;
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

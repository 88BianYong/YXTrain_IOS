//
//  ActivityStepListRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/10.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol ActivityStepListRequestItem_Body_Active_Steps_Tools <NSObject>
@end
@protocol ActivityStepListRequestItem_Body_Active_Steps <NSObject>

@end

@interface ActivityStepListRequestItem_Body_Active_Steps_Tools : JSONModel
@property (nonatomic, copy) NSString<Optional> *toolid;
@property (nonatomic, copy) NSString<Optional> *aid;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString<Optional> *toolType;
@end

@interface ActivityStepListRequestItem_Body_Active_Steps : JSONModel
@property (nonatomic, copy) NSString<Optional> *stepid;
@property (nonatomic, copy) NSString<Optional> *aid;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, strong) NSArray<ActivityStepListRequestItem_Body_Active_Steps_Tools,Optional> *tools;
@end


@protocol ActivityStepListRequestItem_body_Active <NSObject>
@end
@interface ActivityStepListRequestItem_body_Active : JSONModel
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
@property (nonatomic, copy) NSString<Optional> *status;//0=未开始;2=进行中;3=已完成;-1=关闭;-2=草稿;-5=删除
@property (nonatomic, copy) NSString<Optional> *source;//活动来源 club或train->研修网;zgjiaoyan->教研网
@property (nonatomic, copy) NSString<Optional> *joinUserCount;
@property (nonatomic, copy) NSString<Optional> *stageId;
@property (nonatomic, strong) NSArray<ActivityStepListRequestItem_Body_Active_Steps,Optional> *steps;
@end

@interface ActivityStepListRequestItem_Body : JSONModel
@property (nonatomic, strong) ActivityStepListRequestItem_body_Active<Optional> *active;
@end
@interface ActivityStepListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ActivityStepListRequestItem_Body<Optional> *body;
@end

@interface ActivityStepListRequest : YXGetRequest
@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *source;
@end

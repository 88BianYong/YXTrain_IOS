//
//  HomeworkListRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"


@protocol HomeworkListRequest_17Item_Homeworks <NSObject>

@end
@interface HomeworkListRequest_17Item_Homeworks : JSONModel
@property (nonatomic, copy) NSString<Optional> *rID;
@property (nonatomic, copy) NSString<Optional> *toolID;
@property (nonatomic, copy) NSString<Optional> *stageID;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString<Optional> *keyword;
@property (nonatomic, copy) NSString<Optional> *way;
@property (nonatomic, copy) NSString<Optional> *userID;
@property (nonatomic, copy) NSString<Optional> *createTime;
@property (nonatomic, copy) NSString<Optional> *templateID;
@property (nonatomic, copy) NSString<Optional> *study;
@property (nonatomic, copy) NSString<Optional> *segment;
@property (nonatomic, copy) NSString<Optional> *ismyrec;//自荐
@property (nonatomic, copy) NSString<Optional> *studyName;
@property (nonatomic, copy) NSString<Optional> *segmentName;
@property (nonatomic, copy) NSString<Optional> *homeworkID;
@property (nonatomic, copy) NSString<Optional> *homeworkTitle;
@property (nonatomic, copy) NSString<Optional> *score;
@property (nonatomic, copy) NSString<Optional> *recommend;//> 0 表示已推优
@property (nonatomic, copy) NSString<Optional> *themeID;
@property (nonatomic, copy) NSString<Optional> *themeName;
@property (nonatomic, copy) NSString<Optional> *projectID;
@property (nonatomic, copy) NSString<Optional> *subProjectID;
@property (nonatomic, copy) NSString<Optional> *totalNum;
@property (nonatomic, copy) NSString<Optional> *submited;
@property (nonatomic, copy) NSString<Optional> *remarked;
@property (nonatomic, copy) NSString<Optional> *recommended;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *scoreDetail;
@property (nonatomic, copy) NSString<Optional> *isMasterRecommend;//坊主推荐
@property (nonatomic, copy) NSString<Optional> *isGrouperRecommend;//组长推荐
@property (nonatomic, copy) NSString<Optional> *isExpertRecommend;//专家推荐
@property (nonatomic, copy) NSString<Optional> *isMasterComment;//坊主点评
@property (nonatomic, copy) NSString<Optional> *isGrouperComment;//组长点评
@property (nonatomic, copy) NSString<Optional> *isExpertComment;//专家点评
@end

@interface HomeworkListRequest_17Item_Scheme_Process : JSONModel
@property (nonatomic, copy) NSString<Optional> *userFinishNum;
@property (nonatomic, copy) NSString<Optional> *userFinishScore;
@end


@interface HomeworkListRequest_17Item_Scheme_Scheme : JSONModel
@property (nonatomic, copy) NSString<Optional> *toolID;
@property (nonatomic, copy) NSString<Optional> *finishNum;
@property (nonatomic, copy) NSString<Optional> *finishScore;
@property (nonatomic, copy) NSString<Optional> *type;
@end

@protocol HomeworkListRequest_17Item_Scheme
@end
@interface HomeworkListRequest_17Item_Scheme : JSONModel
@property (nonatomic, strong) HomeworkListRequest_17Item_Scheme_Scheme<Optional> *scheme;
@property (nonatomic, strong) HomeworkListRequest_17Item_Scheme_Process<Optional> *process;
@end


@interface HomeworkListRequest_17Item : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<HomeworkListRequest_17Item_Scheme, Optional> *scheme;
@property (nonatomic, copy) NSString<Optional> *stageType;
@property (nonatomic, strong) NSArray<HomeworkListRequest_17Item_Homeworks, Optional> *homeworks;
@property (nonatomic, copy) NSString<Optional> *isExistsContent;
@property (nonatomic, copy) NSString<Optional> *hasRecmmend;
@property (nonatomic, copy) NSString<Optional> *stageStatus;
@property (nonatomic, copy) NSString<Optional> *descr;
@property (nonatomic, copy) NSString<Optional> *isfinish;

@end

@interface HomeworkListRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectID;
@property (nonatomic, copy) NSString<Optional> *stageID;
@property (nonatomic, copy) NSString<Optional> *toolID;
@end

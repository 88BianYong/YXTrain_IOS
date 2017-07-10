//
//  PersonalExamineRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol PersonalExamineRequest_17Item_Banner <NSObject>
@end
@interface PersonalExamineRequest_17Item_Banner : JSONModel
@property (nonatomic, copy) NSString<Optional> *bannerID;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *url;
@property (nonatomic, copy) NSString<Optional> *pic;
@end

@interface PersonalExamineRequest_17Item_Other : JSONModel
@property (nonatomic, copy) NSString<Optional> *isShowCourseMarket;
@property (nonatomic, copy) NSString<Optional> *isShowOfflineActive;
@property (nonatomic, copy) NSString<Optional> *ifWorks;
@property (nonatomic, copy) NSString<Optional> *guide;
@property (nonatomic, copy) NSString<Optional> *plans;
@end

@interface PersonalExamineRequest_17Item_Expert : JSONModel
@property (nonatomic, copy) NSString<Optional> *isShowExpertChannel;
@property (nonatomic, copy) NSString<Optional> *expertProjectID;
@end

@protocol PersonalExamineRequest_17Item_Examine_Process_ToolExamineVoList <NSObject>

@end
@interface PersonalExamineRequest_17Item_Examine_Process_ToolExamineVoList : JSONModel
@property (nonatomic, copy) NSString<Optional> *finishNum;
@property (nonatomic, copy) NSString<Optional> *isNeedMark;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *toolDesc;
@property (nonatomic, copy) NSString<Optional> *toolID;
@property (nonatomic, copy) NSString<Optional> *totalNum;
@property (nonatomic, copy) NSString<Optional> *totalScore;
@property (nonatomic, copy) NSString<Optional> *usersCore;
@end

@protocol PersonalExamineRequest_17Item_Examine_Process <NSObject>
@end
@interface PersonalExamineRequest_17Item_Examine_Process : JSONModel
@property (nonatomic, copy) NSString<Optional> *descr;
@property (nonatomic, copy) NSString<Optional> *endDate;
@property (nonatomic, copy) NSString<Optional> *processID;
@property (nonatomic, copy) NSString<Optional> *ifQuestion;
@property (nonatomic, copy) NSString<Optional> *isFinish;
@property (nonatomic, copy) NSString<Optional> *isPass;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *passsCore;
@property (nonatomic, copy) NSString<Optional> *stageID;
@property (nonatomic, strong) NSArray<PersonalExamineRequest_17Item_Examine_Process_ToolExamineVoList,Optional> *toolExamineVoList;
@property (nonatomic, copy) NSString<Optional> *totalScore;
@property (nonatomic, copy) NSString<Optional> *usersCore;
@end

@interface PersonalExamineRequest_17Item_Examine : JSONModel
@property (nonatomic, copy) NSString<Optional> *checkway;
@property (nonatomic, strong) NSArray<PersonalExamineRequest_17Item_Examine_Process, Optional> *process;
@end

@interface PersonalExamineRequest_17Item : HttpBaseRequestItem
@property (nonatomic, strong) PersonalExamineRequest_17Item_Examine<Optional> *examine;
@property (nonatomic, strong) PersonalExamineRequest_17Item_Expert<Optional> *expert;
@property (nonatomic, strong) PersonalExamineRequest_17Item_Other<Optional> *other;
@property (nonatomic, strong) NSArray<PersonalExamineRequest_17Item_Banner,Optional> *banner;
@end

@interface PersonalExamineRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *role;
@end

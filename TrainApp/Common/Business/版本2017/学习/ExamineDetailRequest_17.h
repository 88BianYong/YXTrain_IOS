//
//  ExamineDetailRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface ExamineDetailRequest_17Item_Banner : JSONModel
@property (nonatomic, copy) NSString<Optional> *bannerID;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *url;
@property (nonatomic, copy) NSString<Optional> *pic;
@end

@interface ExamineDetailRequest_17Item_Other : JSONModel
@property (nonatomic, copy) NSString<Optional> *isOpenGroup;
@property (nonatomic, copy) NSString<Optional> *isShowCert;
@property (nonatomic, copy) NSString<Optional> *isShowLocalcourse;
@property (nonatomic, copy) NSString<Optional> *isShowCourseMarket;
@property (nonatomic, copy) NSString<Optional> *isShowOfflineActive;
@property (nonatomic, copy) NSString<Optional> *isShowSelfHomework;
@property (nonatomic, copy) NSString<Optional> *isShowExam;
@property (nonatomic, copy) NSString<Optional> *isWorks;
@property (nonatomic, copy) NSString<Optional> *guide;
@property (nonatomic, copy) NSString<Optional> *plans;
@end

@interface ExamineDetailRequest_17Item_Expert : JSONModel
@property (nonatomic, copy) NSString<Optional> *isShowExpertChannel;
@property (nonatomic, copy) NSString<Optional> *expertProjectID;
@property (nonatomic, copy) NSString<Optional> *channelID;
@end
@protocol ExamineDetailRequest_17Item_Stages_Tools <NSObject>

@end
@interface ExamineDetailRequest_17Item_Stages_Tools : JSONModel
@property (nonatomic, copy) NSString<Optional> *toolID;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *orderNu;
@end
@protocol ExamineDetailRequest_17Item_Stages <NSObject>

@end
@interface ExamineDetailRequest_17Item_Stages: JSONModel
@property (nonatomic, copy) NSString<Optional> *isCurrStage;
@property (nonatomic, copy) NSString<Optional> *isFinish;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *stageID;
@property (nonatomic, copy) NSString<Optional> *startTime;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *subject;
@property (nonatomic, copy) NSString<Optional> *isMockFold;//是否折叠 用于判断展开收起
@property (nonatomic, strong) NSArray<ExamineDetailRequest_17Item_Stages_Tools,Optional> *tools;
@end

@interface ExamineDetailRequest_17Item_Theme : JSONModel
@property (nonatomic, copy) NSString<Optional> *isCanEditTheme;
@property (nonatomic, copy) NSString<Optional> *isHasHistoryTheme;
@property (nonatomic, copy) NSString<Optional> *isOpenTheme;
@property (nonatomic, copy) NSString<Optional> *isShowSwitchTheme;
@property (nonatomic, copy) NSString<Optional> *isUseSelectTheme;
@property (nonatomic, copy) NSString<Optional> *themeID;
@property (nonatomic, copy) NSString<Optional> *themeName;
@end

@interface ExamineDetailRequest_17Item_Layer : JSONModel
@property (nonatomic, copy) NSString<Optional> *isOpenLayerStudy;
@property (nonatomic, copy) NSString<Optional> *isShowSwitchLayer;
@property (nonatomic, copy) NSString<Optional> *isUseLayerStudy;
@property (nonatomic, copy) NSString<Optional> *layerName;
@property (nonatomic, copy) NSString<Optional> *layerID;
@end

@interface ExamineDetailRequest_17Item_User : JSONModel
@property (nonatomic, copy) NSString<Optional> *assiststatus;
@property (nonatomic, copy) NSString<Optional> *containsTeacher;
@property (nonatomic, copy) NSString<Optional> *headImg;
@property (nonatomic, copy) NSString<Optional> *isCurrRole;
@property (nonatomic, copy) NSString<Optional> *isInfoConfirm;
@property (nonatomic, copy) NSString<Optional> *roles;
@property (nonatomic, copy) NSString<Optional> *school;
@property (nonatomic, copy) NSString<Optional> *segment;
@property (nonatomic, copy) NSString<Optional> *stageName;
@property (nonatomic, copy) NSString<Optional> *study;
@property (nonatomic, copy) NSString<Optional> *studyName;
@property (nonatomic, copy) NSString<Optional> *userID;
@property (nonatomic, copy) NSString<Optional> *userName;
@end

@protocol ExamineDetailRequest_17Item_MockOther <NSObject>

@end
@interface ExamineDetailRequest_17Item_MockOther : JSONModel
/**
    otherType  1选课超市 2在线考试 3 专家频道
 */
@property (nonatomic, copy) NSString<Optional> *otherType;
@property (nonatomic, copy) NSString<Optional> *otherID;
@property (nonatomic, copy) NSString<Optional> *otherName;
@end
@protocol ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList <NSObject>
@end
@interface ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList : JSONModel
@property (nonatomic, copy) NSString<Optional> *orderNo;//
@property (nonatomic, copy) NSString<Optional> *totalScore;//
@property (nonatomic, copy) NSString<Optional> *userScore;//
@property (nonatomic, copy) NSString<Optional> *finishNum;//
@property (nonatomic, copy) NSString<Optional> *isNeedMark;//
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *passScore;
@property (nonatomic, copy) NSString<Optional> *toolID;//
@property (nonatomic, copy) NSString<Optional> *passFinishScore;
@property (nonatomic, copy) NSString<Optional> *totalNum;//
@property (nonatomic, copy) NSString<Optional> *isExistsNext;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *passTotalScore;
@property (nonatomic, strong) NSMutableArray<ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList,Optional> *toolExamineVoList;
@property (nonatomic, copy) NSString<Optional> *status;
@end
@protocol ExamineDetailRequest_17Item_Examine_Process <NSObject>
@end
@interface ExamineDetailRequest_17Item_Examine_Process : JSONModel
@property (nonatomic, copy) NSString<Optional> *descr;
@property (nonatomic, copy) NSString<Optional> *endDate;//
@property (nonatomic, copy) NSString<Optional> *processID;//
@property (nonatomic, copy) NSString<Optional> *ifQuestion;//
@property (nonatomic, copy) NSString<Optional> *isExistsNext;
@property (nonatomic, copy) NSString<Optional> *isFinish;//
@property (nonatomic, copy) NSString<Optional> *isPass;//
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *passsCore;//
@property (nonatomic, copy) NSString<Optional> *stageID;//
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSMutableArray<ExamineDetailRequest_17Item_Examine_Process_ToolExamineVoList, Optional> *toolExamineVoList;
@property (nonatomic, copy) NSString<Optional> *totalScore;//
@property (nonatomic, copy) NSString<Optional> *userScore;//
@property (nonatomic, copy) NSString<Optional> *passTotalScore;//
@end


@interface ExamineDetailRequest_17Item_Examine : JSONModel
@property (nonatomic, copy) NSString<Optional> *isPass;
@property (nonatomic, copy) NSString<Optional> *isExamPass;
@property (nonatomic, copy) NSString<Optional> *totalScore;
@property (nonatomic, copy) NSString<Optional> *userGetScore;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, strong) NSArray<ExamineDetailRequest_17Item_Examine_Process, Optional> *process;
@end

@interface ExamineDetailRequest_17Item: HttpBaseRequestItem
@property (nonatomic, strong) ExamineDetailRequest_17Item_User<Optional> *user;
@property (nonatomic, strong) NSArray<ExamineDetailRequest_17Item_Stages,Optional> *stages;
@property (nonatomic, strong) ExamineDetailRequest_17Item_Expert<Optional> *expert;
@property (nonatomic, strong) ExamineDetailRequest_17Item_Examine<Optional> *examine;
@property (nonatomic, strong) ExamineDetailRequest_17Item_Other<Optional> *other;
@property (nonatomic, strong) ExamineDetailRequest_17Item_Banner<Optional> *banner;
@property (nonatomic, strong) ExamineDetailRequest_17Item_Theme<Optional> *theme;
@property (nonatomic, strong) NSMutableArray<ExamineDetailRequest_17Item_MockOther,Optional> *mockOthers;
@property (nonatomic, copy) NSString<Optional> *passport;
@property (nonatomic, copy) NSString<Optional> *projectID;
@property (nonatomic, copy) NSString<Optional> *role;
@property (nonatomic, copy) NSString<Optional> *serverRole;

@end

@interface ExamineDetailRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectID;
@property (nonatomic, copy) NSString<Optional> *role;
@end

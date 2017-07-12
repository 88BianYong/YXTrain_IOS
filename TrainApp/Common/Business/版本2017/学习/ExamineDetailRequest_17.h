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
@property (nonatomic, copy) NSString<Optional> *isShowCourseMarket;
@property (nonatomic, copy) NSString<Optional> *isShowOfflineActive;
@property (nonatomic, copy) NSString<Optional> *ifWorks;
@property (nonatomic, copy) NSString<Optional> *guide;
@property (nonatomic, copy) NSString<Optional> *plans;
@end

@interface ExamineDetailRequest_17Item_Expert : JSONModel
@property (nonatomic, copy) NSString<Optional> *isShowExpertChannel;
@property (nonatomic, copy) NSString<Optional> *expertProjectId;
@end
@protocol ExamineDetailRequest_17Item_Stages_Tools <NSObject>

@end
@interface ExamineDetailRequest_17Item_Stages_Tools : JSONModel
@property (nonatomic, copy) NSString<Optional> *toolID;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *status;

@end
@protocol ExamineDetailRequest_17Item_Stages <NSObject>

@end
@interface ExamineDetailRequest_17Item_Stages: JSONModel
@property (nonatomic, copy) NSString<Optional> *isCurrStage;
@property (nonatomic, copy) NSString<Optional> *isFinish;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *notes;
@property (nonatomic, copy) NSString<Optional> *stageID;
@property (nonatomic, copy) NSString<Optional> *startTime;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *subject;
@property (nonatomic, strong) NSArray<ExamineDetailRequest_17Item_Stages_Tools,Optional> *tools;
@end

@interface ExamineDetailRequest_17Item_Theme : JSONModel
@property (nonatomic, strong) NSString<Optional> *isOpenTheme;
@property (nonatomic, strong) NSString<Optional> *themeID;
@property (nonatomic, strong) NSString<Optional> *themeName;
@property (nonatomic, strong) NSString<Optional> *isShowSwitchTheme;
@property (nonatomic, strong) NSString<Optional> *isUseSelectTheme;
@property (nonatomic, strong) NSString<Optional> *isCanEditTheme;
@end

@interface ExamineDetailRequest_17Item_Layer : JSONModel
@property (nonatomic, strong) NSString<Optional> *isOpenLayerStudy;
@property (nonatomic, strong) NSString<Optional> *isShowSwitchLayer;
@property (nonatomic, strong) NSString<Optional> *isUseLayerStudy;
@property (nonatomic, strong) NSString<Optional> *layerName;
@property (nonatomic, strong) NSString<Optional> *layerid;
@end

@interface ExamineDetailRequest_17Item_User : JSONModel
@property (nonatomic, copy) NSString<Optional> *userID;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *stageName;
@property (nonatomic, copy) NSString<Optional> *roles;
@property (nonatomic, copy) NSString<Optional> *headImg;
@property (nonatomic, copy) NSString<Optional> *isContainsTeacher;
@property (nonatomic, copy) NSString<Optional> *sInfoConfirm;
@end

@interface ExamineDetailRequest_17Item: HttpBaseRequestItem
@property (nonatomic, strong) ExamineDetailRequest_17Item_User<Optional> *user;
@property (nonatomic, strong) NSArray<ExamineDetailRequest_17Item_Stages,Optional> *stages;
@property (nonatomic, strong) ExamineDetailRequest_17Item_Expert<Optional> *expert;
@property (nonatomic, strong) ExamineDetailRequest_17Item_Other<Optional> *other;
@property (nonatomic, strong) ExamineDetailRequest_17Item_Banner<Optional> *banner;
@property (nonatomic, strong) NSDictionary<Optional> *theme;
@end

@interface ExamineDetailRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString *projectID;
@property (nonatomic, copy) NSString *role;
@end

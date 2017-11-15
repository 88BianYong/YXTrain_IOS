//
//  MasterLearningInfoRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol MasterLearningInfoRequestItem_Body_Bars
@end
@interface MasterLearningInfoRequestItem_Body_Bars: JSONModel
@property (nonatomic, copy) NSString<Optional> *name;//
@property (nonatomic, copy) NSString<Optional> *barId;//
@end
@protocol MasterLearningInfoRequestItem_Body_Count
@end
@interface MasterLearningInfoRequestItem_Body_Count : JSONModel
@property (nonatomic, copy) NSString<Optional> *xys;//学员总数
@property (nonatomic, copy) NSString<Optional> *hgrs;
@property (nonatomic, copy) NSString<Optional> *xxrs;
@property (nonatomic, copy) NSString<Optional> *cxrs;//
@property (nonatomic, copy) NSString<Optional> *bestrs;//
@property (nonatomic, copy) NSString<Optional> *cxl;//参训率
@property (nonatomic, copy) NSString<Optional> *hgl;//合格率
@property (nonatomic, copy) NSString<Optional> *xxl;//学习率
@property (nonatomic, copy) NSString<Optional> *bestl;//优秀率
@property (nonatomic, copy) NSString<Optional> *perscore;//平均分
@property (nonatomic, copy) NSString<Optional> *totalscore;
@property (nonatomic, copy) NSString<Optional> *totaltime;
@end
@protocol MasterLearningInfoRequestItem_Body_Schemes
@end
@interface MasterLearningInfoRequestItem_Body_Schemes : JSONModel
@property (nonatomic, copy) NSString<Optional> *typeCode;//
@property (nonatomic, copy) NSString<Optional> *descripe;//
@end
@protocol MasterLearningInfoRequestItem_Body_XueQing_LearningInfoList
@end
@interface MasterLearningInfoRequestItem_Body_XueQing_LearningInfoList: JSONModel
@property (nonatomic, copy) NSString<Optional> *userId;//
@property (nonatomic, copy) NSString<Optional> *realName;//
@property (nonatomic, copy) NSString<Optional> *unit;
@property (nonatomic, copy) NSString<Optional> *studyName;//
@property (nonatomic, copy) NSString<Optional> *totalScore;//
@property (nonatomic, copy) NSString<Optional> *leadScore;//
@property (nonatomic, copy) NSString<Optional> *expandScore;//
@property (nonatomic, copy) NSString<Optional> *mobile;
@property (nonatomic, copy) NSString<Optional> *avatar;
@property (nonatomic, copy) NSString<Optional> *isPass;
@end
@interface MasterLearningInfoRequestItem_Body_XueQing : JSONModel
@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *totalPage;
@property (nonatomic, strong) NSArray<MasterLearningInfoRequestItem_Body_XueQing_LearningInfoList,Optional> *learningInfoList;
@end

@interface  MasterLearningInfoRequestItem_Body : JSONModel
@property (nonatomic, strong) MasterLearningInfoRequestItem_Body_XueQing<Optional> *xueQing;
@property (nonatomic, strong) NSArray<MasterLearningInfoRequestItem_Body_Schemes,Optional> *schemes;
@property (nonatomic, strong) NSArray<MasterLearningInfoRequestItem_Body_Count,Optional> *details;
@property (nonatomic, strong) NSArray<MasterLearningInfoRequestItem_Body_Bars,Optional> *bars;
@end

@interface MasterLearningInfoRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterLearningInfoRequestItem_Body<Optional> *body;
@end

@interface MasterLearningInfoRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *barId;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *pageSize;
@end

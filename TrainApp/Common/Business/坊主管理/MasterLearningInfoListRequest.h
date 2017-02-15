//
//  MasterLearningInfoListRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 17/2/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol MasterLearningInfoListRequestItem_Body_LearningInfoList
@end
@interface MasterLearningInfoListRequestItem_Body_LearningInfoList: JSONModel
@property (nonatomic, copy) NSString<Optional> *userid;
@property (nonatomic, copy) NSString<Optional> *realname;
@property (nonatomic, copy) NSString<Optional> *unit;
@property (nonatomic, copy) NSString<Optional> *studyname;
@property (nonatomic, copy) NSString<Optional> *totalscore;
@property (nonatomic, copy) NSString<Optional> *leadscore;
@property (nonatomic, copy) NSString<Optional> *expandscore;


@end

@interface MasterLearningInfoListRequestItem_Body : JSONModel
@property (nonatomic, copy) NSString<Optional> *fangType;
@property (nonatomic, copy) NSString<Optional> *cxl;//参训率
@property (nonatomic, copy) NSString<Optional> *count;//成员数
@property (nonatomic, copy) NSString<Optional> *xxl;//学习率
@property (nonatomic, copy) NSString<Optional> *hgl;//合格率
@property (nonatomic, copy) NSString<Optional> *thgl;
@property (nonatomic, copy) NSString<Optional> *totalPage;
@property (nonatomic, strong) NSArray<MasterLearningInfoListRequestItem_Body_LearningInfoList, Optional> *learningInfoList;
@end
@interface MasterLearningInfoListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterLearningInfoListRequestItem_Body<Optional> *body;
@end

@interface MasterLearningInfoListRequest : YXGetRequest
@property (nonatomic, copy) NSString *ifhg;
@property (nonatomic, copy) NSString *ifcx;
@property (nonatomic, copy) NSString *ifxx;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *barId;
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *pageSize;
@end

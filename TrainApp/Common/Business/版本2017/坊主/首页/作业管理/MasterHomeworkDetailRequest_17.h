//
//  MasterHomeworkDetailRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol MasterHomeworkDetailItem_Body_Template_Affixs @end
@interface MasterHomeworkDetailItem_Body_Template_Affixs : JSONModel
@property (nonatomic, copy) NSString<Optional> *resId;
@property (nonatomic, copy) NSString<Optional> *resName;
@property (nonatomic, copy) NSString<Optional> *previewUrl;
@property (nonatomic, copy) NSString<Optional> *downloadUrl;
@property (nonatomic, copy) NSString<Optional> *convertStatus;
@property (nonatomic, copy) NSString<Optional> *resType;
@end

@interface MasterHomeworkDetailItem_Body_Template : JSONModel
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, strong) NSArray<MasterHomeworkDetailItem_Body_Template_Affixs,Optional> *affixs;
@property (nonatomic, copy) NSString<Optional> *segmentName;
@property (nonatomic, copy) NSString<Optional> *gradeName;
@property (nonatomic, copy) NSString<Optional> *studyName;
@property (nonatomic, copy) NSString<Optional> *chapterName;
@property (nonatomic, copy) NSString<Optional> *versionName;
@property (nonatomic, copy) NSString<Optional> *keyword;
@end

@interface MasterHomeworkDetailItem_Body_Require : JSONModel
@property (nonatomic, copy) NSString<Optional> *requireId;
@property (nonatomic, copy) NSString<Optional> *templateId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *descrip;
@property (nonatomic, copy) NSString<Optional> *keyword;
@end

@interface MasterHomeworkDetailItem_Body : JSONModel
@property (nonatomic, copy) NSString<Optional> *homeworkId;
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *stageId;
@property (nonatomic, copy) NSString<Optional> *userId;
@property (nonatomic, copy) NSString<Optional> *templateId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *createtime;
@property (nonatomic, copy) NSString<Optional> *score;

@property (nonatomic, copy) NSString<Optional> *myScore;
@property (nonatomic, copy) NSString<Optional> *publishUser;
@property (nonatomic, copy) NSString<Optional> *topicId;
@property (nonatomic, copy) NSString<Optional> *barId;
@property (nonatomic, copy) NSString<Optional> *isRecommend;
@property (nonatomic, copy) NSString<Optional> *isAllowRecommend;
@property (nonatomic, copy) NSString<Optional> *isMyRecommend;
@property (nonatomic, copy) NSString<Optional> *finishDate;
@property (nonatomic, strong) MasterHomeworkDetailItem_Body_Require<Optional> *require;
@property (nonatomic, strong) MasterHomeworkDetailItem_Body_Template<Optional> *template;
@end

@interface MasterHomeworkDetailItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterHomeworkDetailItem_Body<Optional> *body;
@end
@interface MasterHomeworkDetailRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *homeworkId;
@end

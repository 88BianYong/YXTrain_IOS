//
//  MasterHomeworkSetDetailRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol MasterHomeworkSetDetailItem_Template_Affix @end
@interface MasterHomeworkSetDetailItem_Template_Affix : JSONModel
@property (nonatomic, copy) NSString<Optional> *resId;
@property (nonatomic, copy) NSString<Optional> *resName;
@property (nonatomic, copy) NSString<Optional> *previewUrl;
@property (nonatomic, copy) NSString<Optional> *downloadUrl;
@property (nonatomic, copy) NSString<Optional> *convertStatus;
@property (nonatomic, copy) NSString<Optional> *resType;

@end

@protocol MasterHomeworkSetDetailItem_Body_Template @end
@interface MasterHomeworkSetDetailItem_Body_Template : JSONModel
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, strong) NSArray<MasterHomeworkSetDetailItem_Template_Affix,Optional> *affixs;
@property (nonatomic, copy) NSString<Optional> *segmentName;
@property (nonatomic, copy) NSString<Optional> *gradeName;
@property (nonatomic, copy) NSString<Optional> *studyName;
@property (nonatomic, copy) NSString<Optional> *chapterName;
@property (nonatomic, copy) NSString<Optional> *versionName;
@property (nonatomic, copy) NSString<Optional> *keyword;

@end

@interface MasterHomeworkSetDetailItem_Body : JSONModel
@property (nonatomic, copy) NSString<Optional> *homeworkId;
@property (nonatomic, copy) NSString<Optional> *templateId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *publishUser;
@property (nonatomic, strong) NSArray<MasterHomeworkSetDetailItem_Body_Template,Optional> *template;
@end

@interface MasterHomeworkSetDetailItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterHomeworkSetDetailItem_Body<Optional> *body;
@end

@interface MasterHomeworkSetDetailRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *homeworkId;
@end

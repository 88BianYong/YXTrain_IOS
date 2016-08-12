//
//  YXHomeworkInfoRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol YXHomeworkInfoRequestItem_Body <NSObject>
@end


@interface YXHomeworkInfoRequestItem_Body_Detail : JSONModel
@property (nonatomic ,copy) NSString<Optional> *title;
@property (nonatomic ,copy) NSString<Optional> *segmentName;
@property (nonatomic ,copy) NSString<Optional> *gradeName;
@property (nonatomic ,copy) NSString<Optional> *studyName;
@property (nonatomic ,copy) NSString<Optional> *chapterName;
@property (nonatomic ,copy) NSString<Optional> *versionName;
@property (nonatomic ,copy) NSString<Optional> *keyword;
@end

@interface YXHomeworkInfoRequestItem_Body:JSONModel
@property (nonatomic ,copy) NSString<Optional> *requireId;
@property (nonatomic ,copy) NSString<Optional> *title;
@property (nonatomic ,copy) NSString<Optional> *depiction;
@property (nonatomic ,copy) NSString<Optional> *createtime;
@property (nonatomic ,copy) NSString<Optional> *templateid; //模板id
@property (nonatomic ,copy) NSString<Optional> *ismyrec;// 0--普通， 1--自鉴
@property (nonatomic ,copy) NSString<Optional> *homeworkid;
@property (nonatomic ,copy) NSString<Optional> *recommend;//0--普通， 1--优
@property (nonatomic ,copy) NSString<Optional> *type;//作业类型 1普通作业 2视频作业 3需要判断录制时间的视频作业
@property (nonatomic ,copy) NSString<Optional> *score;//分数
@property (nonatomic ,copy) NSString<Optional> *endDate;//结束时间
@property (nonatomic, copy) NSString<Optional> *isFinished;//0--未完成，1 已完成
@property (nonatomic ,strong) YXHomeworkInfoRequestItem_Body_Detail<Optional> *detail;//视频作业详细信息，只有视频作业是已完成，才显示该部分内容

/**
 *  视频保存需要信息
 */
@property (nonatomic, copy) NSString<Optional> *uid;
@property (nonatomic, copy) NSString<Optional> *pid;
@property (nonatomic, copy) NSString<Optional> *fileName;
@property (nonatomic, assign) YXVideoLessonStatus lessonStatus;
@property (nonatomic, assign) CGFloat   uploadPercent;
@property (nonatomic, assign) BOOL isUploadSuccess;


@end

@interface YXHomeworkInfoRequestItem : HttpBaseRequestItem
@property (nonatomic ,strong) YXHomeworkInfoRequestItem_Body<Optional> *body;
@end

@interface YXHomeworkInfoRequest : YXGetRequest
@property (nonatomic ,copy) NSString *pid;
@property (nonatomic ,copy) NSString *requireid;
@property (nonatomic ,copy) NSString *hwid;
@end

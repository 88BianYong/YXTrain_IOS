//
//  MasterHomeworkSetListDetailRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//


#import "YXGetRequest.h"
@protocol MasterHomeworkSetListDetailItem_Body_Homework @end
@interface MasterHomeworkSetListDetailItem_Body_Homework : JSONModel
@property (nonatomic, copy) NSString<Optional> *homeworkId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *templateId;

@end
@interface MasterHomeworkSetListDetailItem_Body : JSONModel
@property (nonatomic, copy) NSString<Optional> *homeworkSetId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *score;
@property (nonatomic, copy) NSString<Optional> *myScore;
@property (nonatomic, copy) NSString<Optional> *isRecommend;
@property (nonatomic, copy) NSString<Optional> *isMyRecommend;
@property (nonatomic, copy) NSArray<MasterHomeworkSetListDetailItem_Body_Homework,Optional> *homeworks;
@end
@interface MasterHomeworkSetListDetailItem :HttpBaseRequestItem
@property (nonatomic, strong) MasterHomeworkSetListDetailItem_Body *body;
@end
@interface MasterHomeworkSetListDetailRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *homeworkSetId;
@end

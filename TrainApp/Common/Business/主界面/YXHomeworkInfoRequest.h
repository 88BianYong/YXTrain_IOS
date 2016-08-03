//
//  YXHomeworkInfoRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface YXHomeworkInfoRequestItem_Body:JSONModel
@property (nonatomic ,copy) NSString *requireId;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *depiction;
@property (nonatomic ,copy) NSString *createtime;
@property (nonatomic ,copy) NSString *templateid; //模板id
@property (nonatomic ,copy) NSString *ismyrec;// 0--普通， 1--自鉴
@property (nonatomic ,copy) NSString *homeworkid;
@property (nonatomic ,copy) NSString *recommend;//0--普通， 1--优
@property (nonatomic ,copy) NSString *type;//作业类型 1普通作业 2视频作业 3需要判断录制时间的视频作业
@property (nonatomic ,copy) NSString *score;//分数
@property (nonatomic ,copy) NSString *endDate;//结束时间
@property (nonatomic, copy) NSString *isFinished;//0--未完成，1 已完成
@end

@interface YXHomeworkInfoRequestItem : HttpBaseRequestItem
@property (nonatomic ,strong) YXHomeworkInfoRequestItem_Body<Optional> *body;
@end

@interface YXHomeworkInfoRequest : YXGetRequest
@property (nonatomic ,copy) NSString *pid;
@property (nonatomic ,copy) NSString *hwid;
@end

//
//  YXHomeworkListRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol YXHomeworkListRequestItem_Body_Stages_Homeworks<NSObject>
@end
@interface YXHomeworkListRequestItem_Body_Stages_Homeworks:JSONModel
@property (nonatomic, copy) NSString<Optional> *requireId;//对应作业详情requireid
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *depiction;
@property (nonatomic, copy) NSString<Optional> *createtime;
@property (nonatomic, copy) NSString<Optional> *templateid;//模板id
@property (nonatomic, copy) NSString<Optional> *ismyrec;// 0--普通， 1--自鉴
@property (nonatomic, copy) NSString<Optional> *homeworkid;//对应作业详情hwid
@property (nonatomic, copy) NSString<Optional> *recommend;//0--普通， 1--优
@property (nonatomic, copy) NSString<Optional> *type;//作业类型 1普通作业 2视频作业 3需要判断录制时间的视频作业
@property (nonatomic, copy) NSString<Optional> *isFinished;//0--未完成，1 已完成
@end

@protocol YXHomeworkListRequestItem_Body_Stages <NSObject>
@end
@interface YXHomeworkListRequestItem_Body_Stages : JSONModel
@property (nonatomic, copy) NSString<Optional> *stagesId;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *subject;
@property (nonatomic, strong) NSMutableArray<YXHomeworkListRequestItem_Body_Stages_Homeworks ,Optional> *homeworks;
@end


@interface YXHomeworkListRequestItem_Body : JSONModel
@property (nonatomic, copy) NSString<Optional> *endDate;
@property (nonatomic, strong) NSMutableArray<YXHomeworkListRequestItem_Body_Stages ,Optional> *stages;
@end

@interface YXHomeworkListRequestItem:HttpBaseRequestItem
@property (nonatomic, strong)YXHomeworkListRequestItem_Body<Optional> * body;
@end


@interface YXHomeworkListRequest : YXGetRequest
@property (nonatomic, copy) NSString *pid;
@end

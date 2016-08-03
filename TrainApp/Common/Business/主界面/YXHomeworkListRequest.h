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
@property (nonatomic, copy) NSString *requireId;//对应作业详情requireid
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *depiction;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *templateid;//模板id
@property (nonatomic, copy) NSString *ismyrec;// 0--普通， 1--自鉴
@property (nonatomic, copy) NSString *homeworkid;//对应作业详情hwid
@property (nonatomic, copy) NSString *recommend;//0--普通， 1--优
@property (nonatomic, copy) NSString *type;//作业类型 1普通作业 2视频作业 3需要判断录制时间的视频作业
@property (nonatomic, copy) NSString *isFinished;//0--未完成，1 已完成
@end


@interface YXHomeworkListRequestItem_Body_Stages : JSONModel
@end
@protocol YXHomeworkListRequestItem_Body_Stages <NSObject>
@property (nonatomic, copy) NSString *stagesId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, strong) NSMutableArray<YXHomeworkListRequestItem_Body_Stages_Homeworks ,Optional> *homeworks;
@end

@interface YXHomeworkListRequestItem_Body : JSONModel
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, strong) NSMutableArray<YXHomeworkListRequestItem_Body_Stages ,Optional> *stages;
@end

@interface YXHomeworkListRequestItem:HttpBaseRequestItem
@property (nonatomic, strong)YXHomeworkListRequestItem_Body<Optional> * body;
@end


@interface YXHomeworkListRequest : YXGetRequest
@property (nonatomic, copy) NSString *pid;
@end

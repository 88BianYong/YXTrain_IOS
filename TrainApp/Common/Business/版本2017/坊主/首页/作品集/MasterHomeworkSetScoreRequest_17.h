//
//  MasterHomeworkSetScoreRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface MasterHomeworkSetScoreItem_Body : JSONModel
@property (nonatomic, copy) NSString<Optional> *hwscore;//作业的分数
@property (nonatomic, copy) NSString<Optional> *myscore;//我的评分结果
@end
@interface MasterHomeworkSetScoreItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterHomeworkSetScoreItem_Body<Optional> *body;
@end
@interface MasterHomeworkSetScoreRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *homeworkSetId;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *score;
@end

//
//  MasterCancelRecommendHomeworkRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface MasterCancelRecommendHomeworkItem_Body : JSONModel
@property (nonatomic, copy) NSString<Optional> *isRecommend;
@end

@interface MasterCancelRecommendHomeworkItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterCancelRecommendHomeworkItem_Body<Optional> *body;
@end

@interface MasterCancelRecommendHomeworkRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *homeworkId;
@property (nonatomic, copy) NSString<Optional> *content;
@end

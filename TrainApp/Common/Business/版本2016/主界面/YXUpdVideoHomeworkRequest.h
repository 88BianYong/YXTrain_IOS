//
//  YXUpdVideoHomeworkRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/18.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol YXUpdVideoHomeworkRequestModel<NSObject>
@end

@interface YXUpdVideoHomeworkRequestItem_Data:JSONModel
@property (nonatomic ,copy) NSString<Optional> *hwid;
@end


@interface YXUpdVideoHomeworkRequestModel:JSONModel
@property (nonatomic ,copy) NSString *contentId;
@property (nonatomic ,copy) NSString *content;
@end

@interface YXUpdVideoHomeworkRequestData:JSONModel
@property (nonatomic, strong) NSMutableArray<YXUpdVideoHomeworkRequestModel,Optional> *data;
@end


@interface YXUpdVideoHomeworkRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) YXUpdVideoHomeworkRequestItem_Data<Optional> *body;
@end

@interface YXUpdVideoHomeworkRequest : YXGetRequest
@property (nonatomic ,copy) NSString *pid;
@property (nonatomic ,copy) NSString *requireid;
@property (nonatomic ,copy) NSString *hwid;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *content;
@end

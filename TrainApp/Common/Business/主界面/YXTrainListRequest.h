//
//  YXTrainListRequest.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol YXTrainListRequestItem_body_train <NSObject>

@end

@interface YXTrainListRequestItem_body_train : JSONModel
@property (nonatomic, strong) NSString<Optional> *pid;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *w;
@property (nonatomic, strong) NSString<Optional> *pic;
@end

@interface YXTrainListRequestItem_body : JSONModel
@property (nonatomic, strong) NSString<Optional> *total;
@property (nonatomic, strong) NSArray<YXTrainListRequestItem_body_train,Optional> *trains;
@end

@interface YXTrainListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) YXTrainListRequestItem_body<Optional> *body;
@end

@interface YXTrainListRequest : YXGetRequest

@end

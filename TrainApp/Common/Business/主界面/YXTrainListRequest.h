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
@property (nonatomic, strong) NSString<Optional> *status;//1-training;0-trained
@end

@interface YXTrainListRequestItem_body : JSONModel
@property (nonatomic, strong) NSString<Optional> *total;
//@property (nonatomic, strong) NSIndexPath<Optional> *indexPath;//现在没有了这个接口~//自己写的
@property (nonatomic, strong) NSString<Optional> *indexPathSection;
@property (nonatomic, strong) NSString<Optional> *indexPathRow;
@property (nonatomic, strong) NSArray<YXTrainListRequestItem_body_train,Optional> *trains;
@property (nonatomic, strong) NSArray<YXTrainListRequestItem_body_train,Optional> *training;
@property (nonatomic, strong) NSArray<YXTrainListRequestItem_body_train,Optional> *trained;
@end

@interface YXTrainListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) YXTrainListRequestItem_body<Optional> *body;
@property (nonatomic, strong) NSString<Optional> *token;//目前仅用来判断用户登出后再次登录时是否是同一账户,用来切换项目使用
@end

@interface YXTrainListRequest : YXGetRequest

@end

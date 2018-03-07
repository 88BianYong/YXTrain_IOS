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
@property (nonatomic, strong) NSString<Optional> *roles;
@property (nonatomic, strong) NSString<Optional> *isContainsTeacher;
//2.4.2
@property (nonatomic, strong) NSString<Optional> *isOpenLayer;//是否开启分层
@property (nonatomic, strong) NSString<Optional> *layerId;//分层id
@property (nonatomic, strong) NSString<Optional> *isOpenTheme;//是否开启主题
@property (nonatomic, strong) NSString<Optional> *themeId;//主题id

//3.0
@property (nonatomic, strong) NSString<Optional> *startDate;
@property (nonatomic, strong) NSString<Optional> *endDate;

//3.0.1
@property (nonatomic, strong) NSString<Optional> *special;//1   18德阳项目  0 正常

//3.0.2
@property (nonatomic, strong) NSString<Optional> *isSignAgreement;//是否签署协议

//自定义
@property (nonatomic, strong) NSString<Ignore> *role;
@property (nonatomic, strong) NSString<Ignore> *isDoubel;
@end

@interface YXTrainListRequestItem_body : JSONModel
@property (nonatomic, strong) NSString<Optional> *choosePid;
@property (nonatomic, strong) NSString<Optional> *total;
@property (nonatomic, strong) NSArray<YXTrainListRequestItem_body_train,Optional> *trains;
@property (nonatomic, strong) NSMutableArray<YXTrainListRequestItem_body_train,Optional> *training;
@property (nonatomic, strong) NSMutableArray<YXTrainListRequestItem_body_train,Optional> *trained;
@end

@interface YXTrainListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) YXTrainListRequestItem_body<Optional> *body;
@end

@interface YXTrainListRequest : YXGetRequest

@end

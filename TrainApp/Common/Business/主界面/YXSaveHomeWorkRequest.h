//
//  YXSaveHomeWorkRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface YXSaveHomeWorkRequestModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *typeId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *categoryIds;
@property (nonatomic, copy) NSString<Optional> *des;
@property (nonatomic, copy) NSString<Optional> *externalUrl;
@property (nonatomic, copy) NSString<Optional> *chapter;
@property (nonatomic, copy) NSString<Optional> *clubids;
@property (nonatomic, copy) NSString<Optional> *barId;
@property (nonatomic, copy) NSString<Optional> *shareType;
@property (nonatomic, copy) NSString<Optional> *reserve;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *appIds;
@property (nonatomic, copy) NSString<Optional> *projectid;
@property (nonatomic, copy) NSString<Optional> *requireid;
@property (nonatomic, copy) NSString<Optional> *hwid;
@end

@interface YXSaveHomeWorkRequestItem : HttpBaseRequest
@property (nonatomic, copy) NSString<Optional> *resid;
@end

@interface YXSaveHomeWorkRequest : YXGetRequest
@property (nonatomic, copy) NSString *rid;
@property (nonatomic, copy) NSString *ext;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *filesize;
@property (nonatomic, copy) NSString *reserve;
@end

//
//  DownloadResourceRequest.h
//  TrainApp
//
//  Created by ZLL on 2016/11/22.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol DownloadResourceRequestItem_body_resource <NSObject>
@end
@interface DownloadResourceRequestItem_body_resource : JSONModel

@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *resId;
@property (nonatomic, copy) NSString<Optional> *resName;
@property (nonatomic, copy) NSString<Optional> *publishTime;
@property (nonatomic, copy) NSString<Optional> *createUsername;
@property (nonatomic, copy) NSString<Optional> *resType;
@property (nonatomic, copy) NSString<Optional> *fileType;
@property (nonatomic, copy) NSString<Optional> *resSize;
@property (nonatomic, copy) NSString<Optional> *previewUrl;//资源中心转换格式后,统一用resource.previewUrl!
@property (nonatomic, copy) NSString<Optional> *downloadUrl;
@property (nonatomic, copy) NSString<Optional> *isCollection;
@property (nonatomic, copy) NSString<Optional> *externalUrl;
@property (nonatomic, copy) NSString<Optional> *res_thumb;
@end

@protocol DownloadResourceRequestItem_body <NSObject>
@end
@interface DownloadResourceRequestItem_body : JSONModel
@property (nonatomic, strong) DownloadResourceRequestItem_body_resource<Optional> *resource;
@end

@interface DownloadResourceRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) DownloadResourceRequestItem_body<Optional> *body;
@end

@interface DownloadResourceRequest : YXGetRequest
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *toolId;
@property (nonatomic, copy) NSString *stageId;
@end

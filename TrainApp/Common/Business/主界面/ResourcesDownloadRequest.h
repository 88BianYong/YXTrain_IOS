//
//  ResourcesDownloadRequest.h
//  TrainApp
//
//  Created by ZLL on 2016/11/18.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol ResourcesDownloadRequestItem_body_resource <NSObject>
@end
@interface ResourcesDownloadRequestItem_body_resource : JSONModel

@property (nonatomic, copy) NSString<Optional> *resId;
@property (nonatomic, copy) NSString<Optional> *resName;
@property (nonatomic, copy) NSString<Optional> *publishTime;
@property (nonatomic, copy) NSString<Optional> *createUsername;
@property (nonatomic, copy) NSString<Optional> *resType;
@property (nonatomic, copy) NSString<Optional> *resSize;
@property (nonatomic, copy) NSString<Optional> *previewUrl;
@property (nonatomic, copy) NSString<Optional> *downloadUrl;
@property (nonatomic, copy) NSString<Optional> *isCollection;
@end

@protocol ResourcesDownloadRequestItem_body <NSObject>
@end
@interface ResourcesDownloadRequestItem_body : JSONModel
@property (nonatomic, strong) ResourcesDownloadRequestItem_body_resource<Optional> *resource;
@end

@interface ResourcesDownloadRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ResourcesDownloadRequestItem_body<Optional> *body;
@end

@interface ResourcesDownloadRequest : YXGetRequest
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *toolId;
@property (nonatomic, copy) NSString *w;//区分哪个平台项目，目前3（15项目），4（16项目）
@end

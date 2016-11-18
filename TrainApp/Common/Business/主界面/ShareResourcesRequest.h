//
//  ShareResourcesRequest.h
//  TrainApp
//
//  Created by ZLL on 2016/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol ShareResourcesRequestItem_body_resource <NSObject>
@end
@interface ShareResourcesRequestItem_body_resource : JSONModel

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

@interface ShareResourcesRequestItem_body : JSONModel
@property (nonatomic, strong) NSArray<ShareResourcesRequestItem_body_resource,Optional> *resources;
@end

@interface ShareResourcesRequestItem : HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> *count;
@property (nonatomic, copy) NSString<Optional> *toolid;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *totalPage;
@property (nonatomic, strong) ShareResourcesRequestItem_body<Optional> *body;
@end

@interface ShareResourcesRequest : YXGetRequest
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *toolId;
@property (nonatomic, copy) NSString *w;//区分哪个平台项目，目前3（15项目），4（16项目）
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *pageSize;
@end

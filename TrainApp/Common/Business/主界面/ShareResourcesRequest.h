//
//  ShareResourcesRequest.h
//  TrainApp
//
//  Created by ZLL on 2016/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol ActivityListRequestItem_body_resource <NSObject>
@end
@interface ActivityListRequestItem_body_resource : JSONModel

@property (nonatomic, strong) NSString<Optional> *resId;
@property (nonatomic, strong) NSString<Optional> *resName;
@property (nonatomic, strong) NSString<Optional> *publishTime;
@property (nonatomic, strong) NSString<Optional> *createUsername;
@property (nonatomic, strong) NSString<Optional> *resType;
@property (nonatomic, strong) NSString<Optional> *resSize;
@property (nonatomic, strong) NSString<Optional> *previewUrl;
@property (nonatomic, strong) NSString<Optional> *downloadUrl;
@end

@interface ShareResourcesRequest_body : JSONModel
@property (nonatomic, strong) NSString<Optional> *count;
@property (nonatomic, strong) NSString<Optional> *toolid;
@property (nonatomic, strong) NSString<Optional> *page;
@property (nonatomic, strong) NSString<Optional> *totalPage;
@property (nonatomic, strong) NSArray<ActivityListRequestItem_body_resource,Optional> *resources;
@end

@interface ShareResourcesRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ShareResourcesRequest_body<Optional> *body;
@end

@interface ShareResourcesRequest : YXGetRequest
@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *toolId;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *pagesize;
@end

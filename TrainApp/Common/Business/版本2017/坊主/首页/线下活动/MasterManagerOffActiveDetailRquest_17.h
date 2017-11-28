//
//  MasterManagerOffActiveDetailRquest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/28.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol MasterManagerOffActiveDetailItem_Body_Affix @end
@interface MasterManagerOffActiveDetailItem_Body_Affix : JSONModel
@property (nonatomic, copy) NSString<Optional> *resId;
@property (nonatomic, copy) NSString<Optional> *resName;
@property (nonatomic, copy) NSString<Optional> *previewUrl;
@property (nonatomic, copy) NSString<Optional> *downloadUrl;
@property (nonatomic, copy) NSString<Optional> *convertStatus;
@property (nonatomic, copy) NSString<Optional> *resType;
@end

@interface MasterManagerOffActiveDetailItem_Body : JSONModel
@property (nonatomic, copy) NSString<Optional> *activeId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *joinUserCount;
@property (nonatomic, copy) NSString<Optional> *startTime;
@property (nonatomic, copy) NSString<Optional> *endTime;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString<Optional> *wonderful;
@property (nonatomic, copy) NSString<Optional> *pic;
@property (nonatomic, copy) NSString<Optional> *restrictTime;
@property (nonatomic, copy) NSString<Optional> *topicId;
@property (nonatomic, copy) NSString<Optional> *barId;
@property (nonatomic, strong) NSArray<MasterManagerOffActiveDetailItem_Body_Affix,Optional> *affixs;
@end

@interface MasterManagerOffActiveDetailItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterManagerOffActiveDetailItem_Body *body;
@end

@interface MasterManagerOffActiveDetailRquest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *aId;
@end

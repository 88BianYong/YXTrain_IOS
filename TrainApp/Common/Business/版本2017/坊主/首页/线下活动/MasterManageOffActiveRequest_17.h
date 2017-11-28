//
//  MasterManageOffActiveRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "MasterManagerSchemeItem.h"

@protocol MasterManageOffActiveItem_Body_Active @end
@interface MasterManageOffActiveItem_Body_Active : JSONModel
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *joinUserCount;
@property (nonatomic, copy) NSString<Optional> *startTime;
@property (nonatomic, copy) NSString<Optional> *endTime;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *desc;
@property (nonatomic, copy) NSString<Optional> *pic;
@property (nonatomic, copy) NSString<Optional> *restrictTime;
@property (nonatomic, copy) NSString<Optional> *activeId;

@end
@interface MasterManageOffActiveItem_Body : JSONModel
@property (nonatomic, strong) MasterManagerSchemeItem<Optional> *scheme;
@property (nonatomic, strong) NSArray<MasterManageOffActiveItem_Body_Active, Optional> *offActives;
@property (nonatomic, copy) NSString<Optional> *total;
@end

@interface MasterManageOffActiveItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterManageOffActiveItem_Body<Optional> *body;
@end
@interface MasterManageOffActiveRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *aId;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *pageSize;
@end

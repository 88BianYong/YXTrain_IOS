//
//  MasterManageBrief_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "MasterNoticeBriefScheme.h"
@interface MasterManageBriefItem_Body : JSONModel
@property (nonatomic, strong) NSArray<MasterNoticeBriefItem,Optional> *briefs;
@property (nonatomic, strong) MasterNoticeBriefScheme<Optional> *scheme;
@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *totalPage;
@end

@interface MasterManageBriefItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterManageBriefItem_Body<Optional> *body;
@end

@interface MasterManageBriefRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *pageSize;

@end

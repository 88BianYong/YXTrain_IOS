//
//  MasterManageNotice_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "MasterNoticeBriefScheme.h"
@interface MasterManageNoticeItem_Body : JSONModel
@property (nonatomic, strong) NSArray<MasterNoticeBriefItem,Optional> *notices;
@property (nonatomic, strong) MasterNoticeBriefScheme<Optional> *scheme;
@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *totalPage;
@end


@interface MasterManageNoticeItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterManageNoticeItem_Body<Optional> *body;
@end

@interface MasterManageNoticeRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *pageSize;

@end

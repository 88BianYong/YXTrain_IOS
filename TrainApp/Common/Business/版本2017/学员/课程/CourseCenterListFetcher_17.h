//
//  CourseCenterListFetcher.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "CourseCenterListRequest_17.h"
@interface CourseCenterListFetcher_17 : PagedListFetcherBase
@property (nonatomic, copy) NSString<Optional> *stageID;
@property (nonatomic, copy) NSString<Optional> *study;//学科id，默认值0
@property (nonatomic, copy) NSString<Optional> *segment;//学段id，默认值0
@property (nonatomic, copy) NSString<Optional> *status;//0:全部， 1：已选， 2：未选
@property (nonatomic, copy) NSString<Optional> *tab;//my:我的， all: 全部
@property (nonatomic, copy) void(^courseCenterItemBlock)(CourseCenterListRequest_17Item_Summary *model);

@end

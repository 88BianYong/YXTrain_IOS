//
//  CourseListFetcher_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "CourseListRequest_17.h"
@interface CourseListFetcher_17 : PagedListFetcherBase
@property (nonatomic, copy) NSString<Optional> *stageID;
@property (nonatomic, copy) NSString<Optional> *study;//学科id，默认值0
@property (nonatomic, copy) NSString<Optional> *segment;//学段id，默认值0
@property (nonatomic, copy) NSString<Optional> *type;//101：选修， 102：必修，默认值0

@property (nonatomic, copy) void(^courseListItemBlock)(CourseListRequest_17Item *model);
@end

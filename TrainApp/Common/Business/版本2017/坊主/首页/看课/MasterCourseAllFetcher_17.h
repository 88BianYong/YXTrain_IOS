//
//  MasterCourseAllFetcher_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/4.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "LSTCollectionFilterProtocol.h"
@interface MasterCourseAllFetcher_17 : PagedListFetcherBase<LSTCollectionFilterProtocol>
@property (nonatomic, copy) NSString<Optional> *stageID;
@property (nonatomic, copy) NSString<Optional> *study;//学科id，默认值0
@property (nonatomic, copy) NSString<Optional> *segment;//学段id，默认值0
@property (nonatomic, copy) NSString<Optional> *type;//101：选修， 102：必修，默认值0
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) void(^masterCourseFilterBlock)(LSTCollectionFilterModel *model);

@end

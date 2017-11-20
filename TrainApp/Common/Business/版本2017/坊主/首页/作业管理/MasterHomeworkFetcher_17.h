//
//  MasterHomeworkFetcher_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "MasterHomeworkListRequest_17.h"
#import "LSTCollectionFilterDefaultProtocol.h"
@interface MasterHomeworkFetcher_17 : PagedListFetcherBase<LSTCollectionFilterDefaultProtocol>
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *barId;
@property (nonatomic, copy) NSString<Optional> *recommendStatus;
@property (nonatomic, copy) NSString<Optional> *readStatus;
@property (nonatomic, copy) NSString<Optional> *commendStatus;

@property (nonatomic, copy) void(^masterHomeworkBlock)(NSArray *model,NSArray<MasterManagerSchemeItem *> *schemes);
@end

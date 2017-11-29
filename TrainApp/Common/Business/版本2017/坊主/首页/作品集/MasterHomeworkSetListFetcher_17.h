//
//  MasterHomeworkSetListFetcher_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "MasterManagerSchemeItem.h"
#import "LSTCollectionFilterDefaultProtocol.h"
@interface MasterHomeworkSetListFetcher_17 : PagedListFetcherBase
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *barId;
@property (nonatomic, copy) NSString<Optional> *recommendStatus;
@property (nonatomic, copy) NSString<Optional> *readStatus;
@property (nonatomic, copy) NSString<Optional> *commendStatus;

@property (nonatomic, copy) void(^masterHomeworkBlock)(NSArray *model,NSArray<MasterManagerSchemeItem *> *schemes);
@end

//
//  MasterManageActiveFetcher_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "MasterManagerSchemeItem.h"
#import "LSTCollectionFilterDefaultProtocol.h"
@interface MasterManageActiveFetcher_17 : PagedListFetcherBase
@property (nonatomic, copy) NSString<Optional> *barId;
@property (nonatomic, copy) NSString<Optional> *study;
@property (nonatomic, copy) NSString<Optional> *segment;
@property (nonatomic, copy) NSString<Optional> *stageId;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) void(^masterManageActiveBlock)(NSArray *model, MasterManagerSchemeItem * scheme);
@end

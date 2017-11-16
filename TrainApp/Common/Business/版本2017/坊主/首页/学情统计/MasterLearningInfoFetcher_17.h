//
//  MasterLearningInfoFetcher_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "MasterLearningInfoRequest_17.h"
#import "LSTCollectionFilterDefaultProtocol.h"
@interface MasterLearningInfoFetcher_17 : PagedListFetcherBase<LSTCollectionFilterDefaultProtocol>
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, copy) NSString<Optional> *barId;
@property (nonatomic, copy) void(^masterLearningInfoBlock)(NSArray *model,MasterLearningInfoRequestItem_Body *body);
@end

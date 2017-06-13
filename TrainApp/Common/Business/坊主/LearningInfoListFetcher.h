//
//  LearningInfoListFetcher.h
//  TrainApp
//
//  Created by 郑小龙 on 17/2/16.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListFetcherBase.h"
#import "MasterLearningInfoListRequest.h"
@interface LearningInfoListFetcher : PagedListFetcherBase
@property (nonatomic, copy) NSString *ifhg;
@property (nonatomic, copy) NSString *ifcx;
@property (nonatomic, copy) NSString *ifxx;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *barId;
@property (nonatomic, copy) void(^learningInfoListFetcherBlock)(MasterLearningInfoListRequestItem_Body *body);
@end
